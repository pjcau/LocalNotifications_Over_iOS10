//
//  AttachmentIdentifier.swift
//  iOS10_LocalNotifications
//
//  Created by Cau Pierre Jonny on 2017-09-26.
//  Copyright © 2017 Cau Pierre Jonny . All rights reserved.
//

import Foundation

@objc public class AttachmentIdentifier: NSObject {

    private static let instance = {
        return  AttachmentIdentifier()
    }()

    @objc public static func shared() -> AttachmentIdentifier {

        return AttachmentIdentifier.instance
    }

    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }

    @objc public func request() -> String { return "requestIdentifier"}
    @objc public func reply() -> String { return "replyIdentifier"}
    @objc public func share() -> String { return "shareIdentifier"}
    @objc public func follow() -> String { return "followIdentifier"}
    @objc public func destructive() -> String { return "destructiveIdentifier"}
    @objc public func direction() -> String { return "directionIdentifier"}
    @objc public func category() -> String { return "categoryIdentifier"}
    @objc public func image() -> String { return "imageIdentifier"}
    @objc public func video() -> String { return "videoIdentifier"}
    @objc public func customContent() -> String { return "customContentIdentifier"}

}
