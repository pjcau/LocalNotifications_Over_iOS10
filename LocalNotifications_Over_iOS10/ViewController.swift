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
        @IBAction func scheduleNotificationAction(_ sender: AnyObject) {
            let notificationObj = NotificationObject(notification: .eventScheduleType, id: "alert", title: "iOS Presentation", subtitle: "Friday September 16th", body: "Remember to finalize your presentation for tomorrow!", badgeCount: nil, repeats: .minutely, date: Date(), userInfo: [:])
        NotificationManager.scheduleNotification(notificationObj:notificationObj)
    }
        @IBAction func howManyScheduledAction(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.pending { [weak self] pending in
                self?.showAlert(message: "\(pending) pending notifications")
            }
        } else {
            showAlert(message: "Pending notifications are only available in iOS 10")
        }
    }
        @IBAction func howManyDeliveredAction(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.delivered { [weak self] deliveredCount in
                self?.showAlert(message: "\(deliveredCount) delivered notifications")
            }
        } else {
            showAlert(message: "Delivered notifications are only available in iOS 10")
        }
    }
        @IBAction func removeAllPending(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.removeAllPending()
        } else {
            showAlert(message: "Remove all pending notifications are only available in iOS 10")
        }
    }
        @IBAction func removeAllDelivery(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            NotificationManager.removeAlldelivery()
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
