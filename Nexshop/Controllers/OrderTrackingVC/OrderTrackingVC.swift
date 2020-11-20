//
//  OrderTrackingVC.swift
//  Nexshop
//
//  Created by Mac on 06/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import SwiftyJSON
import Loaf
import Alamofire
import Kingfisher

class OrderTrackingVC: UIViewController {
    
    
    //MARK:- OUTLETS
    var DataSet = [String]()
    
    @IBOutlet weak var tblviewMain: UITableView!
    @IBOutlet weak var viewMain: UIView!
    
    //MARK:- VARIABLES
    var isOrderid = String()
    var TrackingDict = NSMutableDictionary()
    var TrackingArray = NSMutableArray()
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        self.tblviewMain.isHidden = true
        
        self.tblviewMain.register(OrderTrackingHeaderXIB.self, forCellReuseIdentifier: "OrderTrackingHeaderXIB")
        self.tblviewMain.register(UINib(nibName: "OrderTrackingHeaderXIB", bundle: nil), forCellReuseIdentifier: "OrderTrackingHeaderXIB")
        
        self.tblviewMain.register(OrderStatusCellXIB.self, forCellReuseIdentifier: "OrderStatusCellXIB")
        self.tblviewMain.register(UINib(nibName: "OrderStatusCellXIB", bundle: nil), forCellReuseIdentifier: "OrderStatusCellXIB")
        
        self.tblviewMain.register(OrderTrackingAddressCellXIB.self, forCellReuseIdentifier: "OrderTrackingAddressCellXIB")
        self.tblviewMain.register(UINib(nibName: "OrderTrackingAddressCellXIB", bundle: nil), forCellReuseIdentifier: "OrderTrackingAddressCellXIB")
        
        self.tblviewMain.register(PendingStatusCellXIB.self, forCellReuseIdentifier: "PendingStatusCellXIB")
        self.tblviewMain.register(UINib(nibName: "PendingStatusCellXIB", bundle: nil), forCellReuseIdentifier: "PendingStatusCellXIB")
        
        
        self.tblviewMain.register(CurrentStatusCellXIB.self, forCellReuseIdentifier: "CurrentStatusCellXIB")
        self.tblviewMain.register(UINib(nibName: "CurrentStatusCellXIB", bundle: nil), forCellReuseIdentifier: "CurrentStatusCellXIB")
        
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        appDelegate.ShowProgess()
        self.GetTrackingDetails()
    }
    
    // MARK:- ALL FUNCTIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func GetTrackingDetails()
    {
        
        let apiToken = "Bearer \(appDelegate.get_user_Data(Key: "token"))"
        let headers:HTTPHeaders = ["Authorization": apiToken,"Accept":"application/json"]
        
        var url1 = "https://zestbrains.techboundary.xyz/public/api/v1/app/order_tracking/" + "\(self.isOrderid)"
        
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        print(headers)
        
        Alamofire.request(url1, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
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
                    
                    
                    let ProductData = dict.value(forKey: "data") as! NSDictionary
                    print(ProductData)
                    
                    self.TrackingDict = ProductData.mutableCopy() as! NSMutableDictionary
                    self.TrackingArray = (ProductData.value(forKey: "status") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    self.tblviewMain.reloadData()
                    self.tblviewMain.isHidden = false
                    
                    
                    
                    appDelegate.HideProgress()
                    
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
        
    }
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnHandlerTrackOrder(_ sender: Any)
    {

        let Push = self.storyboard?.instantiateViewController(withIdentifier: "OrderTrackingVC") as! OrderTrackingVC
        Push.isOrderid = "\(isOrderid)"
        self.navigationController?.pushViewController(Push, animated: true)
    }
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- TABLEVIEW METHODS

extension OrderTrackingVC:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.TrackingDict.count > 0
        {
            return 3
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 1
        }
        else if section == 1
        {
            return self.TrackingArray.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = self.tblviewMain.dequeueReusableCell(withIdentifier: "OrderTrackingHeaderXIB") as! OrderTrackingHeaderXIB
            
            //cell.lblDate.text = CommonClass.sharedInstance.convertDateFormatter2(date: self.TrackingDict.value(forKey: "delivery_date") as! String)
            
            cell.lblDate.text = "5 - 10 working days delivery"
            
            cell.lblOrderid.text = self.TrackingDict.value(forKey: "order_number") as! String
            
            cell.selectionStyle = .none
            
            return cell
        }
        else if indexPath.section == 1
        {
            
            let track_status = (self.TrackingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "track_status") as! String
            
            print(track_status)
            
            if track_status != "active"
            {
                let cell = self.tblviewMain.dequeueReusableCell(withIdentifier: "PendingStatusCellXIB") as! PendingStatusCellXIB
                
                cell.selectionStyle = .none
                
                cell.lblHeader.text = ((self.TrackingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "label") as! String)
                
                cell.lblDescription.text = ((self.TrackingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "text") as! String)
                
                return cell
            }
            else
            {
                let cell = self.tblviewMain.dequeueReusableCell(withIdentifier: "CurrentStatusCellXIB") as! CurrentStatusCellXIB
                
                cell.selectionStyle = .none
                
                cell.lblOrderStatus.text = ((self.TrackingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "label") as! String)
                
                cell.lbDescription.text = ((self.TrackingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "text") as! String)
                
                return cell
            }
            
            
            
            
        }
        else
        {
            let cell = self.tblviewMain.dequeueReusableCell(withIdentifier: "OrderTrackingAddressCellXIB") as! OrderTrackingAddressCellXIB
            
            cell.lblName.text = ((self.TrackingDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "name") as! String)
            
            cell.lblType.text =  ((self.TrackingDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "tag") as! String)
            
            cell.lblAddress.text = ((self.TrackingDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "house_number") as! String) + " , " + ((self.TrackingDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "landmark") as! String) + " , " + ((self.TrackingDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "city") as! String) + " , " +  ((self.TrackingDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "zipcode") as! String) + "\n" + "Mobile number: " + "\(((self.TrackingDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "mobile_no") as! String))"
            
            
            
            
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
            
            let track_status = (self.TrackingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "track_status") as! String
            
            if track_status != "active"
            {
                return 70
            }
            else
            {
                return 90
            }
            
        }
        else
        {
            return 130
        }
        
        
        
    }
}

