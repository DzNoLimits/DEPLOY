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
  const running = new Map();
  tasks.forEach(({ command, label, psAction }) => {
    const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    statusBarItem.command = command;
    statusBarItem.text = label;
    statusBarItem.tooltip = psAction ? `Run: AUTORUN.ps1 -Action ${psAction}` : `Click to run: ${label}`;
    statusBarItem.show();

    context.subscriptions.push(
      vscode.commands.registerCommand(command, async () => {
        const cwd = (vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders[0].uri.fsPath) || undefined;
        if (psAction) {
          if (running.get(command)) {
            vscode.window.showWarningMessage(`${label} is already running.`);
            return;
          }

          const action = psAction;
          const psArgs = ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', 'AUTORUN.ps1', '-Action', action];

          output.show(true);
          output.appendLine(`> Running AUTORUN.ps1 -Action ${action}`);

          vscode.window.showInformationMessage(`Started: ${label}`);

          // Mark running
          running.set(command, true);

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
            running.delete(command);
            if (code === 0) {
              vscode.window.showInformationMessage(`${label} completed successfully`);
            } else {
              vscode.window.showErrorMessage(`${label} failed (exit code ${code}). See Output: Askal`);
            }
          });
        } else {
          // Fallback: run in terminal
          const termName = 'Askal';
          let term = vscode.window.terminals.find(t => t.name === termName);
          if (!term) term = vscode.window.createTerminal({ name: termName, cwd });
          term.show(true);
          term.sendText(label, true);
          vscode.window.showInformationMessage(`Started: ${label}`);
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
