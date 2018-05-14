//
//  NotificationObject.swift
//  iOS10_LocalNotifications
//
//  Created by Cau Pierre Jonny on 2017-09-26.
//  Copyright © 2017 Cau Pierre Jonny . All rights reserved.
//

import Foundation
import UserNotifications

@objc public enum NotificationType : Int {
    case noneType,eventScheduleType,twoWeekReminderType,slideShowWillExpiredType
}

@objc public enum Repeats: Int {
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
    var media : String?
    var mediaUrl :String?
    var mediaPath:String?
    var attachment : Array<Any>?
    var categoryType :String = "none"

    @objc public init(notification: NotificationType, id: String, title: String, subtitle: String, body: String, badgeCount: NSNumber?, repeats : Repeats, date:Date, userInfo: [AnyHashable: Any] = [:], categoryType:String , media: String? = nil, mediaUrl : String? = nil, mediaPath:String? = nil) {
        self.notification = notification
        switch notification {
        case .noneType:
            self.id = "noneType" + id
        case .eventScheduleType:
            self.id = "eventScheduleType" + id
        case .twoWeekReminderType:
            self.id = "twoWeekReminderType" + id
        case .slideShowWillExpiredType:
            self.id = "slideShowWillExpiredType" + id
        }
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.badgeCount = badgeCount
        self.repeats = repeats
        self.date = date
        self.userInfo = userInfo
        self.categoryType = categoryType
        self.media = media
        self.mediaUrl = mediaUrl
        self.mediaPath = mediaPath
        super.init()
    }

    @available(iOS 10.0, *)
    @objc public func addAttachment(_ urlPathFile:String) {
        let attachmentURL = NSURL.fileURL(withPath: urlPathFile)
        if let attachment = try? UNNotificationAttachment(identifier: "attachment", url: attachmentURL, options: nil) {
            self.attachment?.append(attachment)
        }
    }

}
