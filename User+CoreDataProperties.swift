//
//  User+CoreDataProperties.swift
//  MyCoreData
//
//  Created by Ramazan Abdullayev on 12.10.21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var logout: Bool
    @NSManaged public var profileImage: String?
    @NSManaged public var openProductSection: Bool
    @NSManaged public var language: String?
    @NSManaged public var fcmToken: String?
    @NSManaged public var wasUserChoosenLanguageBefore: Bool
    @NSManaged public var wasAppAlreadyOpenedForFirstTime: Bool
    @NSManaged public var smsOtpAutoFill: Bool
    @NSManaged public var secureBalance: Bool
    @NSManaged public var biometric: Bool
    @NSManaged public var registrationId: String?
    @NSManaged public var userLoging: Bool
    @NSManaged public var passcode: String?
    @NSManaged public var username: String?
}

extension User : Identifiable {

}
