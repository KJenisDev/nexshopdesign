//
//  CartVC.swift
//  Nexshop
//
//  Created by Mac on 01/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import SwiftyJSON
import Loaf
import Alamofire

class TableScrollCell:UITableViewCell
{
    
    @IBOutlet weak var CollectionCart: UICollectionView!
}

class CollectionDataCell:UICollectionViewCell
{
    
    @IBOutlet weak var imgviewProduct: UIImageView!
    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackGround: UIView!
}

class CartVC: UIViewController {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var btnHeight: NSLayoutConstraint!
    @IBOutlet weak var btnTitleCart: MyRoundedButton!
    @IBOutlet weak var tblviewCart: UITableView!
    @IBOutlet weak var viewCart: UIView!
    
    
    //MARK:- VARIABLES
    
    var CartModelData = [CartListModel]()
    var isCartData = false
    var DataSet = [String]()
    var ToppicksDisplayModel = [TodaysDeal]()
    var TopPicksCollection:UICollectionView?
    var totalitemscharge = NSNumber()
    var servicecharge = NSNumber()
    var deliverycharge = NSNumber()
    var granndTotal = NSNumber()
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         SetUI()
        
        
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
    
    
    @IBAction func btnHandlerBuy(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
        Push.totalitemscharge = self.totalitemscharge
        Push.servicecharge = self.servicecharge
        Push.deliverycharge = self.deliverycharge
        Push.granndTotal = self.granndTotal
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    @objc func RemoveProduct(sender:UIButton)
    {
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                       return
        }
        
        appDelegate.ShowProgess()
        
        self.tblviewCart.isHidden = true
        
        var item_id = String()
        
        item_id = "\(self.CartModelData[sender.tag].itemId!)"
        
        let Paramteres = ["type":"products","module":"shopping","item_id":item_id]
        
        print(Paramteres)
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.remove_item_from_cart)!, params: Paramteres, finish: self.FinishRemoveWebserviceCall)
    }
    
    @objc func HomeScreen(sender:UIButton)
    {
        appDelegate.SetHomeRoot()
    }
    
    
    
    @objc func FavouriteUnFavourite(sender:UIButton)
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        var arrParam = [[String:String]]()
        arrParam.append(["id":"\(self.CartModelData[sender.tag].productId!)","type":"products","module":"shopping"])
        let param = addSelectedParameters(index:sender.tag, param: arrParam)
        print(param)
        
        let apiToken = "Bearer \(appDelegate.get_user_Data(Key: "token"))"
        let headers:HTTPHeaders = ["Authorization": apiToken,"Accept":"application/json"]
        
        var UrlPass = String()
        UrlPass = WebURL.manage_wishlist
        
        Alamofire.request(UrlPass, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
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
                    print(dict)
                    
                    appDelegate.ShowProgess()
                    
                    self.tblviewCart.isHidden = true
                    
                    var item_id = String()
                    
                    item_id = "\(self.CartModelData[sender.tag].itemId!)"
                    
                    let Paramteres = ["type":"products","module":"shopping","item_id":item_id]
                    
                    print(Paramteres)
                    
                    APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.remove_item_from_cart)!, params: Paramteres, finish: self.FinishRemoveWebserviceCall)
                    
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
                    DispatchQueue.main.async {
                        appDelegate.HideProgress()
                        appDelegate.ErrorMessage(Message: dict.value(forKey: "message") as! String, ContorllerName: self)
                        return
                    }
                }
                
            }
            else {
                
                appDelegate.HideProgress()
                Loaf(LocalValidations.ServerError, state: .error, sender: self).show()
                return
            }
        }
        
        
        
    }
    
    func addSelectedParameters(index:Int, param: [[String:Any]]) -> [String:Any] {
        var arrParam = param
        for obj1 in self.CartModelData[index].variation
        {
            let keystring = obj1.value(forKey: "name") as! String
            let tempParam = [keystring: "\((obj1.value(forKey: "value") as! String))"]
            arrParam.append(tempParam)
            
            
        }
        
        var param = arrParam.flatMap { $0 }.reduce([:]) { $0.merging($1) { (current, _) in current } }
        return param
    }
    
    
    func getVariationString(index: Int) -> String {
        var arrParam = ""
        for obj1 in self.CartModelData[index].variation
        {
            let keystring = obj1.value(forKey: "title")!
            var value = String()
            if keystring as! String == "Color"
            {
                value = "\(obj1.value(forKey: "color_name")!)"
            }
            else
            {
                value = "\(obj1.value(forKey: "value")!)"
            }
            
            let str = "\(keystring): \(value), "
            
            
            
            arrParam.append(str)
        }
        
        arrParam = String(arrParam.dropLast())
        arrParam = String(arrParam.dropLast())
        
        return arrParam
    }
    
    func SetUI()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewCart.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
            
            self.tblviewCart.register(CartCellXIB.self, forCellReuseIdentifier: "CartCellXIB")
                  self.tblviewCart.register(UINib(nibName: "CartCellXIB", bundle: nil), forCellReuseIdentifier: "CartCellXIB")
                  
                  self.tblviewCart.register(NoDataCartHeaderCellXIB.self, forCellReuseIdentifier: "NoDataCartHeaderCellXIB")
                  self.tblviewCart.register(UINib(nibName: "NoDataCartHeaderCellXIB", bundle: nil), forCellReuseIdentifier: "NoDataCartHeaderCellXIB")
                  
                  self.tblviewCart.register(HeaderTableCellXIB.self, forCellReuseIdentifier: "HeaderTableCellXIB")
                  self.tblviewCart.register(UINib(nibName: "HeaderTableCellXIB", bundle: nil), forCellReuseIdentifier: "HeaderTableCellXIB")
                  
                  self.tblviewCart.register(CartScrollXIB.self, forCellReuseIdentifier: "CartScrollXIB")
                  self.tblviewCart.register(UINib(nibName: "CartScrollXIB", bundle: nil), forCellReuseIdentifier: "CartScrollXIB")
            
            self.tblviewCart.isHidden = true
            self.btnTitleCart.isHidden = true
            
            if CommonClass.sharedInstance.isReachable() == false
            {
                Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                return
            }
            
            
            appDelegate.ShowProgess()
            let Paramteres = ["module":"shopping","type":"products"]
            
            APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_cart_details)!, params: Paramteres, finish: self.FinishSocialWebserviceCall)
                  
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
                            
                            DispatchQueue.main.async {
                                
                                
                                
                                self.CartModelData.removeAll()
                                self.DataSet.removeAll()
                                self.ToppicksDisplayModel.removeAll()
                                let Shoppingdata = dict["data"].dictionaryObject! as NSDictionary
                                

                                let Categories = Shoppingdata.value(forKey: "cart") as! NSDictionary
                                
                                let cart1 = Categories.value(forKey: "items") as! NSArray
                                print(cart1.count)
                                
                                for object in cart1
                                {
                                    let Data_Object = CartListModel.init(fromDictionary: object as! [String : Any])
                                    self.CartModelData.append(Data_Object)
                                    
                                }
                                
                                if self.CartModelData.count == 0 {
                                    self.isCartData = false
                                    self.btnHeight.constant = 0
                                    
                                    let top_picks = Shoppingdata.value(forKey: "top_picks") as! NSArray
                                    self.DataSet.append("cart_detail")
                                    
                                    if top_picks.count != 0
                                    {
                                        self.DataSet.append("header_view")
                                        self.DataSet.append("Top Picks for You")
                                        
                                    }
                                    
                                    for object in top_picks
                                    {
                                        let Data_Object = TodaysDeal.init(fromDictionary: object as! [String : Any])
                                        self.ToppicksDisplayModel.append(Data_Object)
                                    }
                                    
                                    
                                    self.btnTitleCart.isHidden = true
                                } else {
                                    
                                    
                                    self.totalitemscharge = Categories.value(forKey: "cart_total") as! NSNumber
                                    self.servicecharge = (Categories.value(forKey: "service_charge") as! String).numberValue!
                                    self.deliverycharge = (Categories.value(forKey: "shipping_charge") as! String).numberValue!
                                    self.granndTotal = (Categories.value(forKey: "grand_total") as! NSNumber)
                                    
                                    self.btnHeight.constant = 45
                                    self.isCartData = true
                                    self.btnTitleCart.isHidden = false
                                    
                                }
                                
                                self.tblviewCart.reloadData()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:
                                    {
                                        
                                        self.tblviewCart.isHidden = false
                                        appDelegate.HideProgress()
                                })
                                
                                
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
    
    func FinishRemoveWebserviceCall (message:String, data:Data?) -> Void
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
                                
                                self.tblviewCart.isHidden = true
                                self.btnTitleCart.isHidden = true
                                
                                if CommonClass.sharedInstance.isReachable() == false
                                {
                                    Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                                    return
                                }
                                
                                
                                appDelegate.ShowProgess()
                                let Paramteres = ["module":"shopping","type":"products"]
                                
                                APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_cart_details)!, params: Paramteres, finish: self.FinishSocialWebserviceCall)
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
    
}

//MARK:- TABLEVEW METHODS


extension CartVC:UITableViewDataSource,UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.isCartData == false
        {
            return self.DataSet.count
        }
        else
        {
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if CartModelData.count == 0 {
            
            return 1
        } else {
            
            return CartModelData.count
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.isCartData == false
        {
            if DataSet[indexPath.section] == "cart_detail"
            {
                let cell = self.tblviewCart.dequeueReusableCell(withIdentifier: "NoDataCartHeaderCellXIB") as! NoDataCartHeaderCellXIB
                
                cell.bttnTitleShopNow.addTarget(self, action: #selector(self.HomeScreen(sender:)), for: .touchUpInside)
                
                return cell
            }
            else if DataSet[indexPath.section] == "header_view"
            {
                let cell = self.tblviewCart.dequeueReusableCell(withIdentifier: "HeaderTableCellXIB") as! HeaderTableCellXIB
                
                cell.lblHeader.text = "Recommended Products"
                
                return cell
            }
            else if DataSet[indexPath.section] == "Top Picks for You"
            {
                let cell = self.tblviewCart.dequeueReusableCell(withIdentifier: "TableScrollCell") as! TableScrollCell
                
                cell.CollectionCart.delegate = self
                cell.CollectionCart.dataSource = self
                self.TopPicksCollection = cell.CollectionCart
                
                return cell
                
            }
            else
            {
                return UITableViewCell()
            }
        }
        else
        {
            let cell = self.tblviewCart.dequeueReusableCell(withIdentifier: "CartCellXIB") as! CartCellXIB
            
            if self.CartModelData.count > 0
            {
                cell.imgviewPic.kf.indicatorType = .activity
                cell.imgviewPic.kf.setImage(with: URL(string: self.CartModelData[indexPath.row].thumbnailImg!))
                cell.lblTitle.text = self.CartModelData[indexPath.row].productName!
                cell.lblQty.text = "\(self.CartModelData[indexPath.row].qty!)"
                
                cell.lblOldPrice.text = "$ " + "\(self.CartModelData[indexPath.row].price!)"
                cell.lblOff.text = ""
                cell.lblVariations.text = self.getVariationString(index: indexPath.row)
                
                
                cell.btnTitleMove.setTitle("Move to wishlist", for: .normal)
                
                cell.btnTitleMove.tag = indexPath.row
                cell.btnTitleMove.addTarget(self, action: #selector(self.FavouriteUnFavourite(sender:)), for: .touchUpInside)
                
                cell.btnTitleRepeat.tag = indexPath.row
                cell.btnTitleRepeat.addTarget(self, action: #selector(self.RemoveProduct(sender:)), for: .touchUpInside)
                
                
                
                
            }
            
            cell.selectionStyle = .none
            DispatchQueue.main.async {
                
                cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.16, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 5)
                cell.viewLeftSide.round(corners: .bottomLeft, cornerRadius: 7)
                cell.viewMainLef.round(corners: .bottomLeft, cornerRadius: 7)
                
            }
            
            
            
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.isCartData == false
        {
            if DataSet[indexPath.section] == "cart_detail"
            {
                return 300
            }
            else if DataSet[indexPath.section] == "header_view"
            {
                return 30
            }
            else if DataSet[indexPath.section] == "Top Picks for You"
            {
                var Height1 = (self.tblviewCart!.frame.width - 5)/2
                Height1 = Height1 + 100
                return Height1
            }
            else
            {
                return 0
            }
        }
        else
        {
            return UITableView.automaticDimension
        }
        
    }
}


extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Metropolis-SemiBold", size: 20)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}


extension CartVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.ToppicksDisplayModel.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.ToppicksDisplayModel.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = self.TopPicksCollection!.dequeueReusableCell(withReuseIdentifier: "CollectionDataCell", for: indexPath) as! CollectionDataCell
        
        if self.ToppicksDisplayModel.count > 0
        {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:
                {
                    
                    cell.viewBackGround.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 8)
                    
            })
            
            
            
            
            cell.imgviewProduct.kf.indicatorType = .activity
            cell.imgviewProduct.kf.setImage(with: URL(string: self.ToppicksDisplayModel[indexPath.row].thumbnailImg))
            
            
            
            
            cell.lblProductName.text = self.ToppicksDisplayModel[indexPath.row].name!
            
            cell.lblPrice.text = "$ " + "\(self.ToppicksDisplayModel[indexPath.row].price!)"
            
            if self.ToppicksDisplayModel[indexPath.row].price == self.ToppicksDisplayModel[indexPath.row].unitPrice!
            {
                
                cell.lblOff.text = ""
            }
            else
            {
                
                let Offer = Float(self.ToppicksDisplayModel[indexPath.row].discount!)
                let x = Double(Offer).rounded(toPlaces: 1)
                var y = Int(x)
                cell.lblOff.text = "\(y)" + "% off"
                
                
            }
            
            let review = Float(self.ToppicksDisplayModel[indexPath.row].review!)
            let x = Double(review).rounded(toPlaces: 1)
            cell.lblReview.text = "\(x)"
            
            
        }
        
        return cell
    }
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        var Height1 = (self.TopPicksCollection!.frame.width - 5)/2
        Height1 = Height1 + 100
        return CGSize(width: (self.TopPicksCollection!.frame.width - 5)/2, height: Height1 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        Push.product_id = "\(self.ToppicksDisplayModel[indexPath.row].id!)"
        self.navigationController?.pushViewController(Push, animated: true)
        
        
    }
}

extension String {
    var numberValue: NSNumber? {
        if let value = Int(self) {
            return NSNumber(value: value)
        }
        return nil
    }
}
