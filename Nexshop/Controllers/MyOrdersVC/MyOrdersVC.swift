//
//  MyOrdersVC.swift
//  Nexshop
//
//  Created by Mac on 02/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON
import ObjectMapper
import Alamofire
import Kingfisher

class MyOrdersVC: UIViewController {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var lblOrders: UILabel!
    @IBOutlet weak var tblviewHome: UITableView!
    @IBOutlet weak var viewMain: UIView!
    
    
    
    //MARK:- VARIABLES
    var ShoppingArray = NSMutableArray()
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblviewHome.isHidden = true
        self.tblviewHome.backgroundColor = UIColor.clear
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            SetUI()
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func SetUI()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        self.tblviewHome.register(CartCellXIB.self, forCellReuseIdentifier: "CartCellXIB")
        self.tblviewHome.register(UINib(nibName: "CartCellXIB", bundle: nil), forCellReuseIdentifier: "CartCellXIB")
        
        
        self.lblOrders.text = ""
        self.lblOrders.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        var Paramteres = ["type":"shopping"]
        self.tblviewHome.isHidden = true
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        appDelegate.ShowProgess()
        let UrlString = WebURL.get_orders
        
        APIMangagerClass.callPostWithHeader(url: URL(string: UrlString)!, params: Paramteres, finish: self.GetOrders)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerSideMenu(_ sender: Any)
    {
        CommonClass.sharedInstance.openLeftSideMenu()
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    @objc func OrderDetail(sender:UIButton)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
        Push.isOrderid = "\(((self.ShoppingArray.object(at: sender.tag) as! NSDictionary).value(forKey: "order_id") as! NSNumber))"
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    @objc func RepeatOrder(sender:UIButton)
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            appDelegate.ShowProgess()
            let UrlString = WebURL.repeat_order
            
            
            let Order_id1 = "\((((self.ShoppingArray.object(at: sender.tag) as! NSDictionary)).value(forKey: "order_id") as! NSNumber))"
            
            let Paramteres = ["order_id":Order_id1]
            
            APIMangagerClass.callPostWithHeader(url: URL(string: UrlString)!, params: Paramteres, finish: self.RepeatOrder)
        }
    }
    
    @IBAction func btnHandlerNotifications(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    
    
    func getVariationString(index: Int) -> String {
        
        let ItemArray = (((self.ShoppingArray.object(at: index) as! NSDictionary).value(forKey: "items") as! NSArray))
        
        let TempDict = ItemArray.object(at: 0) as! NSDictionary
        let VariationsArray = TempDict.value(forKey: "variation") as! NSArray
        
        
        
        var arrParam = ""
        
        for obj1 in VariationsArray
        {
            let p_z = obj1 as! NSDictionary
            
            let keystring = p_z.value(forKey: "title")!
            var value = String()
            if keystring as! String == "Color"
            {
                value = "\(p_z.value(forKey: "color_name")!)"
            }
            else
            {
                value = "\(p_z.value(forKey: "value")!)"
            }
            
            let str = "\(keystring): \(value), "
            
            
            
            arrParam.append(str)
        }
        
        arrParam = String(arrParam.dropLast())
        arrParam = String(arrParam.dropLast())
        
        return arrParam
    }
    
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
                                    
                                    self.ShoppingArray = user_Data.mutableCopy() as! NSMutableArray
                                    
                                    
                                    self.tblviewHome.reloadData()
                                    self.tblviewHome.isHidden = false
                                    self.lblOrders.text = ""
                                    self.lblOrders.isHidden = true
                                    
                                }
                                else
                                {
                                    self.lblOrders.text = "No orders found"
                                    self.lblOrders.isHidden = false
                                    self.tblviewHome.isHidden  = true
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
    
    func RepeatOrder (message:String, data:Data?) -> Void
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
                            
                            DispatchQueue.main.async
                                {
                                    appDelegate.HideProgress()
                                    appDelegate.SetCartRoot()
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
    
    
}


//MARK:- TABLEVIEW METHODS

extension MyOrdersVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ShoppingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblviewHome.dequeueReusableCell(withIdentifier: "CartCellXIB") as! CartCellXIB
        cell.selectionStyle = .none
        DispatchQueue.main.async {
            
        }
        
        DispatchQueue.main.async {
            cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 10)
            cell.viewLeftSide.round(corners: .bottomLeft, cornerRadius: 5)
            cell.viewMainLef.round(corners: .bottomLeft, cornerRadius: 5)
        }
        
        if self.ShoppingArray.count > 0
        {
            
            if (((self.ShoppingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "items") as! NSArray).object(at: 0) as! NSDictionary).count > 0
            {
                cell.lblTitle.text = "\((((self.ShoppingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "items") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "name") as! String)"
                
                var total_string = String()
                
                let itemsArray = ((self.ShoppingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "items") as! NSArray)
                
                for item in itemsArray{
                    let pz = item as! NSDictionary
                    
                    if(total_string.length>0){
                        
                        total_string  = total_string + " , " + "\(pz.value(forKey: "name") as! String)"
                    }
                    else{
                        total_string  = "\(pz.value(forKey: "name") as! String)"
                    }
                    
                }
                
                cell.lblTitle.text = total_string
                
                
            }
            
            
            
            cell.lblReturn.text = "Ordered on " + "\((self.ShoppingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "date") as! String)"
            
            
            
            cell.lblQty.text = "\((((self.ShoppingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "items") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "qty") as! NSNumber)"
            
            cell.lblOldPrice.text = "$ " + "\((((self.ShoppingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "items") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "price") as! NSNumber)"
            
            cell.lblVariations.text = getVariationString(index: indexPath.row)
            
            
            
            cell.imgviewPic.kf.indicatorType = .activity
            cell.imgviewPic.kf.setImage(with: URL(string: ((((self.ShoppingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "items") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "thumbnail_img") as! String)))
            
            cell.btnTitleMove.setTitle("View More", for: .normal)
            cell.btnTitleRepeat.setTitle("Repeat Order", for: .normal)
            
            cell.btnTitleRepeat.addTarget(self, action: #selector(self.RepeatOrder(sender:)), for: .touchUpInside)
            cell.btnTitleRepeat.tag = indexPath.row
            
            cell.btnTitleMove.tag = indexPath.row
            cell.btnTitleMove.addTarget(self, action: #selector(self.OrderDetail(sender:)), for: .touchUpInside)
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
        Push.isOrderid = "\(((self.ShoppingArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "order_id") as! NSNumber))"
        self.navigationController?.pushViewController(Push, animated: true)
    }
}
