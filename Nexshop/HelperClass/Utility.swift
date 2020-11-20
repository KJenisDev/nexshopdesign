//
//  Utility.swift
//  Cellula
//
//  Created by office on 27/05/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Kingfisher
import Alamofire


typealias ValidationResultType = (isValid: Bool, message: String)

let localiseCurrency = "₹"

final class AlertMessage {

    //MARK:- Alert functions
    
          
          
      
}
extension Date{
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "MMM dd yyyy, h:mm a"
        return formatter.string(from: self)
    }
}
extension String {
    func toDate(withFormat format: String )-> Date?{

              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = format
              //let date = dateFormatter.date(from: self)
               if let date = dateFormatter.date(from: self) {
               return date
               }
               else{
                   return nil
               }
              

          }
   
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
//MARK:- Extension
extension UIViewController {
    
    //MARK:- Loader
   
    
}

enum Utility {
    static func executeAfter(_ after: Double, callback: @escaping ()-> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + after, execute: callback)
    }
    
    static func executeMain(callback: @escaping ()-> Void) {
        DispatchQueue.main.async(execute: callback)
    }
    
    
    static func delay(_ delay: Double, callback: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            callback()
        }
    }
    
    static func dateFromString (strDate: String, strFormatter strDateFormatter: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter
        let convertedDate = dateFormatter.date(from: strDate)
        return convertedDate!
    }
    
    static func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> Int
       {

           let diff = Int(end.timeIntervalSince1970 - start.timeIntervalSince1970)

           let hours = diff / 3600
           let minutes = (diff - hours * 3600) / 60
           return minutes
       }
    
    static func setDateForChallenges (strStartDate: String, strEndDate: String) -> String {
        return strEndDate
    }
    
    static func stringFromDate (date: Date, strFormatter strDateFormatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strDateFormatter
        
        let convertedDate = dateFormatter.string(from: date)
        
        return convertedDate
    }
    
    static func stringDateFromStringDate (strDate: String, strFormatter strDateFormatter: String, currentFormate: String) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = currentFormate
          let convertedDate = dateFormatter.date(from: strDate)
        return stringFromDate(date: convertedDate!, strFormatter: strDateFormatter)
      }
    
    static func convertTimeStampToDate(timestamp:Double, dtFormatter: String) -> String{
        let date = Date(timeIntervalSince1970: timestamp)
        let dt = date//toLocalTime()
        return Utility.stringFromDate(date: dt, strFormatter: dtFormatter)
    }
    
    static func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    static func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    
    static func createVideoThumbnail(from url: URL) -> UIImage? {

        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
//        assetImgGenerate.maximumSize = CGSize(width: frame.width, height: frame.height)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }

    }
    
    static func isHtml(_ value:String) -> Bool {
        let validateTest = NSPredicate(format:"SELF MATCHES %@", "<[a-z][\\s\\S]*>")
        return validateTest.evaluate(with: value)
    }
}



extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var asNumberString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        if let number = formatter.number(from: self) {
            return "\(number.doubleValue)"
        } else {
            return ""
        }
        
    }
    
    func checkValidFormat(_ validCharacterSet:CharacterSet) -> Bool{
        if self.rangeOfCharacter(from: validCharacterSet.inverted) != nil {
            return false
        }
        return true
    }
    
    var isEmail: Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
   
     func isImage() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg", "jpeg", "png", "gif"]

        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }

        return false
    }
    func getExtension() -> String? {
              let ext = (self as NSString).pathExtension

              if ext.isEmpty {
                  return nil
              }

              return ext
           }
    
}



enum ValidCharacter {
    static let onlyNumber = CharacterSet.init(charactersIn: "0123456789")
    static let onlyAlphabets = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    static let onlyMobileNumber = CharacterSet.init(charactersIn: "0123456789")
    static let onlyMobileNumberWithPlus = CharacterSet.init(charactersIn: "+0123456789")
    static let onlyAlphabetsWithSpace = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ")
    static let onlyAlphaNumericWithSpecialChar = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz` !@#/$%^&*()_+|}{;:><")
    static let onlyAlphaNumeric = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
    static let onlyAlphaNumericWithSpace = CharacterSet.init(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ")
    static let onlyZipcodeChar = CharacterSet.init(charactersIn: "-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    static let onlyUserName = CharacterSet.init(charactersIn: "_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
}



enum WellnessValidationMessage {
    static let selectRelationship = "Please select relationship"
    static let enterFullName = "Please enter full name"
    static let selectDob = "Please select date of birth"
    static let selectGender = "Please select gender"
    static let selectCity = "Please select city"
    static let selectFoodtype = "Please select food type"
    static let selectSmoking = "Please select smoking or not"
    static let selectAlcohol = "Please select alcohol or not"
    static let selectTobaco = "Please select tobacco or not"
    static let selectBloodGroup = "Please select blood group"
    static let selectMedicalInsurance = "Please select have medical insurance or not"
    static let selectAllergy = "Please select have any allergy or not"
    static let addAllergy = "Please add allergies"
    static let selectDisease = "Please select have any disease or not"
    static let addDisease = "Please add diseases"
    static let selectOrAddDoctor = "Please select doctor/physician"
    static let enterHospitalName = "Please enter hospital name"
    static let enterSpeciality = "Please enter speciality"
    static let enterMobileNumber = "Please enter mobile_number"
    static let enterReportName = "Please enter report name"
    static let selectDateTime = "Please select date and time"
    static let addDocuments = "Please add documents"
    static let enterWorkoutName = "Please enter workout name"
    static let selectStartTime = "Please select start time"
    static let selectEndTime = "Please select end time"
    static let selectDate = "Please select date"
    static let selecttime = "Please select time"
    static let selectPackage = "Please select a package"
    static let enterOldPassword = "Please enter your Old Passowrd"
    static let enterPassword = "Please enter your New Password"
    static let enterConfirmPassword = "Please enter Confirm Password"
    static let passwordAndConfirmPAsswordDoesNotMatch = "New Password and Confirm Password should be same"
    static let enterEmail = "Please enter email address"
    static let newPassSHouldNotBeSame = "New Password should be different from Old Password"
    static let ordeNumEmpty = "Please enter Order ID"
    static let subjectEmpty = "Please enter Subject"
    static let descriptionEmpty = "Please enter Description"
    static let descriptionLength = "Description should be minimum 10 characters long"
}

enum LoginModuleErrorMessage
{
    static let internetconnectivity = "Please check your internet connection!"
    static let UsernameMobileOrEmailAddress = "Enter username or mobile number or email address! "
    static let Password = "Enter your password! "
    static let PasswordCount = "Password must required at least 6 characters!"
    static let FullUsername = "Enter your full name! "
    static let Username = "Enter your username! "
    static let MobileNumber = "Enter your mobile number! "
    static let ValidMobileNumber = "Enter valid mobile number!"
    static let Emailaddress = "Enter valid email address!"
    static let ValidEmailaddress = "Enter email valid address!"
    static let ConfirmPassword = "Enter your cofirm password!"
    static let PasswordMatch = "Password doesn't match!"
    static let UsernameNotAvalible = "Username not avalible!"
    static let ServerError = "Server error.please try again later!"
    static let EntervalidOTP = "Please enter valid otp!"
    
    
    
}
enum SocialModuleMessage
{
     static let BIO = "Enter your bio"
     static let Skill = "Select skill"
     static let Gender = "Select gender"
     static let City = "Select City"
     static let Category = "Select Category"
     static let DOB = "Select Date"
    
    
}
enum SpiritualModuleMessage
{
    static let EmergencyName = "Enter emergency name!"
    static let EmergencyNumber = "Enter emergency number!"
    static let EmgerencyValidMobileNumber = "Enter emergency valid number!"
    
}



extension UIImageView {
    func setImage(strUrl: String) {
        //        self.kf.indicatorType = .activity
        //        self.kf.setImage(with: URL(string: strUrl))
        //        if let imgUrl = URL(string: strUrl) as? URL {
        //            self.af_setImage(withURL: imgUrl)
        //        }
        
        
        let placeHolder = UIImage(named: "Artboard – 1")
        if let url = URL(string: strUrl) {
            self.kf.indicatorType = .activity
            self.kf.setImage(with: URL(string: strUrl), placeholder: placeHolder)
//             self.af_setImage(withURL: url, placeholderImage: placeHolder)
        } else {
            self.image = placeHolder
            self.contentMode = .scaleAspectFit
            self.backgroundColor = .white

        }
    }
    
//    func setImage(urlString:String,placeHolder:UIImage) {
//        if let url = URL(string: urlString) {
//            self.af_setImage(withURL: url, placeholderImage: placeHolder)
//        } else {
//            self.image = placeHolder
//        }
//    }
    
}


//MARK:- Debouncer Class


