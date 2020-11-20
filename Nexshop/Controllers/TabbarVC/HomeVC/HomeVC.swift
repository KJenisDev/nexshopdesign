//
//  HomeVC.swift
//  Nexshop
//
//  Created by Mac on 01/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import AZTabBar
import SwiftyJSON
import Loaf
import Alamofire
import Kingfisher


class HomeVC: UIViewController{
    
    
    //MARK:- VARIABLES
    
    var DataSet = [String]()
    var CategoriesDisplayModel = [CategoriesModel]()
    var RecommandationForYouDisplayModel = [TodaysDeal]()
    var BanneraftertodaydealDisplayModel = [BanneraftertoppickModel]()
    var BannerSecondModel = [BanneraftertoppickModel]()
    var ToppicksDisplayModel = [TodaysDeal]()
    var InspiredWishListModel = [TodaysDeal]()
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var CollectionviewHome: UICollectionView!
    
    
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            if appDelegate.DeviceToken.isEmpty == false
            {
                self.AddDeviceToken()
            }
            
            
        }
    }
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- ALL FUNCTIONS
    
    @objc func BannerAfterTopPickbtn(sender:UIButton)
       {
           if self.BanneraftertodaydealDisplayModel[0].clickType == "category"
           {
               let Push = mainStoryboard.instantiateViewController(withIdentifier: "ProductListingVC") as! ProductListingVC
               Push.Headername = ""
            Push.Categoryid = "\(self.BanneraftertodaydealDisplayModel[0].clickObjectId!)"
               self.navigationController?.pushViewController(Push, animated: true)
           }
           else
           {
               let Push = mainStoryboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
               Push.product_id = "\(self.BanneraftertodaydealDisplayModel[0].clickObjectId!)"
               Push.type = "shopping"
               self.navigationController?.pushViewController(Push, animated: true)
           }
       }
    
    @objc func BannerAfterrRecommandeed(sender:UIButton)
       {
           if self.BannerSecondModel[0].clickType == "category"
           {
               let Push = mainStoryboard.instantiateViewController(withIdentifier: "ProductListingVC") as! ProductListingVC
               Push.Headername = ""
               Push.Categoryid = "\(self.BannerSecondModel[0].clickObjectId!)"
               
               self.navigationController?.pushViewController(Push, animated: true)
           }
           else
           {
               let Push = mainStoryboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
               Push.product_id = "\(self.BannerSecondModel[0].clickObjectId!)"
               
               self.navigationController?.pushViewController(Push, animated: true)
           }
       }
    
    func AddDeviceToken() {
        let apiToken = "Bearer \(appDelegate.get_user_Data(Key: "token"))"
        let headers = ["Authorization": apiToken,"Accept":"application/json"]
        
        var UrlPass = String()
        UrlPass = WebURL.addDevice
        print(appDelegate.DeviceToken)
        
        
        let Paramteres = ["push_token":appDelegate.DeviceToken,"device_id":appDelegate.DeviceId,"type":"ios"]
        //        print(Paramteres)
        
        if CommonClass.sharedInstance.isReachable() == false {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        Alamofire.request(UrlPass, method: .post, parameters: Paramteres, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            
            
            if let json = response.result.value {
                let dict: NSDictionary = (json as? NSDictionary)!
                
                print(dict)
                guard dict["status"] != nil else
                {return}
                let status = dict.value(forKey: "status") as! Int
                appDelObj.HideProgress()
                
                if status == 3 {
                    DispatchQueue.main.async {
                        
                        appDelegate.SetLoginRoot()
                        appDelObj.HideProgress()
                    }
                }
            }
        }
    }
    
    @objc func ShopWithNexshop(sender:UIButton)
    {
        if sender.tag == 3
        {
            let Push = self.storyboard?.instantiateViewController(withIdentifier: "ProductListingVC") as! ProductListingVC
            Push.TodaysDisplayModel = self.RecommandationForYouDisplayModel
            self.navigationController?.pushViewController(Push, animated: true)
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
                                
                                
                                
                                self.CategoriesDisplayModel.removeAll()
                                self.DataSet.removeAll()
                                self.RecommandationForYouDisplayModel.removeAll()
                                self.BanneraftertodaydealDisplayModel.removeAll()
                                self.BannerSecondModel.removeAll()
                                self.InspiredWishListModel.removeAll()
                                
                                let Shoppingdata = dict["data"].dictionaryObject! as NSDictionary
                                
                                let Categories = Shoppingdata.value(forKey: "categories") as! NSArray
                                if Categories.count != 0
                                {
                                    self.DataSet.append("header_view")
                                    self.DataSet.append("Shop By Category")
                                    
                                }
                                
                                for object in Categories
                                {
                                    let Data_Object = CategoriesModel.init(fromDictionary: object as! [String : Any])
                                    self.CategoriesDisplayModel.append(Data_Object)
                                    
                                }
                                
                                let recommandations_for_you = Shoppingdata.value(forKey: "recommandations_for_you") as! NSArray
                                if recommandations_for_you.count != 0
                                {
                                    self.DataSet.append("header_view")
                                    self.DataSet.append("Recommended for you")
                                    
                                }
                                
                                let banner_after_top_pick = Shoppingdata.value(forKey: "banner_after_top_pick") as! NSDictionary
                                if banner_after_top_pick.count != 0
                                {
                                    self.DataSet.append("banner_after_top_pick")
                                    
                                }
                                
                                
                                let top_picks = Shoppingdata.value(forKey: "top_picks") as! NSArray
                                
                                if top_picks.count != 0
                                {
                                    self.DataSet.append("header_view")
                                    self.DataSet.append("Top Picks for You")
                                    
                                }
                                
                                print(banner_after_top_pick)
                                
                                
                                let cate_objec = BanneraftertoppickModel.init(fromDictionary: banner_after_top_pick as! [String : Any] )
                                self.BanneraftertodaydealDisplayModel.append(cate_objec)
                                
                                for object in top_picks
                                {
                                    let Data_Object = TodaysDeal.init(fromDictionary: object as! [String : Any])
                                    self.ToppicksDisplayModel.append(Data_Object)
                                }
                                
                                
                                
                                for object in recommandations_for_you
                                {
                                    let Data_Object = TodaysDeal.init(fromDictionary: object as! [String : Any])
                                    self.RecommandationForYouDisplayModel.append(Data_Object)
                                }
                                
                                let banner_after_recommandations = Shoppingdata.value(forKey: "banner_after_recommandations") as! NSDictionary
                                if banner_after_recommandations.count != 0
                                {
                                    self.DataSet.append("banner_after_recommandations")
                                    
                                    let cate_objec = BanneraftertoppickModel.init(fromDictionary: banner_after_recommandations as! [String : Any] )
                                    self.BannerSecondModel.append(cate_objec)
                                    
                                }
                                
                                let inspired_by_your_wishlist = Shoppingdata.value(forKey: "inspired_by_your_wishlist") as! NSArray
                                if inspired_by_your_wishlist.count != 0
                                {
                                    self.DataSet.append("header_view")
                                    self.DataSet.append("Inspired by Your Wish List")
                                    
                                    for object in inspired_by_your_wishlist
                                    {
                                        let Data_Object = TodaysDeal.init(fromDictionary: object as! [String : Any])
                                        self.InspiredWishListModel.append(Data_Object)
                                        
                                    }
                                    
                                }
                                
                                self.CollectionviewHome.reloadData()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:
                                    {
                                        
                                        self.CollectionviewHome.isHidden = false
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
    
    
    @objc func ShopByCategory(sender:UIButton)
    {
        if self.CategoriesDisplayModel.count > 0
        {
            let Push = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllCategoryVC") as! ViewAllCategoryVC
            Push.CategoriesDisplayModel = self.CategoriesDisplayModel
            self.navigationController?.pushViewController(Push, animated: true)
        }
        
        
    }
    
    func SetUI()
    {
        self.CollectionviewHome.isHidden = true
        
        self.CollectionviewHome.register(UINib(nibName: "HomeCategoryCellXIB", bundle: nil), forCellWithReuseIdentifier: "HomeCategoryCellXIB")
        
        self.CollectionviewHome.register(UINib(nibName: "SingleCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SingleCategoryCell")
        
        self.CollectionviewHome.register(UINib(nibName: "HomeSingleBannerCellXIB", bundle: nil), forCellWithReuseIdentifier: "HomeSingleBannerCellXIB")
        
        self.CollectionviewHome.register(UINib(nibName: "HomeSingleProductCelXIB", bundle: nil), forCellWithReuseIdentifier: "HomeSingleProductCelXIB")
        
        self.CollectionviewHome.register(UINib(nibName: "BannerDisplayCellXIB", bundle: nil), forCellWithReuseIdentifier: "BannerDisplayCellXIB")
        
        
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            appDelegate.ShowProgess()
            APIMangagerClass.callGetWithHeader(url: URL(string: WebURL.shoppinghome)!, finish: FinishSocialWebserviceCall)
            
        }
    }
    
    
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerSearch(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    
    
    @IBAction func btnHandlerSideMenu(_ sender: Any)
    {
        CommonClass.sharedInstance.openLeftSideMenu()
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    @IBAction func btnHandlerNotification(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
}



extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.DataSet.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if DataSet[section] == "Shop By Category"
        {
            return self.CategoriesDisplayModel.count > 4 ? 4 : self.CategoriesDisplayModel.count
        }
        if DataSet[section] == "Recommended for you"
        {
            return self.RecommandationForYouDisplayModel.count > 4 ? 4 : self.RecommandationForYouDisplayModel.count
        }
        if DataSet[section] == "Top Picks for You"
        {
            return self.ToppicksDisplayModel.count > 4 ? 4 : self.ToppicksDisplayModel.count
        }
        if DataSet[section] == "Inspired by Your Wish List"
        {
            return self.InspiredWishListModel.count > 4 ? 4 : self.InspiredWishListModel.count
        }
        else
        {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if DataSet[indexPath.section] == "Shop By Category"
        {
            let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "SingleCategoryCell", for: indexPath) as! SingleCategoryCell
            
            if self.CategoriesDisplayModel.count > 0
            {
                cell.imgviewCat.kf.indicatorType = .activity
                cell.imgviewCat.kf.setImage(with: URL(string: self.CategoriesDisplayModel[indexPath.row].icon))
                cell.lblCatName.text = self.CategoriesDisplayModel[indexPath.row].name!
                
                DispatchQueue.main.async {
                    cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.50, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 8)
                }
                
            }
            
            return cell
        }
            
        else if DataSet[indexPath.section] == "header_view"
        {
            print(self.DataSet[indexPath.section])
            print(self.DataSet[indexPath.section+1])
            
            
            let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCellXIB", for: indexPath) as! HomeCategoryCellXIB
            
            cell.lblHeader.text = DataSet[indexPath.section + 1]
            
            cell.viewBackground.backgroundColor = UIColor.white
            
            cell.btnTitleViewMore.isHidden = true
            
            if DataSet[indexPath.section+1] == "Shop By Category"
            {
                
                cell.btnTitleViewMore.tag = 1
                cell.btnTitleViewMore.isHidden = false
                cell.btnTitleViewMore.addTarget(self, action: #selector(self.ShopByCategory(sender:)), for: .touchUpInside)
                
                
            }
            
            if DataSet[indexPath.section + 1] == "Recommended for you"
            {
                cell.btnTitleViewMore.tag = 3
                cell.btnTitleViewMore.isHidden = false
                cell.lblHeader.text = "Shop With Nexshop"
                
                cell.btnTitleViewMore.tag = 3
                cell.btnTitleViewMore.isHidden = false
                cell.btnTitleViewMore.addTarget(self, action: #selector(self.ShopWithNexshop(sender:)), for: .touchUpInside)
                
                
            }
            
            if DataSet[indexPath.section + 1] == "Top Picks for You"
            {
                cell.btnTitleViewMore.tag = 3
                cell.btnTitleViewMore.isHidden = true
            }
            
            
            
            
            return cell
        }
            
        else if DataSet[indexPath.section] == "Recommended for you"
        {
            let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "HomeSingleProductCelXIB", for: indexPath) as! HomeSingleProductCelXIB
            
            if self.RecommandationForYouDisplayModel.count > 0
            {
                
                DispatchQueue.main.async {
                    cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 8)
                }
                
                cell.imgviewProduct.kf.indicatorType = .activity
                cell.imgviewProduct.kf.setImage(with: URL(string: self.RecommandationForYouDisplayModel[indexPath.row].thumbnailImg))
                
                
                if self.RecommandationForYouDisplayModel[indexPath.row].is_wishlisted == 1
                {
                    cell.imgviewHeart.image = UIImage(named: "ic_red_heart")
                    cell.btnTitleHeart.tag = indexPath.row
                    
                    
                }
                else
                {
                    cell.imgviewHeart.image = UIImage(named: "ic_grey_heart")
                    cell.btnTitleHeart.tag = indexPath.row
                    
                }
                
                cell.lblName.text = self.RecommandationForYouDisplayModel[indexPath.row].name!
                
                cell.lblOldPrice.text = "$ " + "\(self.RecommandationForYouDisplayModel[indexPath.row].price!)"
                
                if self.RecommandationForYouDisplayModel[indexPath.row].price == self.RecommandationForYouDisplayModel[indexPath.row].unitPrice!
                {
                    
                    cell.lblOff.text = ""
                }
                else
                {
                    
                    let Offer = Float(self.RecommandationForYouDisplayModel[indexPath.row].discount!)
                    let x = Double(Offer).rounded(toPlaces: 1)
                    var y = Int(x)
                    cell.lblOff.text = "\(y)" + "% off"
                    
                    
                }
                
                let review = Float(self.RecommandationForYouDisplayModel[indexPath.row].review!)
                let x = Double(review).rounded(toPlaces: 1)
                cell.lblRatings.text = "\(x)"
                
                
            }
            
            return cell
        }
            
        else if DataSet[indexPath.section] == "banner_after_top_pick"
        {
            let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "BannerDisplayCellXIB", for: indexPath) as! BannerDisplayCellXIB
            
            if self.BanneraftertodaydealDisplayModel.count > 0
            {
                cell.imgviewPic.contentMode = .scaleToFill
                cell.imgviewPic.clipsToBounds = true
                cell.imgviewPic.kf.indicatorType = .activity
                cell.imgviewPic.kf.setImage(with: URL(string: self.BanneraftertodaydealDisplayModel[0].file))
                
                cell.btnTitlePic.addTarget(self, action: #selector(self.BannerAfterTopPickbtn(sender:)), for: .touchUpInside)

            }
            
            return cell
        }
            
        else if DataSet[indexPath.section] == "Top Picks for You"
        {
            let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "HomeSingleProductCelXIB", for: indexPath) as! HomeSingleProductCelXIB
            
            if self.ToppicksDisplayModel.count > 0
            {
                
                DispatchQueue.main.async {
                    cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 8)
                }
                
                if self.ToppicksDisplayModel[indexPath.row].is_wishlisted == 1
                {
                    cell.imgviewHeart.image = UIImage(named: "ic_red_heart")
                    cell.btnTitleHeart.tag = indexPath.row
                    
                }
                else
                {
                    cell.imgviewHeart.image = UIImage(named: "ic_grey_heart")
                    cell.btnTitleHeart.tag = indexPath.row
                    
                }
                
                cell.imgviewProduct.kf.indicatorType = .activity
                cell.imgviewProduct.kf.setImage(with: URL(string: self.ToppicksDisplayModel[indexPath.row].thumbnailImg))
                
                cell.lblName.text = self.ToppicksDisplayModel[indexPath.row].name!
                
                cell.lblOldPrice.text = "$ " + "\(self.ToppicksDisplayModel[indexPath.row].price!)"
                
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
                cell.lblRatings.text = "\(x)"
                
                
            }
            
            return cell
        }
            
        else if DataSet[indexPath.section] == "banner_after_recommandations"
        {
            let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "BannerDisplayCellXIB", for: indexPath) as! BannerDisplayCellXIB
            
            if self.BannerSecondModel.count > 0
            {
                cell.imgviewPic.contentMode = .scaleToFill
                cell.imgviewPic.clipsToBounds = true
                cell.imgviewPic.kf.indicatorType = .activity
                cell.imgviewPic.kf.setImage(with: URL(string: self.BannerSecondModel[0].file))
                
                cell.btnTitlePic.addTarget(self, action: #selector(self.BannerAfterrRecommandeed(sender:)), for: .touchUpInside)
                
                
            }
            
            return cell
        }
            
        else if DataSet[indexPath.section] == "Inspired by Your Wish List"
        {
            let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "HomeSingleProductCelXIB", for: indexPath) as! HomeSingleProductCelXIB
            
            if self.InspiredWishListModel.count > 0
            {
                
                DispatchQueue.main.async {
                    cell.viewBackground.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.25, radius: 3, edge: AIEdge.All, shadowSpace: 3, CornerRadius: 8)
                }
                
                cell.imgviewProduct.kf.indicatorType = .activity
                cell.imgviewProduct.kf.setImage(with: URL(string: self.InspiredWishListModel[indexPath.row].thumbnailImg))
                
                if self.InspiredWishListModel[indexPath.row].is_wishlisted == 1
                {
                    cell.imgviewHeart.image = UIImage(named: "ic_red_heart")
                    cell.btnTitleHeart.tag = indexPath.row
                    
                }
                else
                {
                    cell.imgviewHeart.image = UIImage(named: "ic_grey_heart")
                    cell.btnTitleHeart.tag = indexPath.row
                    
                }
                
                cell.lblName.text = self.InspiredWishListModel[indexPath.row].name!
                
                cell.lblOldPrice.text = "$ " + "\(self.InspiredWishListModel[indexPath.row].price!)"
                
                if self.InspiredWishListModel[indexPath.row].price == self.InspiredWishListModel[indexPath.row].unitPrice!
                {
                    
                    cell.lblOff.text = ""
                }
                else
                {
                    
                    let Offer = Float(self.InspiredWishListModel[indexPath.row].discount!)
                    let x = Double(Offer).rounded(toPlaces: 1)
                    var y = Int(x)
                    cell.lblOff.text = "\(y)" + "% off"
                    
                    
                }
                
                let review = Float(self.InspiredWishListModel[indexPath.row].review!)
                let x = Double(review).rounded(toPlaces: 1)
                cell.lblRatings.text = "\(x)"
                
                
            }
            
            return cell
        }
        else
        {
            let cell = self.CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCellXIB", for: indexPath) as! HomeCategoryCellXIB
            
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if DataSet[indexPath.section] == "Shop By Category"
        {
            
            var Height1 = (self.CollectionviewHome.frame.width - 40)/4
            Height1 = Height1 + 20
            return CGSize(width: (self.CollectionviewHome.frame.width - 40)/4, height: Height1 )
            
        }
        if DataSet[indexPath.section] == "header_view"
        {
            return CGSize(width: self.CollectionviewHome.frame.width, height: 50 )
        }
        if DataSet[indexPath.section] == "Recommended for you"
        {
            var Height1 = (self.CollectionviewHome.frame.width - 5)/2
            Height1 = Height1 + 100
            return CGSize(width: (self.CollectionviewHome.frame.width - 5)/2, height: Height1 )
        }
        else if DataSet[indexPath.section] == "banner_after_top_pick"
        {
            return CGSize(width: self.CollectionviewHome.frame.width, height: 175 )
            
        }
        else if DataSet[indexPath.section] == "Top Picks for You"
        {
            var Height1 = (self.CollectionviewHome.frame.width - 5)/2
            Height1 = Height1 + 100
            return CGSize(width: (self.CollectionviewHome.frame.width - 5)/2, height: Height1 )
        }
        else if DataSet[indexPath.section] == "banner_after_recommandations"
        {
            return CGSize(width: self.CollectionviewHome.frame.width, height: 175 )
            
        }
        else if DataSet[indexPath.section] == "Inspired by Your Wish List"
        {
            var Height1 = (self.CollectionviewHome.frame.width - 5)/2
            Height1 = Height1 + 100
            return CGSize(width: (self.CollectionviewHome.frame.width - 5)/2, height: Height1 )
            
        }
            
        else
        {
            return CGSize(width: 0, height: 0 )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if DataSet[indexPath.section] == "Shop By Category"
        {
            let Push = self.storyboard!.instantiateViewController(withIdentifier: "ProductListingVC") as! ProductListingVC
            Push.Headername = self.CategoriesDisplayModel[indexPath.row].name!
            Push.Categoryid = "\(self.CategoriesDisplayModel[indexPath.row].id!)"
            
            self.navigationController?.pushViewController(Push, animated: true)
        }
        if DataSet[indexPath.section] == "Recommended for you"
        {
            let Push = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            Push.product_id = "\(self.RecommandationForYouDisplayModel[indexPath.row].id!)"
            self.navigationController?.pushViewController(Push, animated: true)
        }
        if DataSet[indexPath.section] == "banner_after_top_pick"
        {
            
        }
        if DataSet[indexPath.section] == "Top Picks for You"
        {
            let Push = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            Push.product_id = "\(self.ToppicksDisplayModel[indexPath.row].id!)"
            self.navigationController?.pushViewController(Push, animated: true)
        }
        if DataSet[indexPath.section] == "banner_after_recommandations"
        {
            
        }
        if DataSet[indexPath.section] == "Inspired by Your Wish List"
        {
            let Push = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            Push.product_id = "\(self.InspiredWishListModel[indexPath.row].id!)"
            self.navigationController?.pushViewController(Push, animated: true)
        }
        
        
    }
}



extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
