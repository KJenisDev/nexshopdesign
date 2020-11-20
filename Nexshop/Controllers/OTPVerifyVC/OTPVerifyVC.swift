//
//  OTPVerifyVC.swift
//  Nexshop
//

import UIKit
import SVPinView
import SwiftyJSON
import Loaf

protocol UpdateProfile {
    func UpdateProfileYes(isUpdate:Bool)
}

class OTPVerifyVC: UIViewController {
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var vw_pin: SVPinView!
    
    @IBOutlet weak var lblMobileNumber: UILabel!
    
    //MARK:- VARIABLES
    var otp_session = String()
    var isSocial = false
    var isForgotPassword = false
    var FullName = String()
    var Password = String()
    var EmailAddress = String()
    var MobileNumber = String()
    var ConfirmPassword = String()
    var Username = String()
    var Socialid = String()
    var SocialType = String()

    var isUpdateProfile = false
    var updateProfileDelegate:UpdateProfile?
    var Country_Code = String()
    
    /*
     else if self.isSocial == true
     {
     self.showLoader()
     
     let Paramteres = ["username":self.Username,"email":self.EmailAddress,"mobile":self.MobileNumber,"name":self.FullName]
     
     ApiManagerVC.callPostWithHeader(url: URL(string: LoginModule.edit_profile)!, params: Paramteres, finish: self.FinishSocialWebserviceCall)
     
     }
     */
    
    //MARK:- VIEW DIDLOAD
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        vw_pin.pinLength = 6
        vw_pin.secureCharacter = "\u{25CF}"
        vw_pin.interSpace = 5
        vw_pin.textColor = UIColor.black
        vw_pin.shouldSecureText = false
        vw_pin.style = .box
        vw_pin.backgroundColor = UIColor.clear
        vw_pin.borderLineColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "183881")
        vw_pin.activeBorderLineColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "183881")
        vw_pin.borderLineThickness = 1
        vw_pin.activeBorderLineThickness = 1
        vw_pin.layer.cornerRadius = 5
        
        vw_pin.font = UIFont(name: "Metropolis-Medium", size: 25)!
        vw_pin.keyboardType = .numberPad
        vw_pin.placeholder = ""
        //View_Piview.becomeFirstResponderAtIndex = 0
        vw_pin.fieldCornerRadius = 6
        vw_pin.activeFieldCornerRadius = 6
        
        self.lblMobileNumber.text = "OTP sent to +" + "\(self.Country_Code)" + " " + "\(self.MobileNumber)"
        
        print(self.otp_session)
        
        
    }
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true
        )
    }
    
    
    @IBAction func btnHandlerResend(_ sender: Any)
    {
        vw_pin.clearPin()
        appDelegate.ShowProgess()
        
        
        var Paramteres = ["name":self.FullName,"password":self.Password,"email":self.EmailAddress,"mobile":self.MobileNumber,"confirm_password":self.ConfirmPassword,"username":self.Username,"country_code":self.Country_Code]
        
        print(Paramteres)
        
        
        if self.isUpdateProfile == true
        {
            let id1 = appDelegate.get_user_Data(Key: "id")
            let username = appDelegate.get_user_Data(Key: "username")
            
            if CommonClass.sharedInstance.isReachable() == false
            {
                Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                return
            }
            
            
            appDelegate.ShowProgess()
            Paramteres = ["mobile":self.MobileNumber,"email":appDelegate.get_user_Data(Key: "email"),"username":username,"user_id":id1,"country_code":self.Country_Code] as [String : String]
            
            print(Paramteres)
            
            
            APIMangagerClass.callPost(url: URL(string: WebURL.resend_otp)!, params: Paramteres, finish: self.FinishResendOTPWebserviceCall)
        }
        
        print(Paramteres)
        
        
        APIMangagerClass.callPost(url: URL(string: WebURL.resend_otp)!, params: Paramteres, finish: self.FinishResendOTPWebserviceCall)
        
    }
    
    
    @IBAction func btnHandlerTerms(_ sender: Any)
    {
        let OTP = self.vw_pin.getPin()
        
        if OTP.isEmpty == true
        {
            Loaf(LocalValidations.EnterOTP, state: .error, sender: self).show()
            return
        }
        
        print(OTP)
        print(self.otp_session)
        
        if OTP != self.otp_session
        {
            Loaf("Please enter valid otp", state: .error, sender: self).show()
            return
        }
        else
        {
            
            if self.isUpdateProfile == true
            {
                self.updateProfileDelegate?.UpdateProfileYes(isUpdate: true)
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                if CommonClass.sharedInstance.isReachable() == false
                {
                    Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                    return
                }
                
                if self.isSocial == true
                {
                    appDelegate.ShowProgess()
                    
                    let Paramteres = ["username":self.Username,"email":self.EmailAddress,"mobile":self.MobileNumber,"name":self.FullName,"country_code":self.Country_Code]
                    
                    print(Paramteres)
                    
                    
                    APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.edit_profile)!, params: Paramteres, finish: self.FinishSocialWebserviceCall)
                    
                }
                else
                {
                    appDelegate.ShowProgess()
                    self.RegisterApi()
                }
                
                
            }
            
            
        }
        
        
        
        
        
        //        let Paramteres = ["mobile":self.MobileNumber,"otp_session":self.otp_session,"otp":OTP]
        //
        //        APIMangagerClass.callPost(url: URL(string: WebURL.verify_otp)!, params: Paramteres, finish: ValidOTPWebserviceCall)
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func FinishSocialWebserviceCall (message:String, data:Data?) -> Void
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
                                DispatchQueue.main.async {
                                    
                                    let ErrorDic:String = dict["message"].string!
                                    appDelegate.HideProgress()
                                    appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                                    return
                                    
                                }
                                
                            }
                            else if status == 1
                            {
                                
                                DispatchQueue.main.async {
                                    
                                    
                                    let user_Data:NSDictionary = (dict["data"].dictionaryObject! as NSDictionary)
                                    let user_dis:NSDictionary = user_Data
                                    UserDefaults.standard.setValue(user_dis, forKey: UserDefaultKeys.is_logged_user_data)
                                    UserDefaults.standard.set(user_dis, forKey: "User_data")
                                    
                                    //                        let storyboard : UIStoryboard = UIStoryboard(name: "Social", bundle: nil)
                                    //                        let Push = storyboard.instantiateViewController(withIdentifier: "tabbar")
                                    //                        self.navigationController?.pushViewController(Push, animated: true)
                                    appDelObj.SetHomeRoot()
                                    
                                    
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
                                DispatchQueue.main.async {
                                    
                                    let ErrorDic:String = dict["message"].string!
                                    appDelegate.HideProgress()
                                    appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                                    return
                                    
                                }
                                
                            }
                            else if status == 1
                            {
                                
                                DispatchQueue.main.async {
                                    
                                    let user_Data:NSDictionary = (dict["data"].dictionaryObject! as NSDictionary)
                                    let mobile = user_Data.value(forKey: "mobile") as! String
                                    
                                    
                                    appDelegate.SuccessMessage(Message: dict["message"].string!, ContorllerName: self)
                                    
                                    self.MobileNumber = mobile
                                    self.otp_session = "\(user_Data.value(forKey: "otp_session") as! NSNumber)"
                                    
                                    
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
    
    
    func ValidOTPWebserviceCall (message:String, data:Data?) -> Void
    {
        do
        {
            if data != nil
            {
                DispatchQueue.main.async {
                    
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
                        
                        DispatchQueue.main.async {
                            
                            if status == 0
                            {
                                let ErrorDic:String = dict["message"].string!
                                appDelegate.HideProgress()
                                appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                                return
                                
                            }
                            else
                            {
                                if CommonClass.sharedInstance.isReachable() == false
                                {
                                    appDelegate.HideProgress()
                                    Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                                    return
                                }
                                
                                self.RegisterApi()
                                
                            }
                            
                            
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
    
    func RegisterApi()
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            appDelegate.HideProgress()
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        let Paramteres = ["name":self.FullName,"password":self.Password,"email":self.EmailAddress,"mobile":self.MobileNumber,"confirm_password":self.ConfirmPassword,"username":self.Username,"country_code":self.Country_Code]
        
        print(Paramteres)
        
        
        APIMangagerClass.callPost(url: URL(string: WebURL.signup)!, params: Paramteres, finish: FinishSignUpWebserviceCall)
        
        print(Paramteres)
        
    }
    
    func FinishSignUpWebserviceCall (message:String, data:Data?) -> Void
    {
        do
        {
            if data != nil
            {
                let parsedData =  try? JSON(data: data!)
                DispatchQueue.main.async {
                    
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
                                let user_dis:NSDictionary = user_Data
                                UserDefaults.standard.set(user_dis, forKey: "User_data")
                                
                                
                                appDelObj.SetHomeRoot()
                                
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
    
}


