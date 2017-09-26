//
//  NotificationObject.swift
//  iOS10_LocalNotifications
//
//  Created by Cau Pierre Jonny on 2017-09-26.
//  Copyright © 2017 Cau Pierre Jonny . All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationType : String {
    case NoneType = "NoneType"
    case EventScheduleType = "EventScheduleType"
    case TwoWeekReminderType = "TwoWeekReminderType"
    case SlideShowWillExpiredType = "SlideShowWillExpiredType"
}

enum Repeats: String {
    case None, Minutely, Hourly, Daily, Weekly, Monthly, Yearly
}

class NotificationObject {
    
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
    
    init(notification: NotificationType, id: String, title: String, subtitle: String, body: String, badgeCount: NSNumber?, repeats : Repeats, date:Date, userInfo: [AnyHashable: Any] = [:]) {
        self.notification = notification
        self.id = notification.rawValue + id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.badgeCount = badgeCount
        self.repeats = repeats
        self.date = date
        self.userInfo = userInfo
    }
    
   
    @available(iOS 10.0, *)
    func addAttachment(_ urlPathFile:String) {
        let attachmentURL = NSURL.fileURL(withPath: urlPathFile)
        if let attachment = try? UNNotificationAttachment(identifier: "attachment", url: attachmentURL, options: nil) {
            self.attachment?.append(attachment)
        }
    }
    
}
