//
//  ViewController.swift
//  Nexshop
//
//  Created by Catlina-Ravi on 17/09/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON
import FBSDKLoginKit
import SwiftyJSON
import GoogleSignIn
import SKCountryPicker

class ViewController: UIViewController,GIDSignInDelegate{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
    @IBOutlet weak var btnTitleFacebook: UIButton!
    @IBOutlet weak var btnTitleGoogle: UIButton!
    
    
    //MARK:- VARIABLES
    var SocialType = String()
    var Socialid = String()
    var SocialEmailAddress = String()
    var SocialMobileNumber = String()
    var SocialName = String()
    var Country_Code = String()

    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

        
        self.txtEmailAddress.text = "vaghasiyanirmal12@gmail.com"
       // self.txtEmailAddress.text = "aaaa@aa.com"
        self.txtPassword.text = "123456"
        
    }
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnHandlerForgotPassword(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
    
    @IBAction func btnHandlerLogin(_ sender: Any)
    {
        
        
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
        if self.txtPassword.text?.isEmpty == true
        {
            Loaf(LocalValidations.enterPassword, state: .error, sender: self).show()
            return
        }
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        self.LoginWebservice()
        
    }
    
    @IBAction func btnHandlerFacebook(_ sender: Any)
    {
        self.GetFacebookData()
    }
    
    @IBAction func btnHandlerGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "1078890390221-mb27lh6k4555omb4tgdhbg408rj7aim7.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func btnHandlerSignup(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            
            print(user.profile.email)
            print(user.profile.name)
            
            self.SocialMobileNumber = ""
            self.SocialType = "google"
            self.Socialid = user.userID!
            self.SocialEmailAddress = user.profile.email!
            self.SocialName = user.profile.name
            
            appDelObj.ShowProgess()
            
            self.GetSocialData(mobile: self.SocialMobileNumber, provider: "google", provider_id: self.Socialid, email: self.SocialEmailAddress)
            
        }
        
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    func GetFacebookData()
    {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
            if (error == nil) {
                
                let fbloginresult:LoginManagerLoginResult = result!
                
                if fbloginresult.grantedPermissions != nil
                {
                    let permissionDictionary = [
                        "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"]
                    let pictureRequest = GraphRequest(graphPath: "me", parameters: permissionDictionary)
                    let _ = pictureRequest.start(completionHandler: {
                        (connection, result, error) -> Void in
                        
                        if error == nil {
                            let results = result as? NSDictionary
                            
                            print(results)
                            
                            let profile = results?.value(forKey: "picture")
                            var CheckbEmail = results?.value(forKey: "email") as? String
                            var mobilenumber = results?.value(forKey: "mobile") as? String
                            
                            
                            if CheckbEmail?.isEmpty == true ||  CheckbEmail == nil
                            {
                                CheckbEmail = ""
                            }
                            else
                            {
                                CheckbEmail  = (results!.value(forKey: "email") as! String)
                            }
                            if mobilenumber?.isEmpty == true ||  mobilenumber == nil
                            {
                                mobilenumber = ""
                            }
                            else
                            {
                                mobilenumber  = (results!.value(forKey: "mobile") as! String)
                                
                            }
                            
                            
                            self.SocialMobileNumber = mobilenumber!
                            self.SocialType = "facebook"
                            self.Socialid = results?.value(forKey: "id") as! String
                            self.SocialEmailAddress = CheckbEmail!
                            self.SocialName = results?.value(forKey: "name") as! String
                            
                            appDelegate.ShowProgess()
                            
                            self.GetSocialData(mobile: mobilenumber!, provider: "facebook", provider_id: results?.value(forKey: "id") as! String, email: CheckbEmail!)
                            
                        } else {
                            
                            print("error \(String(describing: error.debugDescription))")
                            
                            
                        }
                    })
                    
                    let manager = LoginManager()
                    manager.logOut()
                }
                else
                {
                    
                }
            }
        }
        
    }
    
    func GetSocialData(mobile:String,provider:String,provider_id:String,email:String)
    {
        appDelegate.ShowProgess()
        let Paramteres = ["provider":provider,"mobile":mobile,"provider_id":provider_id,"email":email]
        
        APIMangagerClass.callPost(url: URL(string: WebURL.social_login)!, params: Paramteres, finish: FinishSocialWebserviceCall)
        
        
    }
}

//MARK:- WEBSERVICES

extension ViewController
{
    func LoginWebservice()
    {
        
        let Paramteres = ["identity":self.txtEmailAddress.text!,"password":txtPassword.text!]
        appDelegate.ShowProgess()
        APIMangagerClass.callPost(url: URL(string: WebURL.login)!, params: Paramteres, finish: FinishWebserviceCall)
    }
    
    
    func FinishWebserviceCall (message:String, data:Data?) -> Void
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
                            
                            let StatusCode = dict["status"].int
                            if StatusCode==1
                            {
                                
                                let user_Data:NSDictionary = (dict["data"].dictionaryObject! as NSDictionary)
                                let user_dis:NSDictionary = user_Data
                                print(user_Data)

                                
                              //  9173446898
                                
                                UserDefaults.standard.set(user_dis, forKey: "User_data")
                                
                                let mobile_verified = user_dis.value(forKey: "mobile_verified") as! String
                                self.Country_Code = appDelegate.get_user_Data(Key: "country_code") as! String
                                if mobile_verified == "1"
                                {
                                    appDelegate.HideProgress()
                                    appDelegate.SetHomeRoot()
                                    
                                }
                                else
                                {
                                    appDelegate.HideProgress()
                                    let Push = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                    Push.Country_Code = self.Country_Code
                                    self.navigationController?.pushViewController(Push, animated: true)
                                }
                                
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
    
    func FinishSocialWebserviceCall (message:String, data:Data?) -> Void
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
                                print(user_Data)
                                
                                UserDefaults.standard.set(user_dis, forKey: "User_data")
                                self.Country_Code = appDelegate.get_user_Data(Key: "country_code") as! String
                                let email = user_Data.value(forKey: "email") as! String
                                let id = user_Data.value(forKey: "id") as! String
                                let email_verified = user_Data.value(forKey: "email_verified") as! String
                                let token = user_Data.value(forKey: "token") as! String
                                let name = user_Data.value(forKey: "name") as! String
                                let mobile_verified = (user_Data.value(forKey: "mobile_verified") as! String)
                                let mobile = user_Data.value(forKey: "mobile") as! String
                                let username = user_Data.value(forKey: "username") as! String
                                
                                if mobile.isEmpty == true || email.isEmpty == true
                                {
                                    DispatchQueue.main.async {
                                        
                                        let Push = self.storyboard!.instantiateViewController(withIdentifier: "SocailCompletionVC") as! SocailCompletionVC
                                        
                                        Push.isSocial = true
                                        Push.FullName = self.SocialName
                                        Push.EmailAddress = self.SocialEmailAddress
                                        Push.MobileNumber = self.SocialMobileNumber
                                        Push.Socialid = self.Socialid
                                        Push.SocialType = self.SocialType
                                        
                                        self.navigationController?.pushViewController(Push, animated: true)
                                        
                                        appDelegate.HideProgress()
                                        
                                    }
                                }
                                else
                                {
                                    
                                    
                                    if mobile_verified == "0"
                                    {
                                        DispatchQueue.main.async {
                                            let Paramteres = ["mobile":mobile,"email":email,"username":username,"id":id] as [String : Any]
                                            
                                            
                                            APIMangagerClass.callPost(url: URL(string: WebURL.resend_otp)!, params: Paramteres, finish: self.FinishResendOTPWebserviceCall)
                                        }
                                    }
                                    else
                                    {
                                        
                                        DispatchQueue.main.async {
                                            
                                            appDelObj.SetHomeRoot()
                                            appDelegate.HideProgress()
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            
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
                                let Password = self.txtPassword.text!
                                
                                let Push = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                Push.Country_Code = "\(user_Data.value(forKey: "country_code") as! String)"
                                Push.MobileNumber = mobile
                                Push.Password = Password
                                Push.otp_session = "\(user_Data.value(forKey: "otp_session") as! Int)"
                                self.navigationController?.pushViewController(Push, animated: true)
                                
                                appDelegate.HideProgress()
                                
                                
                            }
                            
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


