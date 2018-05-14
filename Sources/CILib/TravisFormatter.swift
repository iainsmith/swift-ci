import Foundation

class TravisFormatter {
    let dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateStyle = .short
        d.timeStyle = .medium
        return d
    }()

    let componentsFormatter: DateComponentsFormatter = {
        let d = DateComponentsFormatter()
        d.unitsStyle = .short
        return d
    }()

    func string(from ti: Int?) -> String {
        if let interval = ti {
            return componentsFormatter.string(from: TimeInterval(interval))!
        }

        return "unknown"
    }

    func string(from ti: Date?) -> String {
        if let interval = ti {
            return dateFormatter.string(from: interval)
        }

        return "unknown"
    }
}
