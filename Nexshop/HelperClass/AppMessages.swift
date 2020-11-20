//
//  AppMessages.swift
//  Nexshop
//
//  Created by Mac on 30/09/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

private let _sharedInstance = AppMessages()


class AppMessages: NSObject {

    class var sharedInstance: AppMessages {
        return _sharedInstance
        
        
        
        
    }
    
}

struct LocalValidations {
    
    static let checkinternetConnection:String = "Please check your internet connection"
    
    static let enterEmailAddress:String = "Please enter your email address"
    
    static let enterEmailValidAddress:String = "Please enter your valid email address"
    
    static let enterPassword:String = "Please enter your password"
    
    static let enterFullName:String = "Please enter your full name"
    
    static let enterUserName:String = "Please enter your username"
    
    static let enterMobileNumber:String = "Please enter your mobile number"
    
    static let ServerError:String = "Server error.please try again later"
    
    static let EnterOTP:String = "Please enter OTP"
    
    static let SelectAddress:String = "Please select address"
    
    static let usernotavalible:String = "Username not avalible"
    
    static let ValidMobileNumber:String = "Please enter valid mobile number"
    
    
    
}
