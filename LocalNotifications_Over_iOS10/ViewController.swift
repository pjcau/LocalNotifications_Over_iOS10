//
//  ViewController.swift
//  iOS10_LocalNotifications
//
//  Created by Cau Pierre Jonny on 2017-09-26.
//  Copyright © 2017 Cau Pierre Jonny . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func scheduleSimpleNotificationAction(_ sender: AnyObject) {

        let notificationObj = NotificationObject(notification: .eventScheduleType, id: "simple", title: "iOS New Api Ntification", subtitle: "Simple Notification", body: "Remember to finalize your presentation for tomorrow!", badgeCount: nil, repeats: .minutely, date: Date(), userInfo: [:])

        NotificationManager.shared().scheduleNotification(notificationObj:notificationObj)
    }

    @IBAction func scheduleCustomNotificationAction(_ sender: AnyObject) {

        let notificationObj = NotificationObject(notification: .eventScheduleType, id: "custom", title: "iOS New Api Notification", subtitle: "Custom Notification", body: "Remember to finalize your presentation for tomorrow!", badgeCount: nil, repeats: .minutely, date: Date(), userInfo: [:], media: AttachmentIdentifier.shared().image(), mediaUrl:"kandinsky.jpg" )

        NotificationManager.shared().scheduleNotification(notificationObj:notificationObj)
    }
    @IBAction func howManyScheduledAction(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.shared().pending { [weak self] pending in
                self?.showAlert(message: "\(pending) pending notifications")
            }
        } else {
            showAlert(message: "Pending notifications are only available in iOS 10")
        }
    }
    @IBAction func howManyDeliveredAction(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.shared().delivered { [weak self] deliveredCount in
                self?.showAlert(message: "\(deliveredCount) delivered notifications")
            }
        } else {
            showAlert(message: "Delivered notifications are only available in iOS 10")
        }
    }
    @IBAction func removeAllPending(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.shared().removeAllPending()
        } else {
            showAlert(message: "Remove all pending notifications are only available in iOS 10")
        }
    }
    @IBAction func removeAllDelivery(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.shared().removeAlldelivery()
        } else {
            showAlert(message: "Remove all pending notifications are only available in iOS 10")
        }
    }

}

extension Date {
    func add(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
}
