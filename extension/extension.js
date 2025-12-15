const vscode = require('vscode');
const { spawn } = require('child_process');

function activate(context) {
  const output = vscode.window.createOutputChannel('Askal');

  const tasks = [
    { command: 'dayz.buildPBO', label: 'Build PBO', psAction: 'Build' },
    { command: 'dayz.startServer', label: 'Start Server', psAction: 'Server' },
    { command: 'dayz.startClient', label: 'Start Client', psAction: 'Client' },
    { command: 'dayz.killInstances', label: 'Kill DayZ', psAction: 'Kill' },
    { command: 'dayz.automateTest', label: 'Auto Test', psAction: 'Full' },
    { command: 'dayz.getLogs', label: 'Get Logs', psAction: 'GetLogs' }
  ];

  // Criar botões na barra de status
  tasks.forEach(({ command, label, task }) => {
    const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    statusBarItem.command = command;
    statusBarItem.text = label;
    statusBarItem.tooltip = `Click to run: ${task}`;
    statusBarItem.show();

    context.subscriptions.push(
      vscode.commands.registerCommand(command, async () => {
        const cwd = (vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders[0].uri.fsPath) || undefined;

        if (task && task.psAction) {
          const action = task.psAction;
          const psArgs = ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', 'AUTORUN.ps1', '-Action', action];

          output.show(true);
          output.appendLine(`> Running AUTORUN.ps1 -Action ${action}`);

          vscode.window.showInformationMessage(`Started: ${task.label}`);

          // Run via child_process so we can capture output and show notifications
          const proc = spawn('powershell', psArgs, { cwd, shell: true });

          proc.stdout.on('data', (data) => {
            output.append(data.toString());
          });
          proc.stderr.on('data', (data) => {
            output.append(data.toString());
          });

          proc.on('close', (code) => {
            output.appendLine(`Process exited with code ${code}`);
            if (code === 0) {
              vscode.window.showInformationMessage(`${task.label} completed successfully`);
            } else {
              vscode.window.showErrorMessage(`${task.label} failed (exit code ${code}). See Output: Askal`);
            }
          });
        } else {
          // Fallback: run in terminal
          const termName = 'Askal';
          let term = vscode.window.terminals.find(t => t.name === termName);
          if (!term) term = vscode.window.createTerminal({ name: termName, cwd });
          term.show(true);
          term.sendText(task, true);
          vscode.window.showInformationMessage(`Started: ${task.label}`);
        }
      })
    );

    context.subscriptions.push(statusBarItem);
  });

  console.log('DayZ Mod Tools extension activated!');
}

function deactivate() {}

module.exports = {
  activate,
  deactivate
};
