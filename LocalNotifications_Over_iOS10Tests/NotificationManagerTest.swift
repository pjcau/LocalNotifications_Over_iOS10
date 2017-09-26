//
//  NotificationManager.swift
//  LocalNotifications_Over_iOS10Tests
//
//  Created by Pierre jonny cau on 26/09/2017.
//  Copyright © 2017 Robots and Pencils. All rights reserved.
//

import XCTest
@testable import LocalNotifications_Over_iOS10

class NotificationManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNOtificationManagerInit() {
        // This is an example of a functional test case.
        let manager =  NotificationManager()
        XCTAssertNotNil(manager)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
