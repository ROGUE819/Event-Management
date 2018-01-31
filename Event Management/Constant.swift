//
//  Constant.swift
//  Event Management
//
//  Created by DMC1 on 26/12/17.
//  Copyright © 2017 cdac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD
import FirebaseStorage


typealias JSONStandard = [String:Any]
let userdefault = UserDefaults.standard

struct myColor {
    static let appColor:UIColor = UIColor(red: (245.0/255.0), green: (166.0/255.0), blue: (35.0/255.0), alpha: 1)
    static let lightGrey:UIColor = UIColor(red: (155.0/255.0), green: (155.0/255.0), blue: (155.0/255.0), alpha: 1)
    static let lightGreypv:UIColor = UIColor(red: (233.0/255.0), green: (233.0/255.0), blue: (233.0/255.0), alpha: 1)
}


//Header
let headerColor = UIColor.white
let fontName = "Helvetica"
let headerFontSize = CGFloat(24)


//Login 
let loginVCName = "Login"


//Firebase
var ref: DatabaseReference = Database.database().reference()
var storageRef = Storage.storage().reference()
//firebase Key
//let userReg = "userRegistration" //For User detail what user register and used for login


//Validate Mobile
func valideMobile(mobileStr:String) -> Bool{
    let mobileRegEx = "[0-9]{10}"
    let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
    return mobileTest.evaluate(with: mobileStr)
    
}
//Validate Email
func validateEmail(emailStr:String) -> Bool{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: emailStr)
}


struct appMessages {
    static let Error_Title_Message = "Error"
    static let No_Internet_Message = "Check your internet connection."
    static let Empty_Field_Message = "Please fill all the fields."
    static let Mobile_Error_Message = "Please check your mobile number."
    static let Mobile_Password_Error_Message = "Please check mobile or password."
    static let Number_NotRegister_Message = "This number is not Register"
    static let Message_Title_Message = "Message"
    static let Success_Registration_Message = "Registration successfully done."
    static let Email_Error_Message = "Please check your email."
    static let Email_And_Mobile_Error_Message = "Please check your email and mobile number."
    static let Number_Already_Register_Message = "This number is already registered."
    
}


