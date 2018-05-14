import Dispatch

extension DispatchSemaphore {
    func standardWait() {
        _ = wait(wallTimeout: (.now() + .seconds(10)))
    }
}
