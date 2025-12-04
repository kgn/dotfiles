const vscode = require('vscode');

function activate(context) {
    const git = vscode.extensions.getExtension('vscode.git');
    if (!git) return;

    git.activate().then((api) => {
        const gitApi = api.getAPI(1);

        function setupRepo(repo) {
            // Hide input box
            repo.inputBox.visible = false;

            // Update status indicator when state changes
            updateRepoStatus(repo);
            repo.state.onDidChange(() => updateRepoStatus(repo));
        }

        function updateRepoStatus(repo) {
            const staged = repo.state.indexChanges.length;
            const unstaged = repo.state.workingTreeChanges.length;
            const untracked = repo.state.untrackedChanges ? repo.state.untrackedChanges.length : 0;

            // Determine color based on state
            // Priority: staged (green) > unstaged (yellow) > untracked (blue) > clean (default)
            let colorClass = '';
            if (staged > 0) {
                colorClass = '🟢'; // green - has staged changes
            } else if (unstaged > 0) {
                colorClass = '🟡'; // yellow - has unstaged changes
            } else if (untracked > 0) {
                colorClass = '🔵'; // blue - has untracked files
            }

            // Update the SCM provider title with color indicator
            const repoName = repo.rootUri.path.split('/').pop();
            if (colorClass) {
                repo.sourceControl.name = `${colorClass} ${repoName}`;
            } else {
                repo.sourceControl.name = repoName;
            }
        }

        // Setup existing repositories
        gitApi.repositories.forEach(setupRepo);

        // Setup newly opened repositories
        gitApi.onDidOpenRepository(setupRepo);
    });
}

function deactivate() {}

module.exports = { activate, deactivate };
