//
//  NotificationObject.swift
//  iOS10_LocalNotifications
//
//  Created by Cau Pierre Jonny on 2017-09-26.
//  Copyright © 2017 Cau Pierre Jonny . All rights reserved.
//

import Foundation
import UserNotifications

public enum NotificationType : String {
    case noneType = "NoneType"
    case eventScheduleType = "EventScheduleType"
    case twoWeekReminderType = "TwoWeekReminderType"
    case slideShowWillExpiredType = "SlideShowWillExpiredType"
}

public enum Repeats: String {
    case none, minutely, hourly, daily, weekly, monthly, yearly
}

@objc public class NotificationObject : NSObject {

    var notification: NotificationType
    var id: String
    var title: String
    var subtitle: String
    var body: String
    var badgeCount: NSNumber?
    var repeats : Repeats
    var date:Date
    var userInfo: [AnyHashable: Any] = [:]

    var attachment : Array<Any>?

    public init(notification: NotificationType, id: String, title: String, subtitle: String, body: String, badgeCount: NSNumber?, repeats : Repeats, date:Date, userInfo: [AnyHashable: Any] = [:]) {
        self.notification = notification
        self.id = notification.rawValue + id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.badgeCount = badgeCount
        self.repeats = repeats
        self.date = date
        self.userInfo = userInfo
        super.init()
    }

    @available(iOS 10.0, *)
    public func addAttachment(_ urlPathFile:String) {
        let attachmentURL = NSURL.fileURL(withPath: urlPathFile)
        if let attachment = try? UNNotificationAttachment(identifier: "attachment", url: attachmentURL, options: nil) {
            self.attachment?.append(attachment)
        }
    }

}
