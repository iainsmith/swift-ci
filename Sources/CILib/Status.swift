import Dispatch
import Foundation
import Rainbow
import ShellOut
import TravisClient

enum CIState {
    case unknown
    case failed
    case passed
}

/// Check if current commit has been pushed to the remote
/// If pushed:
///   If current branch name:
///   else error
public func checkCIForCurrentCommit(using token: String) throws {
    let slug = try shellOut(to: .gitBaseName())
    let branch = try shellOut(to: .gitBranchName())

    /// Try and find the latest sha
    _ = try shellOut(to: .gitCurrentCommitSha())

    let queue = DispatchQueue(label: "com.queue")
    let semaphore = DispatchSemaphore(value: 0)
    let client = TravisClient(token: token, queue: queue)

    print("Checkin travis status for \(slug) \(branch)")

    var build: Build!

    client.branch(forRepo: slug, withIdentifier: branch) { result in
        let embed = result[\Branch.lastBuild]
        client.follow(embed: embed, completion: { buildResult in
            build = buildResult.object!
            semaphore.signal()
        })
    }

    semaphore.standardWait()

    let branchName = build.branch[\MinimalBranch.name]

    let formatter = TravisFormatter()

    let successMessage = """
    Latest build for branch: \(branchName)

    \("Commit:".yellow)        \(build.commit[\MinimalCommit.sha])
    \("State:".yellow)         \(build.state)
    \("Type:".yellow)          \(build.eventType)
    \("Branch:".yellow)        \(branchName)
    \("Compare URL:".yellow)   https://github.com/iainsmith/swift-ci/compare/4a628a4b149e...d5f9e4515455
    \("Duration:".yellow)      \(formatter.string(from: build.duration))
    \("Started:".yellow)       \(formatter.string(from: build.startedAt))
    \("Finished:".yellow)      \(formatter.string(from: build.finishedAt))
    """

    print(successMessage)

    let sem = DispatchSemaphore(value: 0)
    var message = ""
    client.jobs(forBuild: String(build.id)) { jobResult in
        guard let jobs = jobResult.object else { return }
        let messages = jobs.map { job -> String in
            let duration = job.build[\MinimalBuild.duration]
            let state = job.state == "passed" ? job.state.green : job.state.red
            return "\(job.number) \(state):   \(formatter.string(from: duration))"
        }

        message = messages.joined(separator: "\n")
        sem.signal()
    }

    sem.standardWait()
    print("\nJob(s):\n\(message)\n")
}
