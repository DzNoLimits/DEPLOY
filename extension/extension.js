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
  const spinnerIntervals = new Map();
  const statusItems = new Map();

  const frames = ['|', '/', '-', '\\'];

  tasks.forEach(({ command, label, psAction }) => {
    const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    statusBarItem.command = command;
    statusBarItem.text = label;
    statusBarItem.tooltip = psAction ? `Run: AUTORUN.ps1 -Action ${psAction}` : `Click to run: ${label}`;
    statusBarItem.show();
    statusItems.set(command, statusBarItem);

    context.subscriptions.push(
      vscode.commands.registerCommand(command, async () => {
        const cwd = (vscode.workspace.workspaceFolders && vscode.workspace.workspaceFolders[0].uri.fsPath) || undefined;
        if (psAction) {
          if (running.get(command)) {
            // already running; visually no-op
            return;
          }

          const action = psAction;
          const psArgs = ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', 'AUTORUN.ps1', '-Action', action];

          output.show(true);
          output.appendLine(`> Running AUTORUN.ps1 -Action ${action}`);

          // Mark running
          running.set(command, true);
          // If this action includes a build (Full), lock the build button too to avoid concurrent builds
          if (command === 'dayz.automateTest') {
            running.set('dayz.buildPBO', true);
            const buildItem = statusItems.get('dayz.buildPBO');
            if (buildItem) {
              buildItem.command = undefined;
              buildItem.tooltip = `Locked by: ${label}`;
              buildItem.text = `${frames[0]} Build PBO`;
            }
          }

          // Start spinner
          let idx = 0;
          statusBarItem.command = undefined; // disable while running
          statusBarItem.tooltip = `Running: ${label}`;
          const iv = setInterval(() => {
            statusBarItem.text = `${frames[idx]} ${label}`;
            idx = (idx + 1) % frames.length;
          }, 200);
          spinnerIntervals.set(command, iv);

          // Run via child_process to capture output
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
            if (command === 'dayz.automateTest') {
              running.delete('dayz.buildPBO');
              const buildItem = statusItems.get('dayz.buildPBO');
              if (buildItem) {
                clearInterval(spinnerIntervals.get('dayz.buildPBO'));
                spinnerIntervals.delete('dayz.buildPBO');
                buildItem.text = 'Build PBO';
                buildItem.command = 'dayz.buildPBO';
                buildItem.tooltip = `Run: AUTORUN.ps1 -Action Build`;
              }
            }
            clearInterval(spinnerIntervals.get(command));
            spinnerIntervals.delete(command);
            // show final state on button
            if (code === 0) {
              statusBarItem.text = `✔ ${label}`;
            } else {
              statusBarItem.text = `✖ ${label}`;
            }
            // restore after short delay
            setTimeout(() => {
              statusBarItem.text = label;
              statusBarItem.command = command;
              statusBarItem.tooltip = psAction ? `Run: AUTORUN.ps1 -Action ${psAction}` : `Click to run: ${label}`;
            }, 2000);
          });
        } else {
          // Fallback: run in terminal
          const termName = 'Askal';
          let term = vscode.window.terminals.find(t => t.name === termName);
          if (!term) term = vscode.window.createTerminal({ name: termName, cwd });
          term.show(true);
          term.sendText(label, true);
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
