//
//  ProductDetailVC.swift
//  Nexshop
//
//  Created by Mac on 06/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AVFoundation
import Cosmos
import BottomPopup
import AVFoundation
import AVKit
import Loaf
import AZTabBar
import FirebaseDynamicLinks


class ImageSliderTableCell:UITableViewCell
{
    
    @IBOutlet weak var CollectionviewSlider: UICollectionView!
}

class ImageSliderCollectionCell:UICollectionViewCell
{
    
    @IBOutlet weak var imgviewPic: UIImageView!
}

class ProductVariations:UITableViewCell
{
    
    @IBOutlet weak var btnTitleSelectQty: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var CollectionviewVariations: UICollectionView!
}

class ProductVaritionsCollectionCell:UICollectionViewCell
{
    
    @IBOutlet weak var btnTitleVariant: UIButton!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblVariations: UILabel!
}



class ProductDetailVC: UIViewController {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var TblviewDetail: UITableView!
    @IBOutlet weak var viewBottomConstaraint: NSLayoutConstraint!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet var viewColorSubview: UIView!
    @IBOutlet weak var viewCartAdded: UIView!
    
    
    //MARK:- VARIABLES
    
    @IBOutlet weak var CollectionviewColor: UICollectionView!
    
    var CollectionviewImage:UICollectionView?
    var CollectionviewVariations:UICollectionView?
    
    var Image_Zoom = String()
    var product_id = String()
    var is_Selected_color = String()
    var ProductDetailDict = NSMutableDictionary()
    var isFromShare = String()
    var related_products = NSMutableArray()
    var bought_items = NSMutableArray()
    var reviews = NSMutableArray()
    var sponsored_products = NSMutableArray()
    var delivery_slabs = NSMutableDictionary()
    var seller = NSMutableDictionary()
    var review_count = NSMutableDictionary()
    let regularFont = UIFont(name: "Metropolis-Regular", size: 15.0)
    let boldFont = UIFont(name: "Metropolis-Regular", size: 17.0)
    var colorIndex = 0
    var VariationsDataModel = [VariationsModel]()
    var ColorsDataArray = [String]()
    var isQty = 0
    var is_wishlisted = Int()
    var wishlist_item_id = Int()
    var discount = Float()
    var discount_type = String()
    var price = Float()
    var product_quantity = String()
    var product_status = String()
    var unit_price = Float()
    var isfirstAddress = String()
    var isFirstAddressid = String()
    var seller_user_id = String()
    var DisplayGetAddressModel = [GetAddressModel]()
    var Delivery_Date = String()
    var height: CGFloat = 300
    var topCornerRadius: CGFloat = 35
    var presentDuration: Double = 0.5
    var dismissDuration: Double = 0.5
    let kHeightMaxValue: CGFloat = 600
    let kTopCornerRadiusMaxValue: CGFloat = 35
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    var imgArray = NSArray()
    
    var DataSet = [String]()
    
    var tabController:AZTabBarController!

    
    var imageSelectedIndex = 0
    
    var isToBuyNow = false
    var type = String()
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TblviewDetail.register(ProductDetailHeaderCellXIB.self, forCellReuseIdentifier: "ProductDetailHeaderCellXIB")
        self.TblviewDetail.register(UINib(nibName: "ProductDetailHeaderCellXIB", bundle: nil), forCellReuseIdentifier: "ProductDetailHeaderCellXIB")
        
        
        self.TblviewDetail.register(ProductDetailHeaderPriceCellXIB.self, forCellReuseIdentifier: "ProductDetailHeaderPriceCellXIB")
        self.TblviewDetail.register(UINib(nibName: "ProductDetailHeaderPriceCellXIB", bundle: nil), forCellReuseIdentifier: "ProductDetailHeaderPriceCellXIB")
        
        
        self.TblviewDetail.register(ProductDetailAboutXIB.self, forCellReuseIdentifier: "ProductDetailAboutXIB")
        self.TblviewDetail.register(UINib(nibName: "ProductDetailAboutXIB", bundle: nil), forCellReuseIdentifier: "ProductDetailAboutXIB")
        
        self.TblviewDetail.register(ReviewsCellXIB.self, forCellReuseIdentifier: "ReviewsCellXIB")
        self.TblviewDetail.register(UINib(nibName: "ReviewsCellXIB", bundle: nil), forCellReuseIdentifier: "ReviewsCellXIB")
        
        self.TblviewDetail.register(ProductDetailDeliveryDetailsXIB.self, forCellReuseIdentifier: "ProductDetailDeliveryDetailsXIB")
        self.TblviewDetail.register(UINib(nibName: "ProductDetailDeliveryDetailsXIB", bundle: nil), forCellReuseIdentifier: "ProductDetailDeliveryDetailsXIB")
        
        self.CollectionviewColor.register(UINib(nibName: "SelectColorCellXIB", bundle: nil), forCellWithReuseIdentifier: "SelectColorCellXIB")
        
        self.TblviewDetail.register(AddToCartButtonXIB.self, forCellReuseIdentifier: "AddToCartButtonXIB")
        self.TblviewDetail.register(UINib(nibName: "AddToCartButtonXIB", bundle: nil), forCellReuseIdentifier: "AddToCartButtonXIB")
        
        self.TblviewDetail.register(ViewMoreCellXIB.self, forCellReuseIdentifier: "ViewMoreCellXIB")
        self.TblviewDetail.register(UINib(nibName: "ViewMoreCellXIB", bundle: nil), forCellReuseIdentifier: "ViewMoreCellXIB")
        
        self.TblviewDetail.register(DeliveryDetailCellXIB.self, forCellReuseIdentifier: "DeliveryDetailCellXIB")
        self.TblviewDetail.register(UINib(nibName: "DeliveryDetailCellXIB", bundle: nil), forCellReuseIdentifier: "DeliveryDetailCellXIB")
        
        
        self.TblviewDetail.register(DeliveryDetailCellXIB.self, forCellReuseIdentifier: "DeliveryDetailCellXIB")
        self.TblviewDetail.register(UINib(nibName: "DeliveryDetailCellXIB", bundle: nil), forCellReuseIdentifier: "DeliveryDetailCellXIB")
        
        
        
        self.TblviewDetail.isHidden = true
        
        self.viewBottomConstaraint.constant = 0
        
        
        
        isQty = 1
        
        self.GetProductDetail()
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func sharePopUp(sharingItems: [Any]) {
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activityType, isSuccess, arrAny, error) in
            
            
        }
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func ShareDetails(sender:UIButton)
    {
        
        
        var link = URL(string: "https://shopping.nexshop.com/?product_id=\(self.product_id)")
        var dynamicLinksDomainURIPrefix = "https://nexshop.page.link"
        
        //https://grocery.cellula.com/?product_id=$product_id"
        
        
        if let linkBuilder = DynamicLinkComponents(link: link!, domainURIPrefix: dynamicLinksDomainURIPrefix) {
            
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.NexshopCustomer.Zb")
            linkBuilder.iOSParameters?.fallbackURL = URL(string: "www.google.com")
            
            
            linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.nexshop")
            linkBuilder.androidParameters?.fallbackURL = URL(string: "www.google.com")
            
            linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            
            linkBuilder.socialMetaTagParameters!.title = (self.ProductDetailDict.value(forKey: "name") as! String)
            linkBuilder.socialMetaTagParameters!.imageURL = URL(string: self.ProductDetailDict.value(forKey: "thumbnail_img") as! String)
            
            
            linkBuilder.shorten() { url, warnings, error in
                guard let url = url, error == nil else { return }
                print("The short URL is: \(url)")
                
                self.sharePopUp(sharingItems: [url])
            }
            
            //        guard let longDynamicLink = linkBuilder.url else { return }
            //        print("The long URL is: \(longDynamicLink)")
            //        }
        }
    }
    
    @objc func SellerChatDetails(sender:UIButton)
    {
        print(self.ProductDetailDict)
        
        let Seller = self.ProductDetailDict.value(forKey: "seller") as! NSDictionary
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailVC")  as! ChatDetailVC
        Push.ToUserID = Int(Seller.value(forKey: "user_id") as! String)!
       Push.OtherUserName = Seller.value(forKey: "shop_name") as! String
//        Push.RecieverImageUrl = data.created_user_data!.avatar!
        Push.Product_id = "\(self.product_id)"
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
    @objc func SelectDeliveryAddress(sender:UIButton)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
        Push.isFromPush = true
        Push.selected_address_id = isFirstAddressid
        Push.UpadteAddresswithLocationDelegate = self
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    
    @objc func AddCartFtn(sender:UIButton)
    {
        appDelegate.ShowProgess()
        
        var arrParam = [[String:String]]()
        arrParam.append(["type":"products","module":"shopping","product_id":"\(self.product_id)","qty":"\(self.isQty)"])
        var param = addSelectedParameters(param: arrParam)
        
        print(param)
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.add_item_to_cart)!, params: param, finish: self.AddedToCartWebserviceCall)
    }
    
    @objc func BuyNowFtn(sender:UIButton)
    {
        self.isToBuyNow = true
        
        appDelegate.ShowProgess()
        
        var arrParam = [[String:String]]()
        arrParam.append(["type":"products","module":"shopping","product_id":"\(self.product_id)","qty":"\(self.isQty)"])
        var param = addSelectedParameters(param: arrParam)
        
        print(param)
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.add_item_to_cart)!, params: param, finish: self.AddedToCartWebserviceCall)
        
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func SelectQty(sender:UIButton)
    {
        
        var SelectedOptions = [String]()
        SelectedOptions = ["1","2","3","4","5","6"]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
        {
            
            let greenAppearance = YBTextPickerAppearanceManager.init(
                pickerTitle         : "Select Quantity",
                titleFont           : self.boldFont,
                titleTextColor      : .white,
                titleBackground     : UIColor.black,
                searchBarFont       : self.regularFont,
                searchBarPlaceholder: "Select",
                closeButtonTitle    : "Cancel",
                closeButtonColor    : .darkGray,
                closeButtonFont     : self.regularFont,
                doneButtonTitle     : "Okay",
                doneButtonColor     : UIColor.black,
                doneButtonFont      : self.boldFont,
                checkMarkPosition   : .Left,
                itemCheckedImage    : UIImage(named:"green_ic_checked"),
                itemUncheckedImage  : UIImage(named:"green_ic_unchecked"),
                itemColor           : .black,
                itemFont            : self.regularFont
            )
            
            
            
            let picker = YBTextPicker.init(with: SelectedOptions , appearance: greenAppearance,
                                           onCompletion: { (selectedIndexes, selectedValues) in
                                            if selectedValues.count > 0{
                                                
                                                var values = [String]()
                                                
                                                for index in selectedIndexes{
                                                    values.append(SelectedOptions[index] as! String)
                                                    
                                                }
                                                let stringRepresentation = values[0]
                                                //
                                                
                                                print(stringRepresentation)
                                                
                                                self.isQty = Int(stringRepresentation)!
                                                self.TblviewDetail.reloadData()
                                                self.CollectionviewVariations?.reloadData()
                                                
                                                
                                            }else{
                                                
                                                
                                            }
            },
                                           onCancel:
                {
                    
                    
                    
            }
            )
            
            
            picker.allowMultipleSelection = false
            picker.show(withAnimation: .Fade)
            
        }
    }
    
    func GetProductDetail()
    {
        let apiToken = "Bearer \(appDelegate.get_user_Data(Key: "token"))"
        let headers:HTTPHeaders = ["Authorization": apiToken,"Accept":"application/json"]
        
        
        
        let url1 = "https://zestbrains.techboundary.xyz/public/api/v1/app/get_product_detail/" + "\(self.product_id)"
        print(url1)
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
            
        }
        
        appDelegate.ShowProgess()
        
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
                    
                    
                    self.DataSet.removeAll()
                    
                    self.ProductDetailDict = ProductData.mutableCopy() as! NSMutableDictionary
                    
                    let options = (self.ProductDetailDict.value(forKey: "variations") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    self.imgArray = self.ProductDetailDict.value(forKey: "gallery") as! NSArray
                    
                    
                    self.VariationsDataModel.removeAll()
                    for object in options
                    {
                        let Data_Object = VariationsModel.init(fromDictionary: object as! [String : Any])
                        self.VariationsDataModel.append(Data_Object)
                    }
                    
                    self.ColorsDataArray = [String]()
                    for object1 in self.VariationsDataModel
                    {
                        let Color1 = object1
                        
                        if Color1.name == "colors"
                        {
                            self.is_Selected_color = Color1.options[0]
                            break
                            
                        }
                        else
                        {
                            
                        }
                        
                        
                    }
                    
                    
                    self.delivery_slabs = (self.ProductDetailDict.value(forKey: "delivery_slabs") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    self.seller = (self.ProductDetailDict.value(forKey: "seller") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    self.seller_user_id = "\((self.seller.value(forKey: "user_id") as! String))"
                    
                    
                    self.related_products = (self.ProductDetailDict.value(forKey: "related_products") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    self.bought_items = (self.ProductDetailDict.value(forKey: "bought_items") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    self.reviews = (self.ProductDetailDict.value(forKey: "reviews") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    self.review_count = (self.ProductDetailDict.value(forKey: "review_count") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    self.sponsored_products = (self.ProductDetailDict.value(forKey: "sponsored_products") as! NSArray).mutableCopy() as! NSMutableArray
                    
                    print(self.ProductDetailDict)
                    
                    
                    self.is_wishlisted = (self.ProductDetailDict.value(forKey: "is_wishlisted") as! Int)
                    self.wishlist_item_id = (self.ProductDetailDict.value(forKey: "wishlist_item_id") as! Int)
                    
                    self.discount = Float((self.ProductDetailDict.value(forKey: "discount") as! NSNumber))
                    self.discount_type = (self.ProductDetailDict.value(forKey: "discount_type") as! String)
                    self.price = Float(self.ProductDetailDict.value(forKey: "price") as! NSNumber)
                    
                    
                    // self.product_quantity = (self.ProductDetailDict.value(forKey: "product_quantity") as! String)
                    self.product_status = (self.ProductDetailDict.value(forKey: "product_status") as! String)
                    self.unit_price = Float((self.ProductDetailDict.value(forKey: "unit_price") as! NSNumber)) as! Float
                    
                    if self.product_status == "Out of stock"
                    {
                        self.viewBottomConstaraint.constant = 0
                        self.viewBottom.isHidden = true
                        
                    }
                    else
                    {
                        self.viewBottomConstaraint.constant = 0
                        self.viewBottom.isHidden = true
                        
                    }
                    
                    self.DataSet.append("Header_image")
                    self.DataSet.append("image_slider")
                    self.DataSet.append("price_Detail")
                    
                    if self.VariationsDataModel.count > 0
                    {
                        self.DataSet.append("variations")
                    }
                    
                    self.DataSet.append("product_Detail")
                    
                    if self.reviews.count > 0
                    {
                        self.DataSet.append("review_list")
                        self.DataSet.append("review_more")
                        
                    }
                    
                    self.DataSet.append("delivery_detail")
                    
                    self.DataSet.append("delivery_data")
                    
                    if self.product_status != "Out of stock"
                    {
                        
                        self.DataSet.append("add_cart_data")
                        
                    }
                    
                    
                    
                    print(self.DataSet.count)
                    print(self.DataSet)
                    
                    
                    let Paramteres = ["":""]
                    
                    APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_addresses)!, params: Paramteres, finish: self.GetAddressWebService)
                    
                    
                    
                    
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
    
    func GetAddressWebService (message:String, data:Data?) -> Void
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
                                    
                                }
                                    
                                else
                                {
                                    self.isfirstAddress = String()
                                    self.isFirstAddressid = String()
                                    
                                }
                                
                                self.TblviewDetail.reloadData()
                                
                                let indexPath = NSIndexPath(row: 0, section: 0)
                                self.TblviewDetail.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                                
                                self.TblviewDetail.isHidden = false
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute:
                                {
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
    
    @objc func GetVariantsPrice()
    {
        appDelegate.ShowProgess()
        var arrParam = [[String:String]]()
        arrParam.append(["product_id":self.product_id])
        var param = addSelectedParameters(param: arrParam)
        print(param)
        
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_product_variant_price)!, params: param, finish: self.GetProductsWebserviceCall)
    }
    
    func addSelectedParameters(param: [[String:Any]]) -> [String:Any] {
        var arrParam = param
        for obj1 in self.VariationsDataModel
        {
            let keystring = obj1.name!
            let tempParam = [keystring: "\(obj1.options[obj1.isSelectedindex])"]
            arrParam.append(tempParam)
        }
        
        var param = arrParam.flatMap { $0 }.reduce([:]) { $0.merging($1) { (current, _) in current } }
        return param
    }
    
    @objc func GetVariations(sender:UIButton)
    {
        
        if self.VariationsDataModel[sender.tag].name == "colors"
        {
            self.ColorsDataArray = [String]()
            for object1 in self.VariationsDataModel[sender.tag].options
            {
                let Color1 = object1
                
                self.ColorsDataArray.append(Color1)
            }
            self.CollectionviewColor.reloadData()
            self.viewColorSubview.frame = self.view.frame
            self.view.addSubview(self.viewColorSubview)
        }
        else
        {
            
            var SelectedOptions = [String]()
            SelectedOptions = self.VariationsDataModel[sender.tag].options
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
            {
                
                let greenAppearance = YBTextPickerAppearanceManager.init(
                    pickerTitle         : "Select",
                    titleFont           : self.boldFont,
                    titleTextColor      : .white,
                    titleBackground     : UIColor.black,
                    searchBarFont       : self.regularFont,
                    searchBarPlaceholder: "Select",
                    closeButtonTitle    : "Cancel",
                    closeButtonColor    : .darkGray,
                    closeButtonFont     : self.regularFont,
                    doneButtonTitle     : "Okay",
                    doneButtonColor     : UIColor.black,
                    doneButtonFont      : self.boldFont,
                    checkMarkPosition   : .Left,
                    itemCheckedImage    : UIImage(named:"green_ic_checked"),
                    itemUncheckedImage  : UIImage(named:"green_ic_unchecked"),
                    itemColor           : .black,
                    itemFont            : self.regularFont
                )
                
                
                
                let picker = YBTextPicker.init(with: SelectedOptions , appearance: greenAppearance,
                                               onCompletion: { (selectedIndexes, selectedValues) in
                                                if selectedValues.count > 0{
                                                    
                                                    var values = [String]()
                                                    
                                                    for index in selectedIndexes{
                                                        values.append(SelectedOptions[index] as! String)
                                                        
                                                    }
                                                    self.VariationsDataModel[sender.tag].isSelectedindex = selectedIndexes.first!
                                                    
                                                    let stringRepresentation = values[0]
                                                    //
                                                    
                                                    self.GetVariantsPrice()
                                                    
                                                }else{
                                                    
                                                    
                                                }
                },
                                               onCancel:
                    {
                        
                        
                        
                }
                )
                
                
                picker.allowMultipleSelection = false
                picker.show(withAnimation: .Fade)
                
            }
        }
    }
    
    func GetProductsWebserviceCall (message:String, data:Data?) -> Void
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
                                
                                
                                
                                let data1 = dict["data"].dictionaryObject as! NSDictionary
                                
                                self.delivery_slabs = ((data1.value(forKey: "delivery_slabs") as! NSDictionary)).mutableCopy() as! NSMutableDictionary
                                self.discount = Float(((data1.value(forKey: "discount") as! NSNumber)))
                                self.discount_type = (data1.value(forKey: "discount_type") as! String)
                                self.wishlist_item_id = (data1.value(forKey: "wishlist_item_id") as! Int)
                                self.price = Float((data1.value(forKey: "price") as! NSNumber)) as! Float
                                //  self.product_quantity = (data1.value(forKey: "product_quantity") as! String)
                                self.product_status = (data1.value(forKey: "product_status") as! String)
                                
                                self.unit_price = Float((data1.value(forKey: "unit_price") as! NSNumber)) as! Float
                                
                                print(data1)
                                
                                self.is_wishlisted = (data1.value(forKey: "is_wishlisted") as! Int)
                                
                                
                                self.wishlist_item_id = (data1.value(forKey: "wishlist_item_id") as! Int)
                                
                                if self.DataSet.contains("add_cart_data")
                                {
                                    self.DataSet.removeAll { $0 == "add_cart_data" }

                                }
                                
                                if self.product_status == "Out of stock"
                                {
                                    
                                }
                                else
                                {
                                    self.DataSet.append("add_cart_data")

                                }
                                
                                self.TblviewDetail.reloadData()
                                let indexPath = NSIndexPath(row: 0, section: 0)
                                self.TblviewDetail.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                                
                                self.CollectionviewVariations?.reloadData()
                                self.viewColorSubview.removeFromSuperview()
                                appDelegate.HideProgress()
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
    
    @objc func FavouriteUnFavourite(sender:UIButton)
    {
        if self.is_wishlisted == 0
        {
            var arrParam = [[String:String]]()
            arrParam.append(["id":self.product_id,"type":"products","module":"shopping",])
            var param = addSelectedParameters(param: arrParam)
            
            appDelegate.ShowProgess()
            APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.manage_wishlist)!, params: param, finish: self.GetWishListed)
            
        }
        else
        {
            let Paramteres = ["item_id":self.wishlist_item_id]
            
            
            
            appDelegate.ShowProgess()
            APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.remove_from_wishlist)!, params: Paramteres, finish: self.RemoveWishListed)
            
            
        }
        
    }
    
    func RemoveWishListed (message:String, data:Data?) -> Void
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
                                
                                DispatchQueue.main.async
                                    {
                                        
                                        
                                        Loaf(dict["message"].string!, state: .success, sender: self).show()
                                        self.is_wishlisted = 0
                                        self.TblviewDetail.reloadData()
                                        appDelegate.HideProgress()
                                }
                                
                                
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
    
    func GetWishListed (message:String, data:Data?) -> Void
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
                                
                                DispatchQueue.main.async
                                    {
                                        
                                        
                                        Loaf(dict["message"].string!, state: .success, sender: self).show()
                                        self.is_wishlisted = 1
                                        self.TblviewDetail.reloadData()
                                        appDelegate.HideProgress()
                                        
                                        
                                }
                                
                                
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
    
    @objc func GetAllreviews(sender:UIButton)
    {
        let push = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllReviewsVC") as! ViewAllReviewsVC
        push.reviews = self.reviews.mutableCopy() as! NSMutableArray
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func GetColorData(sender:UIButton)
    {
        self.CollectionviewColor.reloadData()
        self.viewColorSubview.frame = self.view.frame
        self.view.addSubview(self.viewColorSubview)
    }
    
    func AddedToCartWebserviceCall (message:String, data:Data?) -> Void
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
                                
                                appDelegate.HideProgress()
                                
                                
                                
                                if self.isToBuyNow == true
                                {
                                    self.isToBuyNow = false
                                    self.setView(view: self.viewCartAdded, hidden: true)
                                    appDelegate.SetCartRoot()
                                }
                                else
                                {
                                    
                                    Loaf("Product added to cart", state: .success, sender: self).show()
                                    self.setView(view: self.viewCartAdded, hidden: false)
                                }
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)
                                {
                                    
                                    self.setView(view: self.viewCartAdded, hidden: true)
                                    
                                    
                                }
                                
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
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnHandlerAddToCart(_ sender: Any) {
        appDelegate.ShowProgess()
        
        var arrParam = [[String:String]]()
        arrParam.append(["type":"products","module":"shopping","product_id":"\(self.product_id)","qty":"\(self.isQty)"])
        var param = addSelectedParameters(param: arrParam)
        
        print(param)
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.add_item_to_cart)!, params: param, finish: self.AddedToCartWebserviceCall)
        
    }
    
    
    @IBAction func btnHandlerBuyNow(_ sender: Any)
    {
        self.isToBuyNow = true
        
        appDelegate.ShowProgess()
        
        var arrParam = [[String:String]]()
        arrParam.append(["type":"products","module":"shopping","product_id":"\(self.product_id)","qty":"\(self.isQty)"])
        var param = addSelectedParameters(param: arrParam)
        
        print(param)
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.add_item_to_cart)!, params: param, finish: self.AddedToCartWebserviceCall)
    }
    
    @IBAction func btnHandlerSearch(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.setView(view: self.viewCartAdded, hidden: true)
        
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.setView(view: self.viewCartAdded, hidden: true)
        if self.isFromShare == "1"
        {
            appDelegate.SetHomeRoot()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)

        }
        
        
    }
    
    @IBAction func btnHandlerOkay(_ sender: Any)
    {
        self.GetVariantsPrice()
    }
    
    @IBAction func btnHandlerCancel(_ sender: Any)
    {
        self.viewColorSubview.removeFromSuperview()
        
    }
    
    
}

//MARK:- TABLEVIEW METHODS


extension ProductDetailVC:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.DataSet.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.ProductDetailDict.count == 0
        {
            return UITableViewCell()
        }
        else
        {
            
            if self.DataSet[indexPath.section] == "Header_image"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "ProductDetailHeaderCellXIB") as! ProductDetailHeaderCellXIB
                
                cell.btnHandlerShare.addTarget(self, action: #selector(self.ShareDetails(sender:)), for: .touchUpInside)
                
                
                cell.lblProductName.text = "\(self.ProductDetailDict.value(forKey: "name") as! String)"
                
                if self.is_wishlisted == 0
                {
                    cell.imgviewRed.image = UIImage(named: "ic_grey_heart")
                }
                else
                {
                    cell.imgviewRed.image = UIImage(named: "ic_red_heart")
                }
                
                print(self.imgArray)
                print(self.imageSelectedIndex)
                
                print(self.imgArray)
                
                if self.imgArray.count > 0
                {
                        cell.imgviewProduct.kf.indicatorType = .activity
                        cell.imgviewProduct.kf.setImage(with: URL(string: (self.imgArray.object(at: self.imageSelectedIndex) as! NSDictionary).value(forKey: "file") as! String))
                }
                
                
                
                cell.btnHandlerRed.tag = indexPath.row
                cell.btnHandlerRed.addTarget(self, action: #selector(self.FavouriteUnFavourite(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                
                
                
                return cell
            }
            
            if self.DataSet[indexPath.section] == "image_slider"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "ImageSliderTableCell") as! ImageSliderTableCell
                
                cell.CollectionviewSlider.delegate = self
                cell.CollectionviewSlider.dataSource = self
                self.CollectionviewImage = cell.CollectionviewSlider
                
                cell.selectionStyle = .none
                
                return cell
            }
            
            if self.DataSet[indexPath.section] == "price_Detail"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "ProductDetailHeaderPriceCellXIB") as! ProductDetailHeaderPriceCellXIB
                
                let total_reviews = self.ProductDetailDict.value(forKey: "total_reviews") as! Int
                let avg_review = self.ProductDetailDict.value(forKey: "avg_review") as! NSNumber
                
                
                cell.RatingsBar.settings.fillMode = .half
                
                cell.RatingsBar.rating = Double(avg_review)
                cell.RatingsBar.settings.filledImage = UIImage(named: "ic_yellow_single_Star")
                cell.RatingsBar.settings.emptyImage = UIImage(named: "ic_Star_grey_unfilled")
                
                cell.RatingsBar.isUserInteractionEnabled = false
                
                let x = Double(avg_review).rounded(toPlaces: 1)
                
                cell.lblTotalRatings.text = "\(x)" + " ( " + "\(total_reviews)" + " Reviews ) "
                cell.lblAvgRatings.text = "\(x)"
                
                if "\(self.unit_price)" == "\(self.price)"
                {
                    cell.lblOff.text = ""
                    cell.lblStrike.text = ""
                }
                else
                {
                    let unitPrice = "₹ " + "\(self.unit_price)"
                    
                    let attributeString =  NSMutableAttributedString(string: unitPrice)
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                                 value: NSUnderlineStyle.single.rawValue,
                                                 range: NSMakeRange(0, attributeString.length))
                    cell.lblStrike.attributedText = attributeString
                    let Offer = self.discount
                    
                    let x = Double(Offer).rounded(toPlaces: 0)
                    
                    let Y = Int(x)
                    cell.lblOff.text = "\(Y)" + "% off"
                }
                
                cell.lblinStock.text = "\(self.product_status)"
                
                if self.product_status == "Out of stock"
                {
                    cell.lblinStock.textColor = UIColor.red
                }
                else
                {
                    cell.lblinStock.textColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "02911C")
                }
                
                cell.lblPrice.text = "₹ " + "\(self.price)"
                
                
                cell.lQTY.text = "QTY: " + "\(self.isQty)"
                cell.btnTitleQTY.addTarget(self, action: #selector(self.SelectQty(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                
                return cell
            }
            
            if self.DataSet[indexPath.section] == "variations"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "ProductVariations") as! ProductVariations
                
                cell.CollectionviewVariations.delegate = self
                cell.CollectionviewVariations.dataSource = self
                self.CollectionviewVariations = cell.CollectionviewVariations
                
                cell.selectionStyle = .none
                
                return cell
            }
            
            if self.DataSet[indexPath.section] == "product_Detail"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "ProductDetailAboutXIB") as! ProductDetailAboutXIB
                
                if self.ProductDetailDict.count > 0
                {
                    
                    let x2 = Double("\(self.ProductDetailDict.value(forKey: "avg_review") as! Float)")!.rounded(toPlaces: 1)
                    
                    cell.lblAvgRatings.text = "\(x2)"
                    
                    
                    cell.lblTotalRatings.text = "( " + "\(self.ProductDetailDict.value(forKey: "total_reviews") as! Int)"
                        + " Total Ratings )"
                    
                    cell.FiveRatings.text = "\(self.review_count.value(forKey: "5") as! Int)"
                    cell.FourRatings.text = "\(self.review_count.value(forKey: "4") as! Int)"
                    cell.ThreePoints.text = "\(self.review_count.value(forKey: "3") as! Int)"
                    cell.TwoRatings.text = "\(self.review_count.value(forKey: "2") as! Int)"
                    cell.lblPOits.text = "\(self.review_count.value(forKey: "1") as! Int)"
                    
                    let total_reviews = Float(self.ProductDetailDict.value(forKey: "total_reviews") as! Float)
                    
                    if total_reviews == 0
                    {
                        cell.FiveProgress.progress = 0
                        cell.FourProgress.progress = 0
                        cell.ThreeRatings.progress = 0
                        cell.TwoProgress.progress = 0
                        cell.viewRatings.progress = 0
                    }
                    else
                    {
                        cell.viewRatings.progress = ((100 * Float(((self.ProductDetailDict.value(forKey: "review_count") as! NSDictionary).value(forKey: "1") as! Float))) / total_reviews) / 100
                        
                        cell.TwoProgress.progress = ((100 * Float(((self.ProductDetailDict.value(forKey: "review_count") as! NSDictionary).value(forKey: "2") as! Float))) / total_reviews) / 100
                        
                        cell.ThreeRatings.progress = ((100 * Float(((self.ProductDetailDict.value(forKey: "review_count") as! NSDictionary).value(forKey: "3") as! Float))) / total_reviews) / 100
                        
                        cell.FourProgress.progress = ((100 * Float(((self.ProductDetailDict.value(forKey: "review_count") as! NSDictionary).value(forKey: "4") as! Float))) / total_reviews) / 100
                        
                        cell.FiveProgress.progress = ((100 * Float(((self.ProductDetailDict.value(forKey: "review_count") as! NSDictionary).value(forKey: "5") as! Float))) / total_reviews) / 100
                    }
                    
                    
                    let description = self.ProductDetailDict.value(forKey: "description") as! String
                    
                    if description.withoutHtml.isEmpty == true
                    {
                        cell.LblProductDetail.text = ""
                    }
                    else
                    {
                        cell.LblProductDetail.attributedText = description.html2AttributedString
                        
                    }
                    
                }
                
                cell.selectionStyle = .none
                
                return cell
            }
            
            if self.DataSet[indexPath.section] == "review_list"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "ReviewsCellXIB") as! ReviewsCellXIB
                let ReviewDict = (self.reviews.object(at: indexPath.row) as! NSDictionary)
                cell.lblName.text = ((ReviewDict.value(forKey: "user") as! NSDictionary).value(forKey: "name") as! String)
                cell.lblTime.text = "On " +  "\(ReviewDict.value(forKey: "date") as! String)"
                cell.lblAvgRatings.text = "\(Float((ReviewDict.value(forKey: "rating") as! String))!)"
                cell.lblProductReview.text = (ReviewDict.value(forKey: "comment") as! String)
                cell.selectionStyle = .none
                
                return cell
            }
            
            if self.DataSet[indexPath.section] == "review_more"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "ViewMoreCellXIB") as! ViewMoreCellXIB
                
                cell.btnTitleViewMore.addTarget(self, action: #selector(self.GetAllreviews(sender:)), for: .touchUpInside)
                
                
                return cell
            }
            if self.DataSet[indexPath.section] == "delivery_detail"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "ProductDetailDeliveryDetailsXIB") as! ProductDetailDeliveryDetailsXIB
                
                if self.isfirstAddress.isEmpty == true
                {
                    cell.lblAddress.text = "Select the address"
                    cell.btnTitleChange.setTitle("Select", for: .normal)
                }
                else
                {
                    cell.lblAddress.text = "\(self.isfirstAddress)"
                    cell.btnTitleChange.setTitle("Change", for: .normal)
                }
                
                cell.btnTitleChange.addTarget(self, action: #selector(self.SelectDeliveryAddress(sender:)), for: .touchUpInside)
                
                cell.selectionStyle = .none
                
                return cell
            }
            
            
            if self.DataSet[indexPath.section] == "delivery_data"
            {
                //
                
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "DeliveryDetailCellXIB") as! DeliveryDetailCellXIB
                               
                               
                               cell.btnTitleChat.addTarget(self, action: #selector(self.SellerChatDetails(sender:)), for: .touchUpInside)
                               
                               cell.selectionStyle = .none
                               
                               return cell
                
            }
            
            if self.DataSet[indexPath.section] == "add_cart_data"
            {
                let cell = self.TblviewDetail.dequeueReusableCell(withIdentifier: "AddToCartButtonXIB") as! AddToCartButtonXIB
                
                DispatchQueue.main.async {
                    cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.16, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 0)
                }
                
                
                cell.btnTitleBuy.addTarget(self, action: #selector(self.BuyNowFtn(sender:)), for: .touchUpInside)
                cell.btnTitleAddToCart.addTarget(self, action: #selector(self.AddCartFtn(sender:)), for: .touchUpInside)
                
                
                cell.selectionStyle = .none
                
                return cell
            }
                
            else
            {
                return UITableViewCell()
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.DataSet[indexPath.section] == "Header_image"
        {
            return 375
        }
        if self.DataSet[indexPath.section] == "image_slider"
        {
            return 75
        }
        if self.DataSet[indexPath.section] == "price_Detail"
        {
            return 110
        }
        if self.DataSet[indexPath.section] == "variations"
        {
            return 65
        }
        if self.DataSet[indexPath.section] == "product_Detail"
        {
            return UITableView.automaticDimension
        }
        if self.DataSet[indexPath.section] == "review_list"
        {
            return UITableView.automaticDimension
        }
        if self.DataSet[indexPath.section] == "review_more"
        {
            return 50
        }
        if self.DataSet[indexPath.section] == "delivery_detail"
        {
            return UITableView.automaticDimension
        }
        else if self.DataSet[indexPath.section] == "add_cart_data"
        {
            return 40
        }
        else if self.DataSet[indexPath.section] == "delivery_data"
        {
            return UITableView.automaticDimension
        }
        else if indexPath.section == 6
        {
            return 125
        }
        else
        {
            return 45
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}


extension ProductDetailVC:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.CollectionviewImage
        {
            return self.imgArray.count
        }
        else if collectionView == self.CollectionviewVariations
        {
            if self.VariationsDataModel.count > 0
            {
                return self.VariationsDataModel.count
            }
            else
            {
                return 0
            }
            
        }
        else
        {
              if self.ColorsDataArray.count > 0
                      {
                          return self.ColorsDataArray.count
                      }
                      else
                      {
                          return 0
                      }
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.CollectionviewImage
        {
            let cell = self.CollectionviewImage!.dequeueReusableCell(withReuseIdentifier: "ImageSliderCollectionCell", for: indexPath) as? ImageSliderCollectionCell
            
            if self.imgArray.count > 0
            {
                
                if self.imageSelectedIndex == indexPath.row
                {
                    cell?.imgviewPic.layer.borderColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "FFAD27").cgColor
                    cell?.imgviewPic.layer.borderWidth = 2.0
                }
                else
                {
                    cell?.imgviewPic.layer.borderColor = UIColor.white.cgColor
                    cell?.imgviewPic.layer.borderWidth = 0.0
                }
                
                cell?.imgviewPic.kf.indicatorType = .activity
                cell?.imgviewPic.kf.setImage(with: URL(string: (self.imgArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "file") as! String))
                
            }
            return cell!
        }
        else if collectionView == self.CollectionviewVariations
        {
            let cell = self.CollectionviewVariations!.dequeueReusableCell(withReuseIdentifier: "ProductVaritionsCollectionCell", for: indexPath) as? ProductVaritionsCollectionCell
            
            
            if self.VariationsDataModel.count == 0
            {
                return UICollectionViewCell()
            }
            else
            {
                let cell = self.CollectionviewVariations?.dequeueReusableCell(withReuseIdentifier: "ProductVaritionsCollectionCell", for: indexPath) as? ProductVaritionsCollectionCell
                
                if self.VariationsDataModel.count > 0
                {
                    cell?.lblVariations.text = self.VariationsDataModel[indexPath.row].title + " : "
                    
                    if self.VariationsDataModel[indexPath.row].name == "colors"
                    {
                        colorIndex = indexPath.item
                        let Color =
                        "\(self.VariationsDataModel[indexPath.row].options[self.VariationsDataModel[indexPath.row].isSelectedindex])"
                        cell?.lblValue.textColor = UIColor(hexString: Color)// CommonClass.sharedInstance.getColorIntoHex(Hex: Color)
                        cell?.lblValue.text = "Hiii"
                        cell?.lblValue.backgroundColor = UIColor(hexString: Color)
                        
                        
                    }
                    else
                    {
                        
                        cell?.lblValue.backgroundColor = UIColor.white
                        
                        cell?.lblValue.textColor = UIColor.black
                        cell?.lblValue.text = "\(self.VariationsDataModel[indexPath.row].options[self.VariationsDataModel[indexPath.row].isSelectedindex])"
                        
                        
                    }
                    
                    cell?.btnTitleVariant.tag = indexPath.row
                    cell?.btnTitleVariant.addTarget(self, action: #selector(self.GetVariations(sender:)), for: .touchUpInside)
                    
                    
                    
                    
                    
                }
                
                return cell!
            }
            
            
        }
        else
        {
            let cell = self.CollectionviewColor!.dequeueReusableCell(withReuseIdentifier: "SelectColorCellXIB", for: indexPath) as? SelectColorCellXIB
            
            if self.ColorsDataArray.count > 0
            {
                
                
                var Color = self.ColorsDataArray[indexPath.row]
                
                
                
                if self.is_Selected_color == Color
                {
                    cell?.imgviewSelect.isHidden = false
                }
                else
                {
                    cell?.imgviewSelect.isHidden = true
                }
                
                Color.remove(at: Color.startIndex)
                
                
                CommonClass .sharedInstance.setShadow(obj: cell?.viewBackground!
                    , cornurRadius: 25.0, ClipToBound: true, masksToBounds: false, shadowColor: "D3D3D3", shadowOpacity: 0.9, shadowOffset: .zero, shadowRadius: 5, shouldRasterize: false, shadowPath: (cell?.viewBackground.bounds)!)
                
                cell?.viewBackground.backgroundColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "\(Color)")
                
                return cell!
            }
            else
            {
                return cell!
                
            }
            
            
        }
        
        
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.CollectionviewImage
        {
            return CGSize(width: 75 , height: 75 )
        }
        else if collectionView == self.CollectionviewColor
        {
            return CGSize(width: 60 , height: 60 )
        }
        else
        {
            if self.VariationsDataModel[indexPath.row].name == "colors"
            {
                return CGSize(width: 125, height: 50 )
                
            }
            else
            {
                
                //                if self.VariationsDataModel[indexPath.row].isSelectedindex == 0
                //                {
                
                print("\(self.VariationsDataModel[indexPath.row].options[self.VariationsDataModel[indexPath.row].isSelectedindex])")
                
                
                let value = "\(self.VariationsDataModel[indexPath.row].options[self.VariationsDataModel[indexPath.row].isSelectedindex])"
                let item = self.VariationsDataModel[indexPath.row].title + " : "
                let itemSize = item.size(withAttributes: [
                    NSAttributedString.Key.font : UIFont(name: "Metropolis-Regular", size: 13.0)!
                ])
                let ValueSize = value.size(withAttributes: [
                    NSAttributedString.Key.font : UIFont(name: "Metropolis-Regular", size: 13.0)!
                ])
                let Width1 = itemSize.width + ValueSize.width
                
                return CGSize(width: Width1 + 55, height: 50)
                
                
                
            }
            
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if  collectionView == self.CollectionviewImage
        {
            self.imageSelectedIndex = indexPath.row
            self.TblviewDetail.reloadData()
            self.CollectionviewImage?.reloadData()
        }
        else if collectionView == self.CollectionviewVariations
        {
            
        }
        else
        {
            self.is_Selected_color = String()
            var Color = "\(self.ColorsDataArray[indexPath.row])"
            self.VariationsDataModel[colorIndex].isSelectedindex = indexPath.row
            self.is_Selected_color = Color
            self.CollectionviewColor.reloadData()
            self.CollectionviewVariations!.reloadData()
        }
    }
    
    
    
}

extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}


extension String {
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: .utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType:NSMutableAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    
}

extension ProductDetailVC : UpdateAddresswithLocation
{
    func UpdateAddresswithLocation(isAddressId: String, isAddress: String, Name: String, City: String, State: String, ZipCode: String, latitude: String, longitude: String, selectedAddModel: GetAddressModel?) {
        
        
        self.isFirstAddressid = "\(isAddressId)"
        self.isfirstAddress = "\(Name)" + " , " + "\(City)" + " , " +  "\(ZipCode)"
        self.TblviewDetail.reloadData()
        
        
    }
    
}
