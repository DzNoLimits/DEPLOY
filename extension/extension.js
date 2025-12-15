const vscode = require('vscode');

function activate(context) {
  const tasks = [
    { command: 'dayz.buildPBO', label: '🔨 Build PBO', task: '🔨 Build PBO' },
    { command: 'dayz.startServer', label: '🔌 Start Server', task: '🔌 Start Server' },
    { command: 'dayz.startClient', label: '🎮 Start Client', task: '🎮 Start Client' },
    { command: 'dayz.killInstances', label: '🛑 KILL', task: '🛑 KILL' },
    { command: 'dayz.automateTest', label: '🚀 AUTO', task: '🚀 AUTO' },
    { command: 'dayz.getLogs', label: '📖 Get-Logs', task: '📖 Get-Logs' }
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
        vscode.commands.executeCommand('workbench.action.tasks.runTask', task);
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
