const vscode = require('vscode');

function activate(context) {
    const disposable = vscode.commands.registerCommand(
        'copy-relative-path-scm.copyRelativePath',
        async (resource) => {
            if (!resource?.resourceUri) return;

            const workspaceFolder = vscode.workspace.getWorkspaceFolder(resource.resourceUri);
            if (!workspaceFolder) return;

            const relativePath = vscode.workspace.asRelativePath(resource.resourceUri, false);
            await vscode.env.clipboard.writeText(relativePath);
            vscode.window.setStatusBarMessage(`Copied: ${relativePath}`, 2000);
        }
    );
    context.subscriptions.push(disposable);
}

function deactivate() {}

module.exports = { activate, deactivate };
