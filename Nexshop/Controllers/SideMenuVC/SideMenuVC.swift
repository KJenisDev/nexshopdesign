//
//  SideMenuVC.swift
//  Nexshop
//
//  Created by Mac on 01/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Alamofire
import Loaf

class SideMenuVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tblviewHome: UITableView!
    
    
    //MARK:- VARIABLES
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUI()
        
    }
    
    
    // MARK:- ALL FUNCTIONS
    
    func logoutUser() {
        appDelegate.ShowProgess()
        
        let apiToken = "Bearer \(appDelegate.get_user_Data(Key: "token"))"
        let headers:HTTPHeaders = ["Authorization": apiToken,"Accept":"application/json"]
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        
        Alamofire.request(WebURL.logout, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            if let json = response.value {
                let dict: NSDictionary = (json as? NSDictionary)!
                
                
                let status = dict.value(forKey: "status") as! Int
                
                if status == 0
                {
                    
                    appDelegate.HideProgress()
                    appDelegate.ErrorMessage(Message: dict.value(forKey: "message") as! String, ContorllerName: self)
                    return
                    
                }
                else if status == 1
                {
                    DispatchQueue.main.async {
                        
                        UserDefaults.standard.removeObject(forKey: "User_data")
                        appDelegate.HideProgress()
                        appDelegate.SetLoginRoot()
                        
                        
                    }
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
                    appDelegate.ErrorMessage(Message: dict.value(forKey: "message") as! String, ContorllerName: self)
                    return
                }
                
            }
            else {
                
                appDelegate.HideProgress()
                Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
                return
            }
        }
        
        //LogoutWebserviceCall
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
        
    }
    
    func SetUI()
    {
        self.tblviewHome.register(SideMenuHeaderCellXIB.self, forCellReuseIdentifier: "SideMenuHeaderCellXIB")
        self.tblviewHome.register(UINib(nibName: "SideMenuHeaderCellXIB", bundle: nil), forCellReuseIdentifier: "SideMenuHeaderCellXIB")
        
        self.tblviewHome.register(SideMenuDataCellXIB.self, forCellReuseIdentifier: "SideMenuDataCellXIB")
        self.tblviewHome.register(UINib(nibName: "SideMenuDataCellXIB", bundle: nil), forCellReuseIdentifier: "SideMenuDataCellXIB")
        
        self.tblviewHome.register(SideMenuLineXIB.self, forCellReuseIdentifier: "SideMenuLineXIB")
        self.tblviewHome.register(UINib(nibName: "SideMenuLineXIB", bundle: nil), forCellReuseIdentifier: "SideMenuLineXIB")
    }
    
    //MARK:- BUTTON ACTIONS
    
    
    
}


//MARK:- TABLEVIEW METOHDS

extension SideMenuVC:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1
        {
            return 4
        }
        if section == 3
        {
            return 3
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = self.tblviewHome.dequeueReusableCell(withIdentifier: "SideMenuHeaderCellXIB") as! SideMenuHeaderCellXIB
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1
        {
            let cell = self.tblviewHome.dequeueReusableCell(withIdentifier: "SideMenuDataCellXIB") as! SideMenuDataCellXIB
            cell.selectionStyle = .none
            
            cell.lblHeader.textColor = UIColor.black
            
            if indexPath.row == 0
            {
                cell.lblHeader.text = "Home"
            }
            else if indexPath.row == 1
            {
                cell.lblHeader.text = "Messages"
            }
            else if indexPath.row == 2
            {
                cell.lblHeader.text = "My Orders"
            }
            else
            {
                cell.lblHeader.text = "My Wishlist"
            }
            
            
            return cell
        }
        else if indexPath.section == 2
        {
            let cell = self.tblviewHome.dequeueReusableCell(withIdentifier: "SideMenuLineXIB") as! SideMenuLineXIB
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = self.tblviewHome.dequeueReusableCell(withIdentifier: "SideMenuDataCellXIB") as! SideMenuDataCellXIB
            cell.selectionStyle = .none
            
            cell.lblHeader.textColor = UIColor.black
            
            if indexPath.row == 0
            {
                cell.lblHeader.text = "Terms and conditions"
            }
            else if indexPath.row == 1
            {
                cell.lblHeader.text = "Settings"
            }
            else
            {
                cell.lblHeader.textColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD")
                cell.lblHeader.text = "Logout"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 125
        }
        else if indexPath.section == 1
        {
            return 50
        }
        else if indexPath.section == 2
        {
            return 30
        }
        else
        {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                appDelegate.SetHomeRoot()
            }
            if indexPath.row == 1
            {
                let Push = self.storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
                self.navigationController?.pushViewController(Push, animated: true)
                
            }
            if indexPath.row == 2
            {
                let Push = self.storyboard?.instantiateViewController(withIdentifier: "MyOrdersVC") as! MyOrdersVC
                self.navigationController?.pushViewController(Push, animated: true)
                
            }
            else if indexPath.row == 3
            {
                let Push = self.storyboard?.instantiateViewController(withIdentifier: "WishListVC") as! WishListVC
                self.navigationController?.pushViewController(Push, animated: true)
            }
            
        }
        if indexPath.section == 3
        {
            if indexPath.row == 0
            {
                let Push = self.storyboard?.instantiateViewController(withIdentifier: "TearmsAndUseVC") as! TearmsAndUseVC
                Push.isFromSideMenu = true
                self.navigationController?.pushViewController(Push, animated: true)
            }
            if indexPath.row == 1
            {
                let Push = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
                self.navigationController?.pushViewController(Push, animated: true)
                
            }
            if indexPath.row == 2
            {
                
                let uiAlert = UIAlertController(title: "Nexshop", message: "Are You Sure Want To Logout?", preferredStyle: UIAlertController.Style.alert)
                self.present(uiAlert, animated: true, completion: nil)
                
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    
                    self.logoutUser()
                    
                }))
                
                uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    
                }))
                
            }
        }
    }
}
