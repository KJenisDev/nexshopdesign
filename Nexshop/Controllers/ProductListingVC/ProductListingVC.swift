//
//  ProductListingVC.swift
//  Nexshop
//
//  Created by Mac on 03/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import BottomPopup
import Kingfisher
import SwiftyJSON
import Loaf

class ProductListingVC: UIViewController,BottomPopupDelegate{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var CollectionviewHome: UICollectionView!
    @IBOutlet weak var viewMain: UIView!
    
    
    
    
    
    
    //MARK:- VARIABLES
    var height: CGFloat = 300
    var topCornerRadius: CGFloat = 35
    var presentDuration: Double = 1.0
    var dismissDuration: Double = 1.0
    let kHeightMaxValue: CGFloat = 600
    let kTopCornerRadiusMaxValue: CGFloat = 35
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    var isFromMedical = false
    var TodaysDisplayModel = [TodaysDeal]()
    var Headername = String()
    var Categoryid = String()
    var order_by = String()
    var customer_review = String()
    var sub_category_id = NSMutableArray()
    var isfirstAddress = String()
    var isFirstAddressid = String()
    var DisplayGetAddressModel = [GetAddressModel]()
    var isFromViewMore = false
    var delivery_day = "0"
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CollectionviewHome.isHidden = true
        
        height = self.view.frame.height - 100
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
            
        }
        self.CollectionviewHome.register(UINib(nibName: "HomeSingleProductCelXIB", bundle: nil), forCellWithReuseIdentifier: "HomeSingleProductCelXIB")
        
        self.CollectionviewHome.register(UINib(nibName: "ShoppingCategoryListCellXIB", bundle: nil), forCellWithReuseIdentifier: "ShoppingCategoryListCellXIB")
        
        self.CollectionviewHome.backgroundColor = UIColor.clear
        
        
        
        if self.Categoryid.isEmpty == true
        {
            self.lblHeader.text = "Shopping"
            
            self.CollectionviewHome.reloadData()
            
            self.CollectionviewHome.isHidden = false
        }
        else
        {
            appDelegate.ShowProgess()
            self.lblHeader.text = "\(Headername)"
            
            
            var UrlPass = String()
            let arr = self.sub_category_id.componentsJoined(by: ",")
            
            if self.order_by == "Featured"
            {
                self.order_by = ""
            }
            
            
            UrlPass = WebURL.CategoryData
         //   self.delivery_day = ""
            let Paramteres = ["type":"shopping","category_id":self.Categoryid,"limit":"","offset":"","order_by":self.order_by,"customer_review":self.customer_review,"sub_category_id":arr,"delivery_day":self.delivery_day]
            
            print(Paramteres)
            
            
            APIMangagerClass.callPostWithHeader(url: URL(string: UrlPass)!, params: Paramteres, finish: self.GetProductsWebserviceCall)
            
            
        }
        
        
        
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        let Paramteres = ["":""]
        
        appDelegate.ShowProgess()
        
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_addresses)!, params: Paramteres, finish: self.GetAddressWebService)
        
        
        
        
    }
    
    
    
    //MARK:- ALL FUNCTIONS
    
    func GetAddressWebService (message:String, data:Data?) -> Void
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
                                
                                self.DisplayGetAddressModel.removeAll()
                                
                                let user_Data:NSArray = (dict["data"].arrayObject! as NSArray)
                                
                                
                                
                                if user_Data.count > 0
                                {
                                    for object in user_Data
                                    {
                                        let Data_Object = GetAddressModel.init(fromDictionary: object as! [String : Any])
                                        self.DisplayGetAddressModel.append(Data_Object)
                                    }
                                    
                                    self.isFirstAddressid = "\((user_Data.object(at: 0) as! NSDictionary).value(forKey: "id") as! Int)"
                                    self.isfirstAddress = "\(self.DisplayGetAddressModel[0].name!)" + " , " + "\(self.DisplayGetAddressModel[0].city!)" + " , " +  "\(self.DisplayGetAddressModel[0].zipcode!)"
                                    self.lblAddress.text = "\(self.isfirstAddress)"
                                    
                                    
                                }
                                    
                                else
                                {
                                    
                                    self.isFirstAddressid = String()
                                    self.isfirstAddress = String()
                                    
                                    self.lblAddress.text = "Add your address"
                                    
                                    
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
    
    func GetProductsWebserviceCall (message:String, data:Data?) -> Void
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
                                
                                self.TodaysDisplayModel.removeAll()
                                
                                let user_Data:NSArray = (dict["data"].arrayObject! as NSArray)
                                
                                
                                
                                if user_Data.count > 0
                                {
                                    for object in user_Data
                                    {
                                        let Data_Object = TodaysDeal.init(fromDictionary: object as! [String : Any])
                                        self.TodaysDisplayModel.append(Data_Object)
                                    }
                                    self.CollectionviewHome.reloadData()
                                    self.CollectionviewHome.isHidden = false
                                    self.lblNoData.text = ""
                                    self.lblNoData.isHidden = true
                                    
                                }
                                else
                                {
                                    self.lblNoData.text =  "No products avalible at the moments, Try again later !"
                                    self.lblNoData.isHidden = false
                                    self.CollectionviewHome.isHidden  = true
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
    
    @IBAction func btnHandlerSelectAddress(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
        Push.isFromPush = true
        Push.selected_address_id = isFirstAddressid
        Push.UpadteAddresswithLocationDelegate = self
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
    
    
    
    @IBAction func btnHandlerSearch(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHandlerFilter(_ sender: Any)
    {
        if self.order_by == "price_high_to_low"
        {
            self.order_by = "Price: High to Low"
        }
        else if self.order_by == "price_low_to_high"
        {
            self.order_by = "Price: Low to High"
        }
        else
        {
            self.order_by = "Featured"
        }
        if customer_review == ""
        {
            self.customer_review = "All"
        }
        else
        {
            if self.customer_review == "1"
            {
                self.customer_review = "1 Star"
            }
            else if self.customer_review == "2"
            {
                self.customer_review = "2 Star"
            }
            else if self.customer_review == "3"
            {
                self.customer_review = "3 Star"
            }
            else if self.customer_review == "4"
            {
                self.customer_review = "4 Star"
            }
            else if self.customer_review == "5"
            {
                self.customer_review = "5 Star"
            }
        }
        
        print(self.delivery_day)
        
        
        guard let popupVC = self.storyboard!.instantiateViewController(withIdentifier: "FilterBottomPopUpVC") as? FilterBottomPopUpVC else { return }
        popupVC.height = height
        popupVC.SubCategoryDeleagate = self
        popupVC.order_by = self.order_by
        popupVC.customer_review = self.customer_review
        popupVC.SubCategoryArray = self.sub_category_id
        popupVC.Categoryid = self.Categoryid
        popupVC.topCornerRadius = topCornerRadius
        popupVC.presentDuration = 0.5
        popupVC.dismissDuration = 0.5
        popupVC.popupDelegate = self
        popupVC.delivery_day = self.delivery_day
        present(popupVC, animated: true, completion: nil)
    }
    
    
}


//MARK:- COLLECTIONVIEW METHODS

extension ProductListingVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.Categoryid.isEmpty == true
        {
            return self.TodaysDisplayModel.count
        }
        else
        {
            return self.TodaysDisplayModel.count
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "HomeSingleProductCelXIB", for: indexPath) as! HomeSingleProductCelXIB
        
        if self.TodaysDisplayModel.count > 0
        {
            
//            DispatchQueue.main.async {
//                cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 8)
//            }
            
            if self.TodaysDisplayModel[indexPath.row].is_wishlisted == 1
            {
                cell.imgviewHeart.image = UIImage(named: "ic_red_heart")
                cell.btnTitleHeart.tag = indexPath.row
                //  cell.btnTitleHeart.addTarget(self, action: #selector(self.RemoveWishList(sender:)), for: .touchUpInside)
            }
            else
            {
                cell.imgviewHeart.image = UIImage(named: "ic_grey_heart")
                cell.btnTitleHeart.tag = indexPath.row
                //  cell.btnTitleHeart.addTarget(self, action: #selector(self.AddWishList(sender:)), for: .touchUpInside)
            }
            
            cell.imgviewProduct.kf.indicatorType = .activity
            cell.imgviewProduct.kf.setImage(with: URL(string: self.TodaysDisplayModel[indexPath.row].thumbnailImg))
            
            cell.lblName.text = self.TodaysDisplayModel[indexPath.row].name!
            
            cell.lblOldPrice.text = "$ " + "\(self.TodaysDisplayModel[indexPath.row].price!)"
            
            if self.TodaysDisplayModel[indexPath.row].price == self.TodaysDisplayModel[indexPath.row].unitPrice!
            {
                
                cell.lblOff.text = ""
            }
            else
            {
                
                let Offer = Float(self.TodaysDisplayModel[indexPath.row].discount!)
                let x = Double(Offer).rounded(toPlaces: 1)
                var y = Int(x)
                cell.lblOff.text = "\(y)" + "% off"
                
                
            }
            
            let review = Float(self.TodaysDisplayModel[indexPath.row].review!)
            let x = Double(review).rounded(toPlaces: 1)
            cell.lblRatings.text = "\(x)"
            
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: (self.CollectionviewHome.frame.width - 5)/2, height: 310 )
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        Push.product_id = "\(self.TodaysDisplayModel[indexPath.row].id!)"
        self.navigationController?.pushViewController(Push, animated: true)
    }
}


extension ProductListingVC: SelectAddress
{
    func SelectAddressFtn(isAddressId: String, isAddress: String, Name: String, City: String, ZipCode: String) {
        
        print("hhh")
    }
    
    
    
    
}

extension ProductListingVC : UpdateProductList
{
    func UpdateProductList(Sortby:String,Ratings:String,SubCategory:NSMutableArray, delivery_day: String)
    {
        self.view.endEditing(true)
        
        
        if Sortby == "Price: High to Low"
        {
            self.order_by = "price_high_to_low"
        }
        else if Sortby == "Price: Low to High"
        {
            self.order_by = "price_low_to_high"
            
        }
        else
        {
            self.order_by = ""
            
        }
        if Ratings == "All" || Ratings.isEmpty == true
        {
            self.customer_review = ""
        }
        else
        {
            if Ratings == "1 Star"
            {
                self.customer_review = "1"
            }
            else if Ratings == "2 Star"
            {
                self.customer_review = "2"
            }
            else if Ratings == "3 Star"
            {
                self.customer_review = "3"
            }
            else if Ratings == "4 Star"
            {
                self.customer_review = "4"
            }
            else if Ratings == "5 Star"
            {
                self.customer_review = "5"
            }
        }
        
        
        if delivery_day.isEmpty == true
        {
            self.delivery_day = "0"
        }
        else
        {
            print(delivery_day)
            
            if delivery_day == "Get it by tomorrow"
            {
                self.delivery_day = "1"
            }
            else
            {
                self.delivery_day = "0"
                
            }
            
        }
        
        self.sub_category_id = SubCategory.mutableCopy() as! NSMutableArray
        self.CollectionviewHome.isHidden = true
        appDelegate.ShowProgess()
        
        let arr = self.sub_category_id.componentsJoined(by: ",")
        
        if self.order_by == "Featured"
        {
            self.order_by = ""
        }
        
        let Paramteres = ["type":"shopping","category_id":self.Categoryid,"limit":"","offset":"","order_by":self.order_by,"customer_review":self.customer_review,"sub_category_id":arr,"delivery_day":self.delivery_day]
        
        print(Paramteres)
        
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.CategoryData)!, params: Paramteres, finish: self.GetProductsWebserviceCall)
        
    }
    
    
    
}

extension ProductListingVC : UpdateAddresswithLocation
{
    func UpdateAddresswithLocation(isAddressId: String, isAddress: String, Name: String, City: String, State: String, ZipCode: String, latitude: String, longitude: String, selectedAddModel: GetAddressModel?) {
        
        
        self.isFirstAddressid = "\(isAddressId)"
        self.isfirstAddress = "\(Name)" + " , " + "\(City)" + " , " +  "\(ZipCode)"
        self.lblAddress.text = "\(self.isfirstAddress)"
        
    }
    
}
