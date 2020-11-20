//
//  SettingsVC.swift
//  Nexshop
//
//  Created by Mac on 03/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON


class SettingsVC: UIViewController {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var SwitchNotification: UISwitch!
    
    
    //MARK:- VARIABLES
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUI()
        
        print(appDelegate.get_user_Data(Key: "notification"))
        
        if appDelegate.get_user_Data(Key: "notification") == "1"
        {
            self.SwitchNotification.isOn = true
        }
        else
        {
            self.SwitchNotification.isOn = false
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- ALL FUNCTIONS
    
    func SetUI()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
            self.SwitchNotification.set(width: 40, height: 25)
        }
        
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
                            print(dict)
                            
                            let StatusCode = dict["status"].int
                            if StatusCode==1
                            {
                                
                                let user_Data:NSDictionary = (dict["data"].dictionaryObject! as NSDictionary)
                                let user_dis:NSDictionary = user_Data
                                print(user_dis)
                                
                                UserDefaults.standard.set(user_dis, forKey: "User_data")
                                
                                appDelegate.HideProgress()
                                
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
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func SliderValueChanged(_ sender: Any)
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            appDelegate.ShowProgess()
            APIMangagerClass.callGetWithHeader(url: URL(string: WebURL.notification_set)!, finish: FinishWebserviceCall)
            
        }
    }
    
    
    @IBAction func btnHandlerEditProfile(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
    @IBAction func btnHandlerNotifications(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    
    @IBAction func btnHandlerSideMenu(_ sender: Any)
    {
        CommonClass.sharedInstance.openLeftSideMenu()
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
}

extension UISwitch {
    
    func set(width: CGFloat, height: CGFloat) {
        
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        
        let heightRatio = height / standardHeight
        let widthRatio = width / standardWidth
        
        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
