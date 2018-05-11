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
    
    @objc public static func shared() -> NotificationManager {
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
    
    @objc public func scheduleNotification(notificationObj notificationObject:NotificationObject) {
        
        if #available(iOS 10.0, *) {
            NotificationManager.shared().scheduleUNUserNotification(notificationObj:notificationObject)
        } else {
            NotificationManager.shared().scheduleUILocalNotification(body: notificationObject.body)
        }
    }
    
    @available(iOS 10.0, *)
    @objc public func requestAuthorization(completion: ((_ granted: Bool) -> Void)? = nil) {
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
    @objc public func setupCategories(_ categories: Set<UNNotificationCategory>) {
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories(categories)
    }
    
    @available(iOS 10.0, *)
    @objc public func getNotificationSettings(completion: ((_ value: UNAuthorizationStatus) -> Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            completion?(settings.authorizationStatus)
        }
    }
    
    @available(iOS 10.0, *)
    @objc public func pending(completion: @escaping (_ pendingCount: [UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
    
    @available(iOS 10.0, *)
    @objc public func delivered(completion: @escaping (_ deliveredCount: [UNNotification]) -> Void) {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            completion(notifications)
        }
    }
    
    @available(iOS 10.0, *)
    @objc public func removePending(withIdentifiers identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    @available(iOS 10.0, *)
    @objc public func removeAllPending() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    @available(iOS 10.0, *)
    @objc public func removeDelivery(withIdentifiers identifiers: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
    }
    
    @available(iOS 10.0, *)
    @objc public func removeAlldelivery() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    @available(iOS 10.0, *)
    @objc public func checkStatus() {
    }
    
    @available(iOS 10.0, *)
    @objc public func action(id: String, title: String, options: UNNotificationActionOptions = []) -> UNNotificationAction {
        
        let action = UNNotificationAction(identifier: id, title: title, options: options)
        
        return action
    }
    
    @available(iOS 10.0, *)
    @objc public func category(identifier: String, action:[UNNotificationAction],  intentIdentifiers: [String], options: UNNotificationCategoryOptions = []) -> UNNotificationCategory {
        
        let category = UNNotificationCategory(identifier: identifier, actions: action, intentIdentifiers: intentIdentifiers, options: options)
        
        return category
    }
    
    // MARK: Private
    
    @available(iOS 10.0, *)
    private func scheduleUNUserNotification(notificationObj:NotificationObject) {
        requestAuthorization { _ in
            var content = NotificationManager.shared().createNotificationContent(notificationObj: notificationObj)
            
            let trigger = NotificationManager.shared().calendarNotificationTrigger(notificationObj.notification, notificationObj.date,notificationObj.repeats)
            
            content =  NotificationManager.shared().customCategory(notificationObj, content)
            
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
    private func createNotificationContent(notificationObj:NotificationObject) -> UNMutableNotificationContent {
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
        
        return content
    }
    
    // MARK: iOS 9 UILocalNotification support
    
    private func scheduleUILocalNotification(body: String) {
        let localNotification = UILocalNotification()
        localNotification.fireDate = Date().addingTimeInterval(1)
        localNotification.alertBody = body
        localNotification.timeZone = TimeZone.current
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
    
    // MARK: Sample triggers
    
    @available(iOS 10.0, *)
    private func createTimeIntervalNotificationTrigger() -> UNTimeIntervalNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    }
    
    @available(iOS 10.0, *)
    private func calendarNotificationTrigger(_ notificationType:NotificationType, _ date:Date, _ repeatDate:Repeats) -> UNCalendarNotificationTrigger? {
        
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
    private func customCategory( _ notificationObj:NotificationObject , _ content : UNMutableNotificationContent ) -> UNMutableNotificationContent {
        
        if let name = notificationObj.mediaUrl, let media = notificationObj.media, let url = UIHelper.saveImage(name: name,path:  notificationObj.mediaPath ) {
            print("url is \(url)")
            
            let attachment = try? UNNotificationAttachment(identifier: media,
                                                           url: url,
                                                           options: [:])
            
            if let attachment = attachment {
                content.attachments.removeAll(keepingCapacity: true)
                content.attachments.append(attachment)
            }
            content.categoryIdentifier = media
            
        }
        return content
    }
    
    @available(iOS 10.0, *)
    private func createLocationNotificationTrigger() -> UNLocationNotificationTrigger {
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
        completionHandler( [.alert, .badge, .sound])
    }
    
}

