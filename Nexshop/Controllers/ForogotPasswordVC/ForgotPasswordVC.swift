//
//  ForgotPasswordVC.swift
//  Nexshop
//


import UIKit
import Loaf
import SwiftyJSON


class ForgotPasswordVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var txtEmailAddress: ACFloatingTextfield!
    
    //MARK:- VARIABLES
    
    
    
    //MARK:- VIEW DIDLOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnHandlerSubmit(_ sender: Any)
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
        
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelObj.ShowProgess()
        let Paramteres = ["email":"vaghasiyanirmal12@gmail.com"]
        APIMangagerClass.callPost(url: URL(string: WebURL.forget_password)!, params: Paramteres, finish: FinishLoginWebserviceCall)
        
        
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func FinishLoginWebserviceCall (message:String, data:Data?) -> Void
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
                                        
                                        print(dict)
                                        
                                        let ErrorDic:String = dict["message"].string!
                                        self.navigationController?.popViewController(animated: true)

                                        Loaf(ErrorDic, state: .success, sender: self).show()
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
