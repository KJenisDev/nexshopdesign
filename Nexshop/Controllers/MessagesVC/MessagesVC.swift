//
//  MessagesVC.swift
//  Nexshop
//
//  Created by Mac on 04/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import UserNotifications


class MessagesVC: UIViewController,UNUserNotificationCenterDelegate{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var tblviewMessage: UITableView!
    @IBOutlet weak var viewCart: UIView!
    
    //MARK:- VARIABLES
    
    var objViewModel = SocialViewModel()
    var arrData = [RoomHistoryModel]()
    var MessageArray = NSMutableArray()
    
    
    //MARK:- VIEW DID LOAD
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.tblviewMessage.delegate = self
        self.tblviewMessage.dataSource = self
        
        self.tblviewMessage.register(MessagesCellXIB.self, forCellReuseIdentifier: "MessagesCellXIB")
        self.tblviewMessage.register(UINib(nibName: "MessagesCellXIB", bundle: nil), forCellReuseIdentifier: "MessagesCellXIB")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UNUserNotificationCenter.current().delegate = self
        
        self.tblviewMessage.isHidden = true
        self.GetRoomListing()
        
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        
        let data_item = notification.request.content.userInfo as NSDictionary
        
        if data_item.value(forKey: "push_type") as! String == "1"
        {
            
            if CommonClass.sharedInstance.isReachable() == false
            {
                Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                return
            }
            self.tblviewMessage.isHidden = true
            self.GetRoomListing()
            
            completionHandler([.alert, .sound,])
            
        }
            
        else
        {
            completionHandler([.alert, .sound,])
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func GetRoomListing()
    {
        appDelegate.ShowProgess()
        self.arrData.removeAll()
        self.arrData = []
        objViewModel.RoomListing(limit: 10000, offset: 0) { (status, message, result) in
            
            if status
            {
                if result != nil
                {
                    self.arrData = [RoomHistoryModel]()
                    self.tblviewMessage.isHidden = false
                    self.arrData = result!
                    self.tblviewMessage.reloadData()
                    appDelegate.HideProgress()
                }
            }
            else
            {
                appDelegate.HideProgress()
                appDelegate.ErrorMessage(Message: message, ContorllerName: self)
                return
            }
        }
    }
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerSideMenu(_ sender: Any)
    {
        CommonClass.sharedInstance.openLeftSideMenu()
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
}



//MARK:- TABLEVIEW METHODS


extension MessagesVC:UITableViewDelegate,UITableViewDataSource
{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.arrData.count == 0
        {
            self.tblviewMessage.setEmptyMessage("No Messages Found")
        }
        else
        {
            self.tblviewMessage.restore()
        }
        
        return self.arrData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = self.tblviewMessage.dequeueReusableCell(withIdentifier: "MessagesCellXIB") as! MessagesCellXIB
        
        cell.selectionStyle = .none
        let data = arrData[indexPath.row]
        
        print(data.product?.name)
        
        cell.lblProductName.text = data.created_user_data!.name!
        cell.imgviewPic.kf.indicatorType = .activity
        
        if data.product?.thumbnailImg != nil
        {
            
             cell.imgviewPic.kf.setImage(with: URL(string: data.product!.thumbnailImg!))
        }
        
       
        
        if data.last_message != nil
        {
            let id1 = appDelegate.get_user_Data(Key: "id")
            
            if data.last_message?.is_read == 0 && data.last_message?.from_user_id != Int(id1)
            {
                cell.lblProductName.textColor = UIColor.init(hexString: "#02911C")
                cell.lblTime.textColor = UIColor.init(hexString: "#02911C")
            }
            else
            {
                
                cell.lblProductName.textColor = UIColor.init(hexString: "#2D2D2D ")
                cell.lblTime.textColor = UIColor.init(hexString: "#B1B0AC")
                
            }
            if data.last_message?.created_at != nil
            {
                cell.lblTime.text = Utility.stringDateFromStringDate(strDate: (data.last_message?.created_at!)!, strFormatter: "d-MM-yyyy", currentFormate: "yyyy-MM-dd HH:mm:ss")
                
                if data.last_message!.message!.isEmpty == false
                {
                    cell.lblMessage.text = data.last_message?.message
                    
                }
                else
                {
                    cell.lblMessage.text = "File"
                }
            }
            else
            {
                cell.lblTime.text = Utility.stringDateFromStringDate(strDate: (data.created_at!), strFormatter: "d-MM-yyyy", currentFormate: "yyyy-MM-dd HH:mm:ss")
                cell.lblMessage.text = ""
            }
            
            if data.product?.name?.isEmpty == false
            {
                cell.lblProductName.text = "\(data.product!.name!)"
                
            }
            
            //cell.lblSeller.text = "Seller: " + "\(data.other_user_data!.name!)"
            
            if data.other_user_data?.shop == nil
            {
                cell.lblSeller.text = "Seller: "
                
            }
            else
            {
                if data.other_user_data?.shop?.name?.isEmpty == true || data.other_user_data?.shop?.name == nil
                {
                    cell.lblSeller.text = "Seller: "
                }
                else
                {
                    
                    cell.lblSeller.text = "Seller: " + "\(data.other_user_data!.shop!.name!)"
                }
                
            }
            
            cell.lblRed.backgroundColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "cc0000")
            
            if data.last_message?.from_user_id == Int(appDelegate.get_user_Data(Key: "id"))
            {
                cell.lblRed.isHidden = true
                
            }
            else
            {
                if data.last_message?.is_read == 1
                {
                    cell.lblRed.isHidden = true
                    
                }
                else
                {
                    cell.lblRed.isHidden = false
                }
            }
            
        }
        else
        {
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let data = arrData[indexPath.row]
        
        print(data.created_user_data?.id)
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC")  as! ChatDetailVC
        Push.ToUserID = Int(data.receiver_id!)!
        Push.OtherUserName = data.created_user_data!.name!
        Push.RecieverImageUrl = data.created_user_data!.avatar!
        Push.Product_id = "\(data.product!.id!)"
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
}


