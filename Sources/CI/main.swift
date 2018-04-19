import CILib
import Commander

func run(_ closure: @autoclosure () throws -> Void) {
    do {
        try closure()
    } catch {
        print("Sorry something went wrong \(error)")
    }
}

enum ScriptError: Error {
    case noToken
}

Group() {
    let token = Option("token", default: "", flag: "t", description: "Travis api token")

    $0.command("init", token, { (apiToken) in
        run(try saveYAMLToCurrentDirectory(apiToken: apiToken))
    })
}.run()
