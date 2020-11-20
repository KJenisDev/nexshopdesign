//
//  WishListVC.swift
//  Nexshop
//
//  Created by Mac on 03/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON
import ObjectMapper
import Alamofire
import Kingfisher

class WishListVC: UIViewController {
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var tblviewCart: UITableView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    
    //MARK:- VARIABLES
    var WishListDataModel = [WishListModel]()
    var ShoppingArray = NSMutableArray()
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblviewCart.isHidden = true
        self.lblNoData.isHidden = true
        self.lblNoData.text = ""
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            SetUI()
            
            appDelegate.ShowProgess()
            var Paramteres = ["module":"shopping"]
            print(Paramteres)
              
            APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_wishlist)!, params: Paramteres, finish: self.GetOrders)
        }
        
    }
    
    //MARK:- ALL FUNCTIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func AddToCart(sender:UIButton)
    {
        if CommonClass.sharedInstance.isReachable() == false
               {
                   Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                   return
               }
        appDelegate.ShowProgess()
        var id1 = "\(self.WishListDataModel[sender.tag].productId!)"
        
        var arrParam = [[String:String]]()
        arrParam.append(["product_id":id1,"type":"products","module":"shopping","qty":"1"])
        let param = addSelectedParameters(index: sender.tag, param: arrParam)
        
        print(param)
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.add_item_to_cart)!, params: param, finish: self.GetWishListed)
        
        
        
        
    }
    
    func GetWishListed (message:String, data:Data?) -> Void
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
                            
                            
                            DispatchQueue.main.async
                                {
                                    self.viewWillAppear(true)
                                    
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
    
    func addSelectedParameters(index:Int, param: [[String:Any]]) -> [String:Any] {
        var arrParam = param
        for obj1 in self.WishListDataModel[index].variations
        {
            let keystring = obj1.name!
            let tempParam = [keystring: "\((obj1.value!))"]
            arrParam.append(tempParam)
            
            
        }
        
        var param = arrParam.flatMap { $0 }.reduce([:]) { $0.merging($1) { (current, _) in current } }
        return param
    }
    
    @objc func RemoveFromWishList(sender:UIButton)
    {
        var id1 = ""
        var Paramteres = ["item_id":id1]
        id1 = "\(self.WishListDataModel[sender.tag].itemId!)"
        Paramteres = ["item_id":id1]
        
        appDelegate.ShowProgess()
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.remove_from_wishlist)!, params: Paramteres, finish: self.RemoveWishListed)
    }
    
    
    func SetUI()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        self.tblviewCart.register(WishListCellXIB.self, forCellReuseIdentifier: "WishListCellXIB")
        self.tblviewCart.register(UINib(nibName: "WishListCellXIB", bundle: nil), forCellReuseIdentifier: "WishListCellXIB")
        self.tblviewCart.backgroundColor = UIColor.clear
        
        
    }
    
    func RemoveWishListed (message:String, data:Data?) -> Void
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
                                
                                DispatchQueue.main.async
                                    {
                                        self.viewWillAppear(true)
                                        
                                }
                                
                                
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
    
    func getVariationString(index: Int) -> String {
        
        let ItemArray = (((self.ShoppingArray.object(at: index) as! NSDictionary).value(forKey: "variations") as! NSArray))
        
        var arrParam = ""
        
        for obj1 in ItemArray
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
                                    
                                    
                                    for object in user_Data
                                    {
                                        let Data_Object = WishListModel.init(fromDictionary: object as! [String : Any])
                                        self.WishListDataModel.append(Data_Object)
                                    }
                                    
                                    
                                    
                                    self.tblviewCart.reloadData()
                                    self.tblviewCart.isHidden = false
                                    self.lblNoData.text = ""
                                    self.lblNoData.isHidden = true
                                    
                                }
                                else
                                {
                                    self.lblNoData.text = "No Wishlist Products Found"
                                    self.lblNoData.isHidden = false
                                    self.tblviewCart.isHidden  = true
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
    
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerSideMenu(_ sender: Any)
    {
        CommonClass.sharedInstance.openLeftSideMenu()
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    @IBAction func btnHandlerNotifications(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
}


//MARK:- TABLEVIEW METHODS



extension WishListVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.WishListDataModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblviewCart.dequeueReusableCell(withIdentifier: "WishListCellXIB") as! WishListCellXIB
        cell.selectionStyle = .none
        DispatchQueue.main.async {
            cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 10)
            cell.viewLeftSide.round(corners: .bottomLeft, cornerRadius: 5)
            cell.viewMainLeft.round(corners: .bottomLeft, cornerRadius: 5)
        }
        
        if self.WishListDataModel.count > 0
        {
            
            cell.lblProduct.text = self.WishListDataModel[indexPath.row].name!
            
            cell.lblQTY.text = "\(self.WishListDataModel[indexPath.row].qty!)"
            cell.lblOldPrice.text = "$ " + "\(self.WishListDataModel[indexPath.row].price!)"
            
            
            cell.imgviewProduct.kf.indicatorType = .activity
            cell.imgviewProduct.kf.setImage(with: URL(string: self.WishListDataModel[indexPath.row].thumbnailImg!))
            
            print(self.WishListDataModel[indexPath.row].price)
            print(self.WishListDataModel[indexPath.row].unitPrice)
            
            if self.WishListDataModel[indexPath.row].price == self.WishListDataModel[indexPath.row].unitPrice!
            {
                
                cell.lblOffer.text = ""
                cell.lblSecondPrice.text = ""
                cell.lblOffer.isHidden = true
                cell.lblSecondPrice.isHidden = true
            }
            else
            {
                
                let Offer = Float(self.WishListDataModel[indexPath.row].discount!)
                let x = Double(Offer).rounded(toPlaces: 1)
                var y = Int(x)
                cell.lblOffer.text = "\(y)" + "% off"
                cell.lblOffer.isHidden = false
                cell.lblSecondPrice.isHidden = true
              //  cell.lblSecondPrice.text = "$ " + "\(self.WishListDataModel[indexPath.row].unitPrice!)"
                
                
            }
            
            
        }
        
        cell.btnTitleRemove.tag = indexPath.row
        cell.btnTitleRemove.addTarget(self, action: #selector(self.RemoveFromWishList(sender:)), for: .touchUpInside)
        
        cell.btnTitleMove.tag = indexPath.row
        cell.btnTitleMove.addTarget(self, action: #selector(self.AddToCart(sender:)), for: .touchUpInside)
        
        
        cell.btnTitleRemove.setTitle("Remove", for: .normal)
        cell.btnTitleMove.setTitle("Move to cart", for: .normal)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
}
