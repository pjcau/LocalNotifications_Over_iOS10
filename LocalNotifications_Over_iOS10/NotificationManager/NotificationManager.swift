//
//  NotificationManager.swift
//  iOS10_LocalNotifications
//
//  Created by Cau Pierre Jonny on 2017-09-26.
//  Copyright © 2017 Cau Pierre Jonny . All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation
import UIKit
import SwiftDate

@objc public class NotificationManager: NSObject {

    private static let singletonInstance = {
        return  NotificationManager()
    }()

    @objc public class func shared() -> NotificationManager {
        if #available(iOS 10.0, *) {
            if  UNUserNotificationCenter.current().delegate ==  nil {
                UNUserNotificationCenter.current().delegate = NotificationManager.singletonInstance
            }
        } else {
            // Fallback on earlier versions
        }
        return NotificationManager.singletonInstance
    }

    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }

    // MARK: Public

    @objc public class func scheduleNotification(notificationObj notificationObject:NotificationObject) {

        if #available(iOS 10.0, *) {
            scheduleUNUserNotification(notificationObj:notificationObject)
        } else {
            scheduleUILocalNotification(body: notificationObject.body)
        }
    }

    @available(iOS 10.0, *)
    @objc public class func requestAuthorization(completion: ((_ granted: Bool) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, _) in
            if granted {
                completion?(true)
            } else {
                center.getNotificationSettings(completionHandler: { settings in
                    if settings.authorizationStatus != .authorized {
                        //User has not authorized notifications
                    }
                    if settings.lockScreenSetting != .enabled {
                        //User has either disabled notifications on the lock screen for this app or it is not supported
                    }
                    completion?(false)
                })
            }
        }
    }

    @available(iOS 10.0, *)
    @objc public class func pending(completion: @escaping (_ pendingCount: [UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests)
        }
    }

    @available(iOS 10.0, *)
    @objc public class func delivered(completion: @escaping (_ deliveredCount: [UNNotification]) -> Void) {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            completion(notifications)
        }
    }

    @available(iOS 10.0, *)
    @objc public class func removePending(withIdentifiers identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    @available(iOS 10.0, *)
    @objc public class func removeAllPending() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    @available(iOS 10.0, *)
    @objc public class func removeDelivery(withIdentifiers identifiers: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }

    @available(iOS 10.0, *)
    @objc public class func removeAlldelivery() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    @available(iOS 10.0, *)
    @objc public class func checkStatus() {
    }

    // MARK: Private

    @available(iOS 10.0, *)
    private class func scheduleUNUserNotification(notificationObj:NotificationObject) {
        requestAuthorization { _ in
            let content = createNotificationContent(notificationObj: notificationObj)

            let trigger = calendarNotificationTrigger(notificationObj.notification, notificationObj.date,notificationObj.repeats)

            let request = UNNotificationRequest(identifier: notificationObj.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                // Use this block to determine if the notification request was added successfully.
                if error == nil {
                    NSLog("Notification scheduled")
                } else {
                    NSLog("Error scheduling notification")
                }
            }
        }
    }

    @available(iOS 10.0, *)
    private class func createNotificationContent(notificationObj:NotificationObject) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = notificationObj.title
        content.subtitle = notificationObj.subtitle
        content.body = notificationObj.body
        content.sound = UNNotificationSound.default()
        content.badge = notificationObj.badgeCount
        content.userInfo = notificationObj.userInfo
        if let attachementFiles =  notificationObj.attachment {
            content.attachments =  attachementFiles as! [UNNotificationAttachment]
        }

        //content.categoryIdentifier = "CPJReminderCategory"

        return content
    }

    // MARK: iOS 9 UILocalNotification support

    private class func scheduleUILocalNotification(body: String) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date().addingTimeInterval(1)
        localNotification.alertBody = body
        localNotification.timeZone = TimeZone.current
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }

    // MARK: Sample triggers

    @available(iOS 10.0, *)
    private class func createTimeIntervalNotificationTrigger() -> UNTimeIntervalNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    }

    @available(iOS 10.0, *)
    private class func calendarNotificationTrigger(_ notificationType:NotificationType, _ date:Date, _ repeatDate:Repeats) -> UNCalendarNotificationTrigger? {

        var repeatBool:Bool = false
        var triggerDate :DateComponents? = nil
        var updateDate = date

        switch notificationType {
        case .twoWeekReminderType: updateDate = updateDate + 2.week
        case .slideShowWillExpiredType: updateDate = updateDate + 2.day - 3.hour
        default: break
        }

        if repeatDate != .none {
            repeatBool = true
            switch repeatDate {
            case .minutely: triggerDate = Calendar.current.dateComponents([.second], from: updateDate)
            case .hourly: triggerDate = Calendar.current.dateComponents([.minute,.second], from: updateDate)
            case .daily: triggerDate = Calendar.current.dateComponents([.hour,.minute,.second], from: updateDate)
            case .weekly: triggerDate = Calendar.current.dateComponents([.day,.hour,.minute,.second], from: updateDate)
            case .monthly: triggerDate = Calendar.current.dateComponents([.weekday,.day,.hour,.minute,.second], from: updateDate)
            case .yearly: triggerDate = Calendar.current.dateComponents([.month,.weekday, .day,.hour,.minute,.second], from: updateDate)
            default: break
            }

            return UNCalendarNotificationTrigger(dateMatching: triggerDate!, repeats: repeatBool)

        } else {
            let  triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: updateDate)

            return UNCalendarNotificationTrigger(dateMatching: triggerDate,  repeats: repeatBool)

        }

    }

    @available(iOS 10.0, *)
    private class func createLocationNotificationTrigger() -> UNLocationNotificationTrigger {
        let cynnyOfficeRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude:43.7825, longitude: 11.2594), radius: 10, identifier: "Cynny")
        cynnyOfficeRegion.notifyOnEntry = true
        cynnyOfficeRegion.notifyOnExit = true

        return UNLocationNotificationTrigger(region: cynnyOfficeRegion, repeats: true)
    }

}

extension String {
    var length: Int {
        return self.count
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {

    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("User Notification Center did receive notification response")
    }

    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("User Notification Center will present notification")
        //show popup on foreground in app
        completionHandler(.alert)
    }

}
