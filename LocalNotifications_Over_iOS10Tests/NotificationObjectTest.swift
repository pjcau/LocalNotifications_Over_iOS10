//
//  NotificationObject.swift
//  LocalNotifications_Over_iOS10Tests
//
//  Created by Pierre jonny cau on 26/09/2017.
//  Copyright © 2017 Robots and Pencils. All rights reserved.
//

import XCTest

@testable import LocalNotifications_Over_iOS10

class NotificationObjectTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotificationObject() {
        // This is an example of a functional test case.
        let notificationObj = NotificationObject.init(notification: .EventScheduleType, id: "alert", title: "iOS Presentation", subtitle: "Friday September 16th", body: "Remember to finalize your presentation for tomorrow!", badgeCount: nil, repeats: .Minutely, date: Date(), userInfo: [:])
        
        XCTAssertEqual("iOS Presentation", notificationObj.title)
        XCTAssertEqual("EventScheduleType"+"alert", notificationObj.id)
        XCTAssertEqual("Friday September 16th", notificationObj.subtitle)
        XCTAssertEqual("Remember to finalize your presentation for tomorrow!", notificationObj.body)

        XCTAssertNotNil(notificationObj.notification)
        XCTAssertNotNil(notificationObj.repeats)

        XCTAssertNil(notificationObj.badgeCount)
    }
    
}
