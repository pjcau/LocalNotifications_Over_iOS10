//
//  AppDelegate.swift
//  iOS10_LocalNotifications
//
//  Created by Cau Pierre Jonny on 2017-09-26.
//  Copyright © 2017 Cau Pierre Jonny . All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NotificationManagerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Logger.enabled = true
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = NotificationManager.shared()
            NotificationManager.shared().setDelegate(self)
            setupCustomNotification()
        }

        return true
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // Handle local notification with alert or alternative UI
    }

    func setupCustomNotification() {

        // define actions
        if #available(iOS 10.0, *) {
            let ac = NotificationManager.shared().action(id: AttachmentIdentifier.shared().share(), title: "Share")
            let cat = NotificationManager.shared().category(identifier: AttachmentIdentifier.shared().image(), action: [ac], intentIdentifiers: [], options: .allowInCarPlay)
            NotificationManager.shared().setupCategories([cat])
        } else {
            // Fallback on earlier versions
        }

    }

    // MARK - NotificationManagerDelegate's Methods
    @available(iOS 10.0, *)
    func userNotificationManager(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.notification.request.content.categoryIdentifier ==  AttachmentIdentifier.shared().image() {
            Logger.log(message: "categoryIdentifier is Image", event: .info)

            // Retrieve the meeting details.
            switch response.actionIdentifier {
            case AttachmentIdentifier.shared().share():
                Logger.log(message: "Share button pressed on notification", event: .info)

                 break

            case UNNotificationDefaultActionIdentifier,
                 UNNotificationDismissActionIdentifier:
                Logger.log(message: "UNNotificationDefaultActionIdentifier or UNNotificationDismissActionIdentifier", event: .info)
                 break

            default:
                 break
            }
        } else {
            // Handle other notification types...
        }

        completionHandler()

    }

    @available(iOS 10.0, *)
    func userNotificationManager(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        if notification.request.content.categoryIdentifier ==  AttachmentIdentifier.shared().image() {
            Logger.log(message: "categoryIdentifier is Image", event: .info)
            completionHandler([.sound, .alert])
            return

        } else {
            // Handle other notification types...
            completionHandler([.alert])
        }

        completionHandler(UNNotificationPresentationOptions(rawValue: 0))

    }

}
