//
//  RegisterVC.swift
//  Nexshop
//


import UIKit
import Loaf
import SwiftyJSON
import FBSDKLoginKit
import SwiftyJSON
import FBSDKLoginKit
import SwiftyJSON
import AuthenticationServices
import IQKeyboardManagerSwift
import GoogleSignIn
import SKCountryPicker


class RegisterVC: UIViewController,UITextFieldDelegate,GIDSignInDelegate{
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var btnTitleCountry: UIButton!
    
    
    @IBOutlet weak var imgviewGIF: UIImageView!
    @IBOutlet weak var txtFullName: ACFloatingTextfield!
    @IBOutlet weak var txtMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    @IBOutlet weak var txtPassword: ACFloatingTextfield!
    @IBOutlet weak var txtUserName: ACFloatingTextfield!
    
    //MARK:- VARIABLES
    var SocialType = String()
    var Socialid = String()
    var SocialEmailAddress = String()
    var SocialMobileNumber = String()
    var SocialName = String()
    var Is_Username_Avalible = Bool()
    let debounce = Debouncer()
    var Country_Code = String()

    
    
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Is_Username_Avalible = false
        
        self.txtUserName.delegate = self
        
        self.imgviewGIF.isHidden = true
        
        let country = CountryManager.shared.currentCountry
                   self.Country_Code = country!.dialingCode!
                   
        self.btnTitleCountry.setTitle(country?.dialingCode, for: .normal)
        
        
                // Do any additional setup after loading the view.
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
        
        
    }
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerCountry(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            
            
            self.Country_Code = country.dialingCode!
            self.btnTitleCountry.setTitle(country.dialingCode, for: .normal)

        }
        countryController.detailColor = UIColor.black
    }
    
    @IBAction func btnHandlerTerms(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "TearmsAndUseVC") as! TearmsAndUseVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    
    @IBAction func btnHandlerRegister(_ sender: Any)
    {
        
        if self.txtUserName.text?.isEmpty == true
        {
            Loaf(LocalValidations.enterUserName, state: .error, sender: self).show()
            return
        }
        
        if self.txtFullName.text?.isEmpty == true
        {
            Loaf(LocalValidations.enterFullName, state: .error, sender: self).show()
            return
        }
        
        if self.txtMobileNumber.text?.isEmpty == true
        {
            Loaf(LocalValidations.enterMobileNumber, state: .error, sender: self).show()
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
        self.CheckUserName()
        
        
    }
    
    @IBAction func btnHandlerGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "1078890390221-mb27lh6k4555omb4tgdhbg408rj7aim7.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnHandlerFacebook(_ sender: Any)
    {
        self.GetFacebookData()
    }
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK:- ALL FUNCTIONS
    
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
        let Paramteres = ["provider":provider,"mobile":mobile,"provider_id":provider_id,"email":email,"country_code":self.Country_Code]
        
        print(Paramteres)
        
        
        APIMangagerClass.callPost(url: URL(string: WebURL.social_login)!, params: Paramteres, finish: FinishSocialWebserviceCall)
        
        
    }
}


extension RegisterVC
{
    func RegisterWebService()
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        let Paramteres = ["mobile":self.txtMobileNumber.text!,"username":self.txtUserName.text!,"email":self.txtEmailAddress.text!,"country_code":self.Country_Code]
        
        print(Paramteres)
        
        
        APIMangagerClass.callPost(url: URL(string: WebURL.resend_otp)!, params: Paramteres, finish: self.FinishResendOTPWebserviceCall)
        
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
                                let ErrorDic:String = dict["message"].string!
                                appDelegate.HideProgress()
                                appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                                return
                                
                            }
                            else if status == 1
                            {
                                
                                DispatchQueue.main.async {
                                    
                                    let user_Data:NSDictionary = (dict["data"].dictionaryObject! as NSDictionary)
                                    print(dict)
                                    let mobile = user_Data.value(forKey: "mobile") as! String
                                    let Password = self.txtPassword.text!
                                    
                                    let Push = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                    Push.Country_Code = self.Country_Code
                                    Push.MobileNumber = mobile
                                    Push.Password = Password
                                    Push.otp_session = "\(user_Data.value(forKey: "otp_session") as! Int)"
                                    
                                    Push.FullName = "\(self.txtFullName.text!)"
                                    Push.Password = "\(self.txtPassword.text!)"
                                    Push.EmailAddress = "\(self.txtEmailAddress.text!)"
                                    Push.MobileNumber = "\(self.txtMobileNumber.text!)"
                                    Push.ConfirmPassword = "\(self.txtPassword.text!)"
                                    Push.Username = "\(self.txtUserName.text!)"
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
                                        self.RegisterWebService()
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
                            
                            DispatchQueue.main.async
                                {
                                    
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
    
    func CheckUserName()
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        let Paramteres = ["username":self.txtUserName.text!]
        APIMangagerClass.callPost(url: URL(string: WebURL.check_username)!, params: Paramteres, finish: self.FinishCheckUserNameWebserviceCall)
    }
    
    
}
