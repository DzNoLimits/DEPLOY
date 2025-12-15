const vscode = require('vscode');

function activate(context) {
  const psCmd = (action) => `powershell -NoProfile -ExecutionPolicy Bypass -File AUTORUN.ps1 -Action ${action}`;

  const tasks = [
    { command: 'dayz.buildPBO', label: 'Build PBO', task: psCmd('Build') },
    { command: 'dayz.startServer', label: 'Start Server', task: psCmd('Server') },
    { command: 'dayz.startClient', label: 'Start Client', task: psCmd('Client') },
    { command: 'dayz.killInstances', label: 'Kill DayZ', task: psCmd('Kill') },
    { command: 'dayz.automateTest', label: 'Auto Test', task: psCmd('Full') },
    { command: 'dayz.getLogs', label: 'Get Logs', task: psCmd('GetLogs') }
  ];

  // Criar botões na barra de status
  tasks.forEach(({ command, label, task }) => {
    const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    statusBarItem.command = command;
    statusBarItem.text = label;
    statusBarItem.tooltip = `Click to run: ${task}`;
    statusBarItem.show();

    context.subscriptions.push(
      vscode.commands.registerCommand(command, () => {
        // Create or reuse an integrated terminal and run the script/command
        const termName = 'Askal';
        let term = vscode.window.terminals.find(t => t.name === termName);
        if (!term) term = vscode.window.createTerminal(termName);
        term.show(true);
        term.sendText(task, true);
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
