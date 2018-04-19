import Foundation
import Yams
import TravisClient
import Dispatch

enum ScriptError: Error {
    case noInput
}

let successMessage = """
    /// Run the following to commit the .travis.yml
    git add .travis.yml && git commit -m "Setup travis.org for swift 4.0 & 4.1 "
"""

public func saveYAMLToCurrentDirectory(apiToken: String) throws {
    let savePath = "./.travis.yml"
    let yaml = try TravisYAML.standardSPM.toYaml()
    try yaml.write(toFile: savePath, atomically: true, encoding: .utf8)
    let activated = try enableRepository(apiToken: apiToken)
    if activated { print(successMessage) }
}

let queue = DispatchQueue(label: "hello", attributes: .concurrent)

public func enableRepository(apiToken: String) throws -> Bool{
    let start = """

        Enter the github repository name:
        e.g rails/rails

    """

    print(start)

    guard let repoName = readLine(strippingNewline: true) else { throw ScriptError.noInput }

    let semaphore = DispatchSemaphore(value: 0)
    let client = TravisClient(token: apiToken, queue: queue)
    var activated: Bool = false

    client.activateRepository(repoName) { (result) in
        activated = result.value?[\Repository.active] ?? false
        semaphore.signal()
    }

    _ = semaphore.wait(wallTimeout: (.now() + .seconds(10)))
    let prefix = activated ? "Activated" : "Unable to activate"
    print("\(prefix) \(repoName)")
    return activated
}
