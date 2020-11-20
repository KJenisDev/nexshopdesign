//
//  OrderDetailVC.swift
//  Nexshop
//
//  Created by Mac on 05/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import BottomPopup
import SwiftyJSON
import Alamofire
import Loaf

class OrderDetailVC: UIViewController,BottomPopupDelegate
{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var tblviewOrder: UITableView!
    @IBOutlet weak var viewMain: UIView!
    
    
    //MARK:- VARIABLES
    
    var height: CGFloat = 400
    var topCornerRadius: CGFloat = 35
    var presentDuration: Double = 1.0
    var dismissDuration: Double = 1.0
    let kHeightMaxValue: CGFloat = 600
    let kTopCornerRadiusMaxValue: CGFloat = 35
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    var OrderDetailDict = NSMutableDictionary()
    var isOrderid = String()
    var items = NSMutableArray()
    var product_id = String()
    var type = String()
    var isLabtest = false
    var isFrom = false
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // height = self.view.frame.height - 80
        
        self.tblviewOrder.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
            
        }
        
        self.tblviewOrder.register(OrderDetailHeaderXIB.self, forCellReuseIdentifier: "OrderDetailHeaderXIB")
        self.tblviewOrder.register(UINib(nibName: "OrderDetailHeaderXIB", bundle: nil), forCellReuseIdentifier: "OrderDetailHeaderXIB")
        
        
        self.tblviewOrder.register(OrderDataCellXIB.self, forCellReuseIdentifier: "OrderDataCellXIB")
        self.tblviewOrder.register(UINib(nibName: "OrderDataCellXIB", bundle: nil), forCellReuseIdentifier: "OrderDataCellXIB")
        
        
        self.tblviewOrder.register(OrderShippingDetailsVC.self, forCellReuseIdentifier: "OrderShippingDetailsVC")
        self.tblviewOrder.register(UINib(nibName: "OrderShippingDetailsVC", bundle: nil), forCellReuseIdentifier: "OrderShippingDetailsVC")
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.GetOrderDetail()
        
    }
    
    // MARK:- ALL FUNCTIONS
    
    @objc func ReviewPopup(sender:UIButton)
    {
        
        print(self.items.object(at: sender.tag) as! NSDictionary)
        
        guard let popupVC = mainStoryboard.instantiateViewController(withIdentifier: "RateAndReviewProductVC") as? RateAndReviewProductVC else { return }
        popupVC.OrderDetailDict = (self.items.object(at: sender.tag) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        popupVC.height = 375
        popupVC.topCornerRadius = topCornerRadius
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.popupDelegate = self
        popupVC.type = "products"
        popupVC.product_id = "\((self.items.object(at: sender.tag) as! NSDictionary).value(forKey: "product_id") as! NSNumber)"
        popupVC.OrderReviewDelegate = self
        
        present(popupVC, animated: true, completion: nil)
        
        
    }
    
    func getVariationString(index: Int) -> String {
        
        let ItemArray = ((self.items.object(at: index
            ) as! NSDictionary).value(forKey: "variation") as! NSArray)
        
        print(ItemArray)
        
        
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
    
    func GetOrderDetail()
    {
        
        let apiToken = "Bearer \(appDelegate.get_user_Data(Key: "token"))"
        let headers:HTTPHeaders = ["Authorization": apiToken,"Accept":"application/json"]
        
        var url1 = "https://zestbrains.techboundary.xyz/public/api/v1/app/get_order_details/" + "\(self.isOrderid)"
        
        print(url1)
        
        
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
                
                print(dict)
                
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
                    
                    
                    self.OrderDetailDict = ProductData.mutableCopy() as! NSMutableDictionary
                    self.items = (self.OrderDetailDict.value(forKey: "items") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    
                    self.tblviewOrder.reloadData()
                    self.tblviewOrder.isHidden = false
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnHandlerTrack(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "OrderTrackingVC") as! OrderTrackingVC
        Push.isOrderid = "\((self.OrderDetailDict.value(forKey: "order_id") as! NSNumber))"
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        if self.isFrom == true
        {
            appDelObj.SetHomeRoot()
        }
        else
        {
        self.navigationController?.popViewController(animated: true)
        }
    }
    
}


extension OrderDetailVC:UITableViewDelegate,UITableViewDataSource
{
    //MARK:- TABLEVIEW METHODS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //
        
        if indexPath.section == 1
        {
            
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 1
        }
        else if section == 1
        {
            if self.items.count > 0
            {
                return self.items.count
            }
            else
            {
                return 0
            }
            
        }
        else
        {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.OrderDetailDict.count == 0
        {
            return UITableViewCell()
        }
        else
        {
            if indexPath.section == 0
            {
                let cell = self.tblviewOrder.dequeueReusableCell(withIdentifier: "OrderDetailHeaderXIB") as! OrderDetailHeaderXIB
                
                cell.lblID.text = "\(self.OrderDetailDict.value(forKey: "order_number") as! String)"
                
                cell.lblStatus.text =  "\(self.OrderDetailDict.value(forKey: "order_status") as! String)"
                
                
                
                return cell
                
                
            }
            else if indexPath.section == 1
                
            {
                
                
                if self.items.count > 0
                {
                    
                    let cell = self.tblviewOrder.dequeueReusableCell(withIdentifier: "OrderDataCellXIB") as! OrderDataCellXIB
                    
                    var Date1 = self.OrderDetailDict.value(forKey: "date") as! String
                    Date1 = CommonClass.sharedInstance.convertDateFormatter4(date: Date1)
                    print(Date1)
                    
                    print(self.items.object(at: indexPath.row) as! NSDictionary)
                    
                    
                    cell.lblPrice.text = "$ " + "\((self.items.object(at: indexPath.row) as! NSDictionary).value(forKey: "price") as! NSNumber)"
                    
                    Date1 = "Placed on " + "\(Date1)"
                    
                    cell.btnTitlePlaced.setTitle(Date1, for: .normal)
                    
                    cell.lblProductName.text = "\((self.items.object(at: indexPath.row) as! NSDictionary).value(forKey: "name") as! String)"
                    
                    DispatchQueue.main.async {
                        cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 10)
                        cell.viewLeftSide.round(corners: .bottomLeft, cornerRadius: 5)
                        cell.viewMainLeft.round(corners: .bottomLeft, cornerRadius: 5)
                        
                        cell.viewRight.round(corners: .bottomRight, cornerRadius: 5)
                        cell.viewMainRight.round(corners: .bottomRight, cornerRadius: 10)
                        
                    }
                    
                    
                    cell.lblVariations.text = getVariationString(index: indexPath.row)
                    
                    
                    cell.lblQTY.text = "Qty: " + "\((self.items.object(at: indexPath.row) as! NSDictionary).value(forKey: "qty") as! NSNumber)" 
                    
                    
                    cell.imgviewProduct.kf.indicatorType = .activity
                    cell.imgviewProduct.kf.setImage(with: URL(string: ((((self.items.object(at: indexPath.row) as! NSDictionary).value(forKey: "thumbnail_img") as! String)))))
                    
                    
                    let is_review_added = ((self.items.object(at: indexPath.row) as! NSDictionary).value(forKey: "is_review_added") as! NSNumber)
                    
                    let order_status =  (self.OrderDetailDict.value(forKey: "order_status") as! String)
                    print(self.items.object(at: indexPath.row) as! NSDictionary)
                    
                    print(is_review_added)
                    print(order_status)
                    
                    if is_review_added == 0 && order_status == "Delivered"
                    {
                        cell.btnReview.isUserInteractionEnabled = true
                        
                        cell.btnReview.tag = indexPath.row
                        
                        cell.btnReview.tag = indexPath.row
                        cell.btnReview.addTarget(self, action: #selector(self.ReviewPopup(sender:)), for: .touchUpInside
                        )
                        cell.btnTitleRate.addTarget(self, action: #selector(self.ReviewPopup(sender:)), for: .touchUpInside
                        )
                        
                        cell.btnReview.setTitle("Rate & Review Product", for: .normal)
                        cell.btnTitleRate.setTitle("", for: .normal)
                        
                    }
                    else
                    {
                        cell.btnTitleRate.isUserInteractionEnabled = false
                        
                        cell.btnTitleRate.setTitle("", for: .normal)
                        cell.btnReview.setTitle("", for: .normal)
                        
                        
                    }
                    
                    
                    return cell
                }
                else
                {
                    return UITableViewCell()
                }
                
            }
                
            else
            {
                let cell = self.tblviewOrder.dequeueReusableCell(withIdentifier: "OrderShippingDetailsVC") as! OrderShippingDetailsVC
                
                
                if self.OrderDetailDict.count > 0
                {
                    let coupon_code = self.OrderDetailDict.value(forKey: "coupon_code") as! String
                    
                    if coupon_code.isEmpty == true
                    {
                        cell.lblDiscountPriceConstraint.constant = 0
                        cell.lblDiscountStaticConstraint.constant = 0
                        
                        cell.lblDiscountPrice.text = ""
                        cell.lblDiscountStatic.text = ""
                        
                    }
                    else
                    {
                        cell.lblDiscountPriceConstraint.constant = 15
                        cell.lblDiscountStaticConstraint.constant = 15
                        
                        cell.lblDiscountPrice.text = "\(self.OrderDetailDict.value(forKey: "coupon_discount") as! NSNumber)"
                        cell.lblDiscountStatic.text = "Discount ( " + "\(coupon_code)" + " )"
                        
                    }
                    
                    
                    
                    let  shipping_address = self.OrderDetailDict.value(forKey: "shipping_address") as! NSDictionary
                    
                    cell.lblAddress.text = ((self.OrderDetailDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "house_number") as! String) + " , " + ((self.OrderDetailDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "landmark") as! String) + " , " + ((self.OrderDetailDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "city") as! String) + " , " +  ((self.OrderDetailDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "zipcode") as! String) + "\n" + "Mobile number: " + "\(((self.OrderDetailDict.value(forKey: "shipping_address") as! NSDictionary).value(forKey: "mobile_no") as! String))"
                    
                    cell.lblName.text = "\(shipping_address.value(forKey: "name") as! String)"
                    cell.lblType.text = "\(shipping_address.value(forKey: "tag") as! String)"
                    
                    cell.lblGrandTotal.text = "₹ " + "\(self.OrderDetailDict.value(forKey: "grand_total") as! NSNumber)"
                    cell.lblShippingCharge.text = "₹ " + "\(self.OrderDetailDict.value(forKey: "shipping_charge") as! NSNumber)"
                    cell.lblServiceCharge.text = "₹ " + "\(self.OrderDetailDict.value(forKey: "service_charge") as! NSNumber)"
                    
                    cell.lblTotalCharge.text = "₹ " + "\(self.OrderDetailDict.value(forKey: "item_total") as! NSNumber)"
                    
                }
                
                return cell
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 65
        }
        else if indexPath.section == 1
        {
            return 150
        }
        else
        {
            return UITableView.automaticDimension
        }
        
    }
    
    
}



extension OrderDetailVC : UpdateOrder
{
    func UpdateOrder(isReload:Bool)
    {
        if isReload == true
        {
            appDelObj.ShowProgess()
            self.GetOrderDetail()
        }
        
    }
    
}
