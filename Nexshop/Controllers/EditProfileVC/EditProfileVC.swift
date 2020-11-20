//
//  EditProfileVC.swift
//  Nexshop
//
//  Created by Mac on 02/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CropViewController
import UserNotifications
import Loaf
import DatePickerDialog
import SKCountryPicker

class EditProfileVC: UIViewController,CropViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var btnTitleCountryCode: UIButton!
    
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var txtFullName: ACFloatingTextfield!
    @IBOutlet weak var txtDOB: ACFloatingTextfield!
    @IBOutlet weak var txtMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    @IBOutlet weak var imgviewMale: UIImageView!
    @IBOutlet weak var txtAbout: ACFloatingTextfield!
    @IBOutlet weak var imgviewFemale: UIImageView!
    @IBOutlet weak var imgviewPic: UIImageView!
    
    @IBOutlet weak var btnTitleDOB: UIButton!
    
    
    //MARK:- VARIABLES
    var imageData = Data()
    let picker123 = UIImagePickerController()
    var is_Gender = String()
    var is_Selected_Date = String()
    var Country_Code = String()
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        self.Country_Code = appDelegate.get_user_Data(Key: "country_code") as! String
        
        self.txtDOB.text = "\(appDelegate.get_user_Data(Key: "dob") as! String)"
        self.txtAbout.text = "\(appDelegate.get_user_Data(Key: "about") as! String)"
        self.txtFullName.text = "\(appDelegate.get_user_Data(Key: "name") as! String)"
        self.txtEmailAddress.text = "\(appDelegate.get_user_Data(Key: "email") as! String)"
        self.txtMobileNumber.text = "\(appDelegate.get_user_Data(Key: "mobile") as! String)"
        
        self.is_Selected_Date = "\(appDelegate.get_user_Data(Key: "dob") as! String)"
        
        if self.is_Selected_Date.isEmpty == true
        {
            self.btnTitleDOB.setTitle("Select DOB", for: .normal)
            self.btnTitleDOB.setTitleColor(.lightGray, for: .normal)
            
        }
        else
        {
            self.btnTitleDOB.setTitle("\(self.is_Selected_Date)", for: .normal)
            self.btnTitleDOB.setTitleColor(.black, for: .normal)
        }
        
        if appDelegate.get_user_Data(Key: "gender") == "male"
        {
            self.imgviewMale.image = #imageLiteral(resourceName: "ic_blue_Circle")
            self.imgviewFemale.image = #imageLiteral(resourceName: "ic_grey__circle")
            self.is_Gender = "male"
        }
        else if appDelegate.get_user_Data(Key: "gender") == "female"
        {
            self.imgviewFemale.image = #imageLiteral(resourceName: "ic_blue_Circle")
            self.imgviewMale.image = #imageLiteral(resourceName: "ic_grey__circle")
            self.is_Gender = "female"
        }
        else
        {
            self.imgviewFemale.image = #imageLiteral(resourceName: "ic_grey__circle")
            self.imgviewMale.image = #imageLiteral(resourceName: "ic_grey__circle")
            self.is_Gender = ""
        }
        
        self.imgviewPic.kf.indicatorType = .activity
        self.imgviewPic.kf.setImage(with: URL(string: "\(appDelegate.get_user_Data(Key: "avatar") as! String)"   ))
        
        self.imageData = Data()
        picker123.delegate = self
        self.picker123.allowsEditing = false
        
        self.btnTitleCountryCode.setTitle(appDelegate.get_user_Data(Key: "country_code") as! String, for: .normal)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker123.mediaTypes = ["public.image"]
            picker123.sourceType = UIImagePickerController.SourceType.camera
            self .present(picker123, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    
    // open gallery method
    func openGallary()
    {
        picker123.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker123.mediaTypes = ["public.image"]
        picker123.sourceType = .photoLibrary
        picker123.delegate = self
        self.present(picker123, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        
    {
        let chosenImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let cropController:CropViewController = CropViewController(image: chosenImage)
            cropController.delegate = self
            cropController.aspectRatioPreset = .presetSquare
            cropController.aspectRatioLockEnabled = true
            cropController.aspectRatioPickerButtonHidden = true
            
            if #available(iOS 13.0, *) {
                cropController.modalPresentationStyle = .fullScreen
            }
            
            self.present(cropController, animated: true, completion: nil)
        }
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int)
    {
        
        cropViewController.dismiss(animated: true, completion:
            {
                
                self.imageData = image.jpegData(compressionQuality: 0.25)!
                self.dismiss(animated: true, completion: nil)
                self.imgviewPic.image = CommonClass.sharedInstance.imageOrientation(image)
                
                
                
        })
    }
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnHandlerConutryCode(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            
            
            self.Country_Code = country.dialingCode!
            self.btnTitleCountryCode.setTitle(country.dialingCode, for: .normal)

        }
        countryController.detailColor = UIColor.black
    }
    
    @IBAction func btnHandleSelectDOB(_ sender: Any)
    {
        let TodayDate = Date()
        DatePickerDialog().show("Select date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: TodayDate, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.is_Selected_Date = formatter.string(from: dt)
                self.btnTitleDOB.setTitle(self.is_Selected_Date, for: .normal)
                self.btnTitleDOB.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    
    @IBAction func btnHandlerMale(_ sender: Any)
    {
        self.is_Gender = "male"
        
        
        self.imgviewMale.image = #imageLiteral(resourceName: "ic_blue_Circle")
        self.imgviewFemale.image = #imageLiteral(resourceName: "ic_grey__circle")
        
        
    }
    
    
    @IBAction func btnHandlerFemale(_ sender: Any)
    {
        
        self.imgviewFemale.image = #imageLiteral(resourceName: "ic_blue_Circle")
        self.imgviewMale.image = #imageLiteral(resourceName: "ic_grey__circle")
        self.is_Gender = "female"
        
    }
    
    
    
    @IBAction func btnHandlerBkac(_ sender: Any)
    {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnHandlerSelectimage(_ sender: Any)
    {
        let actionSheetController = UIAlertController(title: "", message: "Please Select Image", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
        actionSheetController.addAction(cancelAction)
        let takePictureAction = UIAlertAction(title: "Open Camera", style: .default) { action -> Void in
            self.openCamera()
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction = UIAlertAction(title: "Open Gallery", style: .default) { action -> Void in
            self.openGallary()
        }
        actionSheetController.addAction(choosePictureAction)
        actionSheetController.popoverPresentationController?.sourceView = (sender as! UIView)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    @IBAction func btnHandlerEditProfile(_ sender: Any)
    {
        
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
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        if self.txtMobileNumber.text == appDelegate.get_user_Data(Key: "mobile")
        {
            if self.Country_Code == appDelegate.get_user_Data(Key: "country_code")
            {
                    self.Signup()
            }
            else
            {
                DispatchQueue.main.async {
                    
                    let id1 = appDelegate.get_user_Data(Key: "id")
                    let username = appDelegate.get_user_Data(Key: "username")

                    appDelegate.ShowProgess()
                    let Paramteres = ["mobile":self.txtMobileNumber.text!,"email":self.txtEmailAddress.text!,"username":username,"user_id":id1,"country_code":self.Country_Code] as [String : Any]
                    
                    print(Paramteres)
                    
                    
                    APIMangagerClass.callPost(url: URL(string: WebURL.resend_otp)!, params: Paramteres, finish: self.FinishResendOTPWebserviceCall)
                }
            }
            

        }
        else
        {
            DispatchQueue.main.async {
                
                let id1 = appDelegate.get_user_Data(Key: "id")
                let username = appDelegate.get_user_Data(Key: "username")

                appDelegate.ShowProgess()
                let Paramteres = ["mobile":self.txtMobileNumber.text!,"email":self.txtEmailAddress.text!,"username":username,"user_id":id1,"country_code":self.Country_Code] as [String : Any]
                
                print(Paramteres)
                
                
                APIMangagerClass.callPost(url: URL(string: WebURL.resend_otp)!, params: Paramteres, finish: self.FinishResendOTPWebserviceCall)
            }
        }
        
        
        
    }
    
}


extension EditProfileVC
{
    // MARK:- WEBSERVICE METHODS
    
    // Edit Profile Webservice
    
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
                                print(user_Data)
                                
                                let Push = self.storyboard!.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                Push.Country_Code = self.Country_Code
                                Push.MobileNumber = mobile
                                Push.otp_session = "\(user_Data.value(forKey: "otp_session") as! Int)"
                                Push.isUpdateProfile = true
                                Push.updateProfileDelegate = self
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
    
    @objc func Signup()
    {
        appDelegate.ShowProgess()
        var parameters = [String:String]()
        
        let Token = "\(appDelegate.get_user_Data(Key: "token") as! String)"
        let apiToken = "Bearer \(Token)"
        let headers:HTTPHeaders = ["Authorization":apiToken,"Accept":"application/json"]
        
        imageData = self.imgviewPic.image!.jpegData(compressionQuality: 0.25)!
        
        let Param = ["name":self.txtFullName.text!,"email":self.txtEmailAddress.text!,"mobile":self.txtMobileNumber.text!,"username":(appDelegate.get_user_Data(Key: "username") as! String),"gender":self.is_Gender,"birth_date":self.is_Selected_Date,"about":self.txtAbout.text!,"country_code":self.Country_Code]
        
        
        if self.imageData.count == 0
        {
            imageData = Data()
            
        }
        else
        {
            
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(self.imageData, withName: "file", fileName: "image.jpg", mimeType: "image/jpg")
            for (key, value) in Param
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
            
        },usingThreshold: UInt64(), to: WebURL.edit_profile, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if response.result.value != nil {
                        let Dic:NSDictionary = response.result.value as! NSDictionary
                        
                        print(Dic)
                        
                        let data1 = Dic.value(forKey: "data") as! NSDictionary
                        let status  = Dic.value(forKey: "status") as! Int
                        
                        
                        if status == 0
                        {
                            
                            appDelegate.HideProgress()
                            appDelegate.ErrorMessage(Message: Dic.value(forKey: "message") as! String, ContorllerName: self)
                            return
                            
                        }
                        else if status == 1
                        {
                            
                            let ProductData = Dic.value(forKey: "data") as! NSDictionary
                            
                            UserDefaults.standard.removeObject(forKey: "User_data")
                            
                            UserDefaults.standard.set(ProductData, forKey: "User_data")
                            
                            self.txtDOB.text = "\(appDelegate.get_user_Data(Key: "dob") )"
                            self.txtAbout.text = "\(appDelegate.get_user_Data(Key: "about") )"
                            self.txtFullName.text = "\(appDelegate.get_user_Data(Key: "name") )"
                            self.txtEmailAddress.text = "\(appDelegate.get_user_Data(Key: "email") )"
                            self.txtMobileNumber.text = "\(appDelegate.get_user_Data(Key: "mobile") )"
                            
                            
                            if appDelegate.get_user_Data(Key: "gender") == "male"
                            {
                                self.imgviewMale.image = #imageLiteral(resourceName: "ic_blue_Circle")
                                self.imgviewFemale.image = #imageLiteral(resourceName: "ic_grey__circle")
                                self.is_Gender = "male"
                            }
                            else
                            {
                                self.imgviewFemale.image = #imageLiteral(resourceName: "ic_blue_Circle")
                                self.imgviewMale.image = #imageLiteral(resourceName: "ic_grey__circle")
                                self.is_Gender = "female"
                            }
                            
                            self.imgviewPic.image = nil
                            self.imgviewPic.kf.indicatorType = .activity
                            self.imgviewPic.kf.setImage(with: URL(string: "\(appDelegate.get_user_Data(Key: "avatar") as! String)"   ))
                            
                            appDelegate.HideProgress()
                            self.btnHandlerBkac(self)
                            
                            Loaf(Dic.value(forKey: "message") as! String, state: .success, sender: self).show()
                            
                            
                            
                            
                            
                        }
                        else if status == 3
                        {
                            DispatchQueue.main.async {
                                
                                
                                appDelegate.HideProgress()
                                appDelegate.LoginAgainMessage(Message: "Please login to continue", ContorllerName: self)
                                
                            }
                        }
                        else
                        {
                            appDelegate.HideProgress()
                            appDelegate.ErrorMessage(Message: Dic.value(forKey: "message") as! String, ContorllerName: self)
                            return
                        }
                        
                    }
                    else {
                        
                        appDelegate.HideProgress()
                        Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
                        return
                        
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                
            }
        }
        
    }
    
    
    
    
}


extension EditProfileVC : UpdateProfile
{
    func UpdateProfileYes(isUpdate: Bool) {
        
        print("HELLO")
        print(self.txtMobileNumber.text!)
        if CommonClass.sharedInstance.isReachable() == false
               {
                   Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                   return
               }
        appDelegate.ShowProgess()
                   self.Signup()
 }
    
}
