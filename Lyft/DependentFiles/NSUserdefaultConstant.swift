//
//  NSUserdefaultConstant.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import Foundation

let kUserId = "userId"
let kLoginUserName = "LoginUserName"
let kDeviceToken = "kDeviceToken"
let kSessionAccessToken = "token"
let kDeviceDetails = "deviceDetails"
let klanguage = "language"
let skipUserLogin = "skipUserLogin"
let kPassword = "Password"
let kEmailAndMobile = "EmailAndMobile"
let kEmailLogin = "emailLogin"
let kUserProfilePicture = "profilePicture"
let kMobileNumber = "mobileNumber"
let kRegCompleted = "RegCompleted"
let kEmailVerified = "email_verified"
let memberShipID = "membership_id"

let settingEmailNotification = "settingEmailNotification"
let settingSMSNotification = "settingSMSNotification"
let settingRemindClassesNotification = "settingRemindClassesNotification"

func resetAllUserDefaults() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        if key != kDeviceToken {
           defaults.removeObject(forKey: key)
        }
    }
}
