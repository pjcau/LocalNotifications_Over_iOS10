//
//  Logger.swift
//  LocalNotifications_Over_iOS10
//
//  Created by Pierre jonny cau on 24/05/2018.
//  Copyright © 2018 Robots and Pencils. All rights reserved.
//

import Foundation

// Enum for showing the type of Log Types
enum LogEvent: String {
    case error = "[‼️]" // error
    case info = "[ℹ️]" // info
    case debug = "[💬]" // debug
    case verbose = "[🔬]" // verbose
    case warning = "[⚠️]" // warning
    case severe = "[🔥]" // severe
}

class Logger {

    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    static var enabled = false //default state

    class func log(message: String,
                   event: LogEvent,
                   fileName: String = #file,
                   line: Int = #line,
                   column: Int = #column,
                   funcName: String = #function) {
        if(!enabled) {
            return
        }

        #if DEBUG
        print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)")
        #endif
    }
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}
