//
//  NotificationsVC.swift
//  Nexshop
//
//  Created by Mac on 05/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON

class NotificationsVC: UIViewController {
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblviewNotifications: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnTitleClear: UIButton!
    
    
    //MARK:- VARIABLES
    var NotificationList = [NotificationModel]()
    
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoData.text = ""
        self.btnTitleClear.isHidden = true
        
        self.tblviewNotifications.isHidden = true
        
        self.tblviewNotifications.register(NotificationCellXIB.self, forCellReuseIdentifier: "NotificationCellXIB")
        self.tblviewNotifications.register(UINib(nibName: "NotificationCellXIB", bundle: nil), forCellReuseIdentifier: "NotificationCellXIB")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        appDelegate.ShowProgess()
        let UrlString = WebURL.get_notification_list
        
        var Paramteres = ["":""]
        
        APIMangagerClass.callPostWithHeader(url: URL(string: UrlString)!, params: Paramteres, finish: self.GetOrders)
    }
    
    
    // MARK:- ALL FUNCTIONS
    
    func GetOrders (message:String, data:Data?) -> Void
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
                        print(dict)
                        
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
                                
                                
                                let user_Data:NSArray = (dict["data"].arrayObject! as NSArray)
                                
                                print(user_Data)
                                
                                
                                if user_Data.count > 0
                                {
                                    
                                    self.NotificationList.removeAll()
                                    
                                    for object in user_Data
                                    {
                                        let Data_Object = NotificationModel.init(fromDictionary: object as! [String : Any])
                                        self.NotificationList.append(Data_Object)
                                        
                                    }
                                    
                                    self.tblviewNotifications.reloadData()
                                    self.tblviewNotifications.isHidden = false
                                    self.lblNoData.text = ""
                                    self.lblNoData.isHidden = true
                                    self.btnTitleClear.isHidden = false
                                    
                                }
                                else
                                {
                                    self.lblNoData.text = "No notifications found"
                                    self.lblNoData.isHidden = false
                                    self.tblviewNotifications.isHidden  = true
                                    self.btnTitleClear.isHidden = true
                                }
                                
                                
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
            else
            {
                appDelegate.HideProgress()
                Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
                return
            }
        }
        catch
        {
            
            appDelegate.HideProgress()
            Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
            return
            
        }
    }
    
    func GetClear (message:String, data:Data?) -> Void
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
                        print(dict)
                        
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
                                
                                let ErrorDic:String = dict["message"].string!
                                Loaf(ErrorDic, state: .success, sender: self).show()
                                
                                self.NotificationList.removeAll()
                                
                                self.lblNoData.text = "No notifications found"
                                self.lblNoData.isHidden = false
                                self.tblviewNotifications.isHidden  = true
                                self.btnTitleClear.isHidden = true
                                
                                
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
            else
            {
                appDelegate.HideProgress()
                Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
                return
            }
        }
        catch
        {
            
            appDelegate.HideProgress()
            Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
            return
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerClearAll(_ sender: Any)
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        appDelegate.ShowProgess()
        let UrlString = WebURL.clear_notification
        
        var Paramteres = ["":""]
        
        APIMangagerClass.callGetWithHeader(url: URL(string: UrlString)!, finish: self.GetClear)
    }
    
    
    
    
    @IBAction func btnHandlerback(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK:- TABLEVIEW METHODS


extension NotificationsVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.NotificationList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.tblviewNotifications.dequeueReusableCell(withIdentifier: "NotificationCellXIB") as! NotificationCellXIB
        
        cell.selectionStyle = .none
        
        DispatchQueue.main.async {
            
            cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 8)
        }
        
        
        if self.NotificationList.count > 0
        {
            var Date1 = CommonClass.sharedInstance.UTCToLocalAM(date: self.NotificationList[indexPath.row].createdAt!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
            let date = dateFormatter.date(from: "\(Date1)")
            
            cell.lbDate.text = "\(date!.timeAgoSinceDate())"
            cell.lblDetail.text = self.NotificationList[indexPath.row].message!
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let Push = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
               Push.isOrderid = "\(self.NotificationList[indexPath.row].objectId!)"
               self.navigationController?.pushViewController(Push, animated: true)
    }
}

extension Date {
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}
