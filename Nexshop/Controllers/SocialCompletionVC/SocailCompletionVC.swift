//
//  SocailCompletionVC.swift
//  Nexshop
//
//  Created by Mac on 13/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON
import SKCountryPicker

class SocailCompletionVC: UIViewController {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var btnTitleCountry: UIButton!
    
    
    
    @IBOutlet weak var txtFullName: ACFloatingTextfield!
    
    
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    @IBOutlet weak var txtMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var txtUserName: ACFloatingTextfield!
    
    
    
    //MARK:- VARIABLES
    
    var MobileNumber = String()
    var FullName = String()
    var EmailAddress = String()
    var Socialid = String()
    var SocialType = String()
    var isSocial = false
    var OnlyName = String()
    var Country_Code = String()
    
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.txtFullName.text = "\(self.FullName)"
        self.txtEmailAddress.text = "\(self.EmailAddress)"
        self.txtMobileNumber.text = "\(self.MobileNumber)"
        
        if self.EmailAddress.isEmpty == true
        {
            self.txtEmailAddress.isUserInteractionEnabled = true
        }
        else
        {
            self.txtEmailAddress.isUserInteractionEnabled = false
        }
        
        let country = CountryManager.shared.currentCountry
                          self.Country_Code = country!.dialingCode!
                          
               self.btnTitleCountry.setTitle(country?.dialingCode, for: .normal)
        
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func FinishResendOTPWebserviceCall (message:String, data:Data?) -> Void
    {
        do
        {
            if data != nil
            {
                DispatchQueue.main.async
                    {
                        let parsedData =  try? JSON(data: data!)
                        
                        if parsedData == nil
                        {
                            appDelegate.HideProgress()
                            Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
                            return
                            
                        }
                        else
                        {
                            let dict:JSON = parsedData!
                            
                            
                            let status = dict["status"].int
                            
                            if status == 0
                            {
                                let ErrorDic:String = dict["message"].string!
                                appDelegate.HideProgress()
                                appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                                return
                                
                            }
                            else if status == 1
                            {
                                
                                DispatchQueue.main.async {
                                    
                                    let user_Data:NSDictionary = (dict["data"].dictionaryObject! as NSDictionary)
                                    let mobile = user_Data.value(forKey: "mobile") as! String
                                    
                                    
                                    let Push = mainStoryboard.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                    Push.MobileNumber = mobile
                                    Push.Country_Code = self.Country_Code
                                    Push.isSocial = true
                                    Push.FullName = "\(self.txtFullName.text!)"
                                    Push.EmailAddress = self.txtEmailAddress.text!
                                    Push.Socialid = self.Socialid
                                    Push.SocialType = self.SocialType
                                    Push.Username = "\(self.txtUserName.text!)"
                                    Push.otp_session = "\(user_Data.value(forKey: "otp_session") as! NSNumber)"
                                    self.navigationController?.pushViewController(Push, animated: true)
                                    
                                    appDelegate.HideProgress()
                                    
                                    
                                }
                                
                            }
                            else if status == 3
                            {
                                
                                let ErrorDic:String = dict["message"].string!
                                appDelegate.HideProgress()
                                appDelegate.LoginAgainMessage(Message: ErrorDic, ContorllerName: self)
                                return
                                
                                
                            }
                            else
                            {
                                let ErrorDic:String = dict["message"].string!
                                appDelegate.HideProgress()
                                appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                                return
                            }
                        }
                        
                        
                }
            }
        }
        catch
        {
            
            appDelegate.HideProgress()
            Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
            return
            
        }
    }
    
    func FinishCheckUserNameWebserviceCall (message:String, data:Data?) -> Void
    {
        do
        {
            if data != nil
            {
                DispatchQueue.main.async
                    {
                        let parsedData =  try? JSON(data: data!)
                        
                        if parsedData == nil
                        {
                            appDelegate.HideProgress()
                            Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
                            return
                            
                        }
                        else
                        {
                            let dict:JSON = parsedData!
                            
                            
                            let status = dict["status"].int
                            
                            if status == 0
                            {
                                let ErrorDic:String = dict["message"].string!
                                appDelegate.HideProgress()
                                appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                                return
                                
                            }
                            else if status == 1
                            {
                                
                                DispatchQueue.main.async
                                    {
                                        let Paramteres = ["username":self.txtUserName.text!,"email":self.txtEmailAddress.text!,"mobile":self.txtMobileNumber.text!,"name":self.txtFullName.text!,"user_id":"\(appDelegate.get_user_Data(Key: "id"))","country_code":self.Country_Code]
                                        
                                        print(Paramteres)
                                        
                                        
                                        APIMangagerClass.callPost(url: URL(string: WebURL.resend_otp)!, params: Paramteres, finish: self.FinishResendOTPWebserviceCall)
                                }
                                
                            }
                            else if status == 3
                            {
                                
                                let ErrorDic:String = dict["message"].string!
                                appDelegate.HideProgress()
                                appDelegate.LoginAgainMessage(Message: ErrorDic, ContorllerName: self)
                                return
                                
                                
                            }
                            else
                            {
                                let ErrorDic:String = dict["message"].string!
                                appDelegate.HideProgress()
                                appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                                return
                            }
                        }
                        
                        
                }
            }
        }
        catch
        {
            
            appDelegate.HideProgress()
            Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
            return
            
        }
    }
    
    func CheckUserName()
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        let Paramteres = ["username":self.txtUserName.text!]
        print(Paramteres)
        
        APIMangagerClass.callPost(url: URL(string: WebURL.check_username)!, params: Paramteres, finish: self.FinishCheckUserNameWebserviceCall)
    }
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerCOuntry(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            
            
            self.Country_Code = country.dialingCode!
            self.btnTitleCountry.setTitle(country.dialingCode, for: .normal)

        }
        countryController.detailColor = UIColor.black
    }
    
    
    
    @IBAction func btnHandlerContinue(_ sender: Any)
    {
        
        if self.txtFullName.text?.isEmpty == true
        {
            Loaf(LocalValidations.enterFullName, state: .error, sender: self).show()
            return
        }
        if self.txtUserName.text?.isEmpty == true
        {
            Loaf(LocalValidations.enterUserName, state: .error, sender: self).show()
            return
        }
        if self.txtMobileNumber.text?.isEmpty == true
        {
            Loaf(LocalValidations.enterMobileNumber, state: .error, sender: self).show()
            return
        }
        if self.txtMobileNumber.text!.count < 10
        {
            Loaf(LocalValidations.ValidMobileNumber, state: .error, sender: self).show()
            return
        }
        if self.txtEmailAddress.text?.isEmpty == true
        {
            Loaf(LocalValidations.enterEmailAddress, state: .error, sender: self).show()
            return
        }
        if CommonClass.sharedInstance.isValidEmail(testStr: self.txtEmailAddress.text!) == false
        {
            Loaf(LocalValidations.enterEmailValidAddress, state: .error, sender: self).show()
            return
        }
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelObj.ShowProgess()
        
        self.CheckUserName()
        
        
        
        
    }
    
    
    
}
