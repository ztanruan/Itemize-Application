//
//  Enum.swift
//  RedButton
//
//  Created by Zignuts Technolab on 27/03/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import Foundation
import UIKit

struct ValidationExpression {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let password = "(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*])(?=.*[a-z]).{6,}"
    static let characterSpace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ "
    static let numeric = "0123456789"
}

struct staticLengths {
    static let name_chanracted = 50
    static let phoneNo_chanracted = 15
}


struct StaticValues {
    static let Phone_number = "1234567890"
    static let ListingLimit = 30
}

struct Static_Height {
    static let collection_Height = UIScreen.main.bounds.width * 0.44
    static let WithoutData_Height = UIScreen.main.bounds.width * 0.22
}



struct SMNotification{
    static let updateUserProfile = "local_noti_update_userProfile"
}

struct AppMessage {
    static let status = "status"
    static let Ok = "Ok"
    static let login = "login"
    static let Cancel = "Cancel"
    static let userData = "userdata"
    static let intro_Slider = "intro_slider"
    static let uID = "user_id"
    static let plzWait = "Please wait..."
    static let firebase_token = "firebase_token"
    static let device_token = "device_token"
    static let device_tokenData = "device_tokenData"
    static let category = "category_list"
    static let is_biometricLock = "Biometric_lock"
    static let passworddddd = "password"
}

enum ScreenType {
    case none
    case is_TypesScreen
    case is_brandScreen
    case is_locationScreen
    case is_firstInfo
    case is_secondInfo
    case is_thirdInfo
    case is_AdminCategory
    case is_AdminCategoryType
    case is_AdminCategoryTypeBrand
    case is_AdminCategoryTypeBrandLocation
}

struct APPDateFormates {
    static let shortYYYYMMDD = "YYYY-MM-dd"
    static let shortDDMMYYYY = "dd-MM-YYYY"
    static let serverFormate = "YYYY-MM-dd HH:mm:ss"
    static let longFormate = "dd-MM-YYYY hh:mm a"
}

struct AppColor {
    static let gray = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    static let blue = #colorLiteral(red: 0.05490196078, green: 0.1254901961, blue: 0.2274509804, alpha: 1)
    static let yellow = #colorLiteral(red: 1, green: 0.7490196078, blue: 0, alpha: 1)
    static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let green = #colorLiteral(red: 0.1294117647, green: 0.7568627451, blue: 0.4784313725, alpha: 1)
    static let red =  #colorLiteral(red: 0.8352941176, green: 0.2274509804, blue: 0.2274509804, alpha: 1)
    static let goldenColor = #colorLiteral(red: 1, green: 0.6078431373, blue: 0.007843137255, alpha: 1)
    static let swocaseblueColor = #colorLiteral(red: 0.05490196078, green: 0.1254901961, blue: 0.2274509804, alpha: 1).withAlphaComponent(0.9)
}

enum GradientDirection {
    case Right
    case Left
    case Bottom
    case Top
    case TopLeftToBottomRight
    case TopRightToBottomLeft
    case BottomLeftToTopRight
    case BottomRightToTopLeft
}


struct kUserdefaultKey {
    static let verificationid = "verificationid"
}







