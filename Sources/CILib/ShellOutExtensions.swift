import ShellOut

extension ShellOutCommand {
    static func gitBranchName() -> ShellOutCommand {
        return ShellOutCommand(string: "git rev-parse --abbrev-ref HEAD")
    }

    static func gitBaseName() -> ShellOutCommand {
        return ShellOutCommand(string: "git config remote.origin.url | cut -f2 -d: | cut -f1 -d.")
    }

    static func gitCurrentCommitSha() -> ShellOutCommand {
        return ShellOutCommand(string: "git rev-parse HEAD")
    }
}
