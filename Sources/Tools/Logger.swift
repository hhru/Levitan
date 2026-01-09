import Foundation
import OSLog

internal enum Logger {

    internal static func debug(
        messages: @autoclosure () -> [[Any]],
        subsystem: @autoclosure () -> Any,
        category: @autoclosure () -> Any
    ) {
        #if DEBUG
        let messages = messages()
            .map { message in
                message
                    .map { "\($0)" }
                    .joined(separator: " ")
            }
            .joined(separator: "\n")

        let subsystem = "\(subsystem())"
        let category = "\(category())"

        let logger = os.Logger(
            subsystem: subsystem,
            category: category
        )

        logger.debug("\(messages)")
        #endif
    }

    internal static func debug(
        _ message: @autoclosure () -> [Any],
        subsystem: @autoclosure () -> Any,
        category: @autoclosure () -> Any
    ) {
        debug(
            messages: [message()],
            subsystem: subsystem(),
            category: category()
        )
    }

    internal static func debug(
        _ message1: @autoclosure () -> [Any],
        _ message2: @autoclosure () -> [Any],
        subsystem: @autoclosure () -> Any,
        category: @autoclosure () -> Any
    ) {
        debug(
            messages: [
                message1(),
                message2()
            ],
            subsystem: subsystem(),
            category: category()
        )
    }

    internal static func debug(
        _ message1: @autoclosure () -> [Any],
        _ message2: @autoclosure () -> [Any],
        _ message3: @autoclosure () -> [Any],
        subsystem: @autoclosure () -> Any,
        category: @autoclosure () -> Any
    ) {
        debug(
            messages: [
                message1(),
                message2(),
                message3()
            ],
            subsystem: subsystem(),
            category: category()
        )
    }

    internal static func debug(
        _ message1: @autoclosure () -> [Any],
        _ message2: @autoclosure () -> [Any],
        _ message3: @autoclosure () -> [Any],
        _ message4: @autoclosure () -> [Any],
        subsystem: @autoclosure () -> Any,
        category: @autoclosure () -> Any
    ) {
        debug(
            messages: [
                message1(),
                message2(),
                message3(),
                message4()
            ],
            subsystem: subsystem(),
            category: category()
        )
    }

    internal static func debug(
        _ message1: @autoclosure () -> [Any],
        _ message2: @autoclosure () -> [Any],
        _ message3: @autoclosure () -> [Any],
        _ message4: @autoclosure () -> [Any],
        _ message5: @autoclosure () -> [Any],
        subsystem: @autoclosure () -> Any,
        category: @autoclosure () -> Any
    ) {
        debug(
            messages: [
                message1(),
                message2(),
                message3(),
                message4(),
                message5()
            ],
            subsystem: subsystem(),
            category: category()
        )
    }

    internal static func debug(
        _ message1: @autoclosure () -> [Any],
        _ message2: @autoclosure () -> [Any],
        _ message3: @autoclosure () -> [Any],
        _ message4: @autoclosure () -> [Any],
        _ message5: @autoclosure () -> [Any],
        _ message6: @autoclosure () -> [Any],
        subsystem: @autoclosure () -> Any,
        category: @autoclosure () -> Any
    ) {
        debug(
            messages: [
                message1(),
                message2(),
                message3(),
                message4(),
                message5(),
                message6()
            ],
            subsystem: subsystem(),
            category: category()
        )
    }
}
