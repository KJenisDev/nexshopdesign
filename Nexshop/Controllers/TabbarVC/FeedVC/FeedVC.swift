//
//  FeedVC.swift
//  Nexshop
//
//  Created by Mac on 01/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON
import UIKit
import AVFoundation
import AVKit
import FirebaseDynamicLinks
import BottomPopup
import AVKit
import FirebaseDynamicLinks


class FeedTableCell:UITableViewCell
{
    
    
    
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var imgviewLike: UIImageView!
    @IBOutlet weak var viewPageControl: FSPageControl!
    @IBOutlet weak var viewPageSlider: FSPagerView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgviewArrow: UIImageView!
    @IBOutlet weak var lblSecondDetail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewMainBackground: UIView!
    @IBOutlet weak var imgviewUser: UIImageView!
    
}

class FeedVC: UIViewController{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var tblviewFeed: UITableView!
    @IBOutlet weak var viewFeed: UIView!
    
    //MARK:- VARIABLES
    
    // var FeedModelData = [FeedModel]()
    var imageSliderArray = NSMutableArray()
    
    var objViewModel = SocialViewModel()
    var arrData = [SocialPostModel]()
    var selectedOption = ""
    var arrGallery = [SocialMediaModel]()
    var socialID:Int?
    var cellIndex = 0
    var offset = 0
    var isStopPagination = false
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentCountUpdate(notification:)), name: NSNotification.Name(rawValue: NotificationName.commentUpdate), object: nil)
                   NotificationCenter.default.addObserver(self, selector: #selector(AddPost(notification:)), name: NSNotification.Name(rawValue: NotificationName.addPost), object: nil)
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(NotificationName.commentUpdate)
        NotificationCenter.default.removeObserver(NotificationName.addPost)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        //          self.tblData.isHidden = true
        print("Explore VC view will appear")
        self.tabBarController?.tabBar.isHidden = true
        
        self.tblviewFeed.isHidden = true
        
        self.tblviewFeed.estimatedRowHeight = 330
        self.tblviewFeed.rowHeight = UITableView.automaticDimension
        
        
        SetUI()
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            /*
             appDelegate.ShowProgess()
             let Temp1 = WebURL.get_explore_post_list + "?limit=1000000&offset=0"
             APIMangagerClass.callGetWithHeader(url: URL(string: Temp1)!, finish: FinishSocialWebserviceCall)
             */
            
            super.viewDidLoad()
           
            // Do any additional setup after loading the view.
            self.setUpUi()
            
            //        tblData.estimatedRowHeight =  self.view.frame.height / 1.5
            ////            self.view.frame.height / 1.5
            //        tblData.rowHeight = UITableView.automaticDimension
            self.GetExplorePostList()
            print("Selected Option \(selectedOption)")
            
            
            
        }
    }
    
    
    
    //MARK:- ALL FUNCTIONS
    
    @objc func AddPost(notification: NSNotification)
    {
        self.GetExplorePostList()
    }
    
    @objc func CommentCountUpdate(notification: NSNotification)
    {
        if let image = notification.object {
            // do something with your image
            print(image)
        }
        if let data = notification.userInfo!["CellIndex"]
        {
            print(data)
            print(notification.userInfo!["totalComment"])
            self.arrData[data as! Int].total_comments! = notification.userInfo!["totalComment"] as! Int
            self.tblviewFeed.reloadRows(at: [IndexPath(row: data as! Int, section: 0)], with: .automatic)
        }
        
        
    }
    
    func setUpUi()
    {
        
        tblviewFeed.register(UINib(nibName: "FeedDataCellXIB", bundle: nil), forCellReuseIdentifier: "FeedDataCellXIB")
        
        self.tblviewFeed.reloadData()
    }
    
    func GetExplorePostList()
    {
        
        
        appDelObj.ShowProgess()
        objViewModel.getSocialPostList(limit: 5000, offset: offset) { (status, message, result) in
            
            if status
            {
                if result != nil
                {
                    guard result?.count != 0 else
                    {
                        //                            self.lblPlaceholderText.isHidden = false
                        self.isStopPagination = true
                        //                           self.tblData.isHidden = false
                        return
                    }
                    //                        self.lblPlaceholderText.isHidden = true
                    //                        self.tblData.isHidden = false
                    self.arrData.append(contentsOf: result!)
                    //                        self.arrData = result!
                    
                    
                    
                    self.tblviewFeed.reloadData()
                    self.tblviewFeed.isHidden = false
                    appDelObj.HideProgress()
                }
            }
            else
            {
                
                Loaf(message, state: .error, sender: self).show()
                return
            }
        }
    }
    
    @objc func btnLikeAction(sender:UIButton)
    {
        let objModel = arrData[sender.tag]
        
        var totalLikes =  objModel.total_likes!
        sender.isSelected.toggle()
        
        if sender.isSelected == true
        {
            totalLikes += 1
        }
        else
        {
            totalLikes -= 1
        }
        
        arrData[sender.tag].total_likes = totalLikes
        sender.setTitle("\(totalLikes)", for: [])
        let like = sender.isSelected ? "like" : "dislike"
        objViewModel.likeDislikePost(postId: objModel.id!, is_like:like , Type: "social_media") { (result, message,data)  in
            if result
            {
                self.tblviewFeed.reloadData()
            }
            else
            {
                
                Loaf(message, state: .error, sender: self).show()
                return
            }
        }
    }
    
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
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbNailImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
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
                                
                                
                                let Shoppingdata = dict["data"].arrayObject! as NSArray
                                
                                print(Shoppingdata)
                                
                                var is_local : Bool!
                                var is_local_path : String!
                                var data : NSData!
                                
                                
                                var FirstNsdict = NSDictionary()
                                var FirstNsmutabledict = NSMutableDictionary()
                                self.imageSliderArray = NSMutableArray()
                                
                                /*
                                 for item1 in Shoppingdata
                                 {
                                 FirstNsdict = item1 as! NSDictionary
                                 FirstNsmutabledict = FirstNsdict.mutableCopy() as! NSMutableDictionary
                                 
                                 print(FirstNsdict)
                                 
                                 let media1 = (FirstNsdict.value(forKey: "media") as! NSArray).mutableCopy() as! NSMutableArray
                                 
                                 for obj in media1
                                 {
                                 
                                 }
                                 
                                 let File1 = FirstNsdict.value(forKey: "file") as! String
                                 
                                 let selectedImage = Data()
                                 FirstNsmutabledict.setValue(selectedImage, forKey: "video_data")
                                 FirstNsmutabledict.setValue("", forKey: "is_local_path")
                                 FirstNsmutabledict.setValue(false, forKey: "is_local")
                                 FirstNsmutabledict.setValue("", forKey: "type")
                                 
                                 if File1.isEmpty == false
                                 {
                                 let TempUrl = URL(string: File1)
                                 
                                 if File1.contains(".jpeg") || File1.contains(".jpg") == true || File1.contains(".png") == true
                                 {
                                 
                                 }
                                 else
                                 {
                                 
                                 self.getThumbnailImageFromVideoUrl(url: TempUrl!) { (thumbNailImage) in
                                 
                                 print(thumbNailImage)
                                 
                                 
                                 }
                                 
                                 }
                                 
                                 
                                 }
                                 
                                 self.imageSliderArray.add(FirstNsmutabledict)
                                 
                                 }
                                 */
                                
                                self.imageSliderArray = Shoppingdata.mutableCopy() as! NSMutableArray
                                //
                                //                                self.FeedModelData.removeAll()
                                //
                                //                                for object in Shoppingdata
                                //                                {
                                //                                    let Data_Object = FeedModel.init(fromDictionary: object as! [String : Any])
                                //                                    self.FeedModelData.append(Data_Object)
                                //
                                //                                }
                                //
                                
                                
                                
                                
                                self.tblviewFeed.reloadData()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:
                                    {
                                        
                                        self.tblviewFeed.isHidden = false
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
    
    func FinishLikeDislikeWebserviceCall (message:String, data:Data?) -> Void
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
                            
                            DispatchQueue.main.async
                                {
                                    
                                    print(dict)
                                    
                                    
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
    
    func SetUI()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewFeed.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        self.tblviewFeed.register(FeedDataCellXIB.self, forCellReuseIdentifier: "FeedDataCellXIB")
        self.tblviewFeed.register(UINib(nibName: "FeedDataCellXIB", bundle: nil), forCellReuseIdentifier: "FeedDataCellXIB")
        
    }
    
    @objc func LikeDislike(sender:UIButton)
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        let objModel = arrData[sender.tag]
        sender.isSelected.toggle()
        var totalLikes =  objModel.total_likes!
        
        if sender.isSelected == true
        {
            totalLikes += 1
        }
        else
        {
            totalLikes -= 1
        }
        var likes = ""
        if totalLikes > 1
        {
            likes = "\(totalLikes)" + " Likes"
        }
        else
        {
            likes = "\(totalLikes)" + " Like"
        }
        arrData[sender.tag].total_likes = totalLikes
        sender.setTitle(likes, for: [])
        let like = sender.isSelected ? "like" : "dislike"
        objViewModel.likeDislikePost(postId: objModel.id!, is_like:like , Type: "social_media") { (result, message,data)  in
            if result
            {
                
            }
            else
            {
                
                Loaf(message, state: .error, sender: self).show()
                return
            }
        }
    }
    
    @objc func GetCommentList(sender:UIButton)
    {
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
        Push.isCommentid = "\(self.arrData[sender.tag].id!)"
        Push.CommentAdd = self
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    @objc func commentClick(sender:UIButton)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
        Push.isCommentid = "\(arrData[sender.tag].id!)"
        Push.CommentAdd = self

        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
    @objc func SharePost(sender:UIButton)
    {
        /*
         
         private fun getReceiveLink() {
         FirebaseDynamicLinks.getInstance()
         .getDynamicLink(intent)
         .addOnSuccessListener(this) { pendingDynamicLinkData ->
         var deepLink: Uri? = null
         if (pendingDynamicLinkData != null) {
         deepLink = pendingDynamicLinkData.link
         Log.i("===>", deepLink.toString())
         
         
         if (deepLink.toString().contains("product_id")) {
         val productId = deepLink.toString().replace("$SHARE_URL?product_id=", "").trim()
         loadFragment(mContext, ProductDetailFragment(mContext, productId), "Product Detail")
         } else if (deepLink.toString().contains("post_id")) {
         val postID = deepLink.toString().replace("$SHARE_URL?post_id=", "").trim()
         start<SharePostActivity>(false, "post_id" to postID)
         }
         
         }
         }
         .addOnFailureListener(this) { e -> Log.i("===>", "getDynamicLink:onFailure", e) }
         }
         
         */
        let objModel = arrData[sender.tag]
        let postId = objModel.id!
        guard let link = URL(string: "https://nexshopcustomer.post_details.com/?post_id=\(postId)" ) else { return }
        let dynamicLinksDomainURIPrefix = "https://nexshop.page.link"
        
        if let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.NexshopCustomer.Zb")
            linkBuilder.iOSParameters?.fallbackURL = URL(string: "www.google.com")
            linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.nexshop")
            linkBuilder.androidParameters?.fallbackURL = URL(string: "www.google.com")
            linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            linkBuilder.socialMetaTagParameters!.title = objModel.user?.name
            linkBuilder.socialMetaTagParameters!.descriptionText = objModel.description!.trunc(length: 1000)
            linkBuilder.socialMetaTagParameters!.imageURL = URL(string: objModel.media![0].file!)
            linkBuilder.shorten() { url, warnings, error in
                guard let url = url, error == nil else { return
                    
                    
                    print(error!.localizedDescription)
                    Loaf(error!.localizedDescription, state: .error, sender: self).show()
                    return
                    
                }
                print("The short URL is: \(url)")
                self.sharePopUp(sharingItems: [url])
            }
        }
        
    }
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnhandlerCreateFeed(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "CreateFeedVC") as! CreateFeedVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    
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

/*
 
 extension FeedVC:UITableViewDelegate,UITableViewDataSource
 {
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
 if self.FeedModelData.count == 0
 {
 self.tblviewFeed.setEmptyMessage("No Records Found")
 }
 else
 {
 self.tblviewFeed.restore()
 }
 
 return self.FeedModelData.count
 
 
 }
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 let cell = self.tblviewFeed.dequeueReusableCell(withIdentifier: "FeedDataCellXIB") as! FeedDataCellXIB
 
 if self.FeedModelData.count > 0
 {
 /*
 cell.lblUsername.text = self.FeedModelData[indexPath.row].user?.name
 
 if self.FeedModelData[indexPath.row].isLike == 1
 {
 cell.imgviewlike.image = UIImage(named: "ic_red_heart")
 }
 else
 {
 cell.imgviewlike.image = UIImage(named: "ic_grey_heart")
 }
 
 cell.lblLike.text = "\(self.FeedModelData[indexPath.row].totalLikes!)"
 
 cell.lblComment.text = "\(self.FeedModelData[indexPath.row].totalComments!)"
 
 cell.imgviewUser.kf.indicatorType = .activity
 cell.imgviewUser.kf.setImage(with: URL(string: (self.FeedModelData[indexPath.row].user.avatar!)))
 
 
 cell.lblTime.text = self.FeedModelData[indexPath.row].createdAt!
 
 
 
 let arrGallery = self.FeedModelData[indexPath.row].media
 cell.pagerView.reloadData()
 cell.pageControl.numberOfPages = self.FeedModelData[indexPath.row].media.count
 
 */
 
 if Utility.isHtml((self.FeedModelData[indexPath.row].descriptionField)) {
 cell.lblDescription.attributedText = (self.FeedModelData[indexPath.row].descriptionField.html2AttributedString)
 } else {
 cell.lblDescription.text = (self.FeedModelData[indexPath.row].descriptionField)
 }
 
 cell.btnTitleLike.tag = indexPath.row
 cell.btnTitleShare.tag = indexPath.row
 cell.btnTitleComment.tag = indexPath.row
 
 cell.imgviewEdir.isHidden = true
 
 cell.btnTitleClose.isHidden = true
 cell.btnTitleLike.addTarget(self, action: #selector(self.LikeDislike(sender:)), for: .touchUpInside)
 cell.btnTitleShare.addTarget(self, action: #selector(self.SharePost(sender:)), for: .touchUpInside)
 cell.btnTitleComment.addTarget(self, action: #selector(self.GetCommentList(sender:)), for: .touchUpInside)
 
 cell.setData(PostModel: self.FeedModelData[indexPath.row],DataDict:self.imageSliderArray.object(at: indexPath.row) as! NSDictionary)
 
 cell.layoutIfNeeded()
 
 
 }
 
 cell.selectionStyle = .none
 return cell
 }
 
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 
 return UITableView.automaticDimension
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
 let Push = mainStoryboard.instantiateViewController(withIdentifier: "PostFullScreenVC") as! PostFullScreenVC
 Push.Post_Detail = "\(self.FeedModelData[indexPath.row].id!)"
 self.navigationController?.pushViewController(Push, animated: true)
 }
 }
 
 */

extension String {
    /*
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     - Parameter length: Desired maximum lengths of a string
     - Parameter trailing: A 'String' that will be appended after the truncation.
     
     - Returns: 'String' object.
     */
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}


extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblviewFeed.dequeueReusableCell(withIdentifier: "FeedDataCellXIB") as? FeedDataCellXIB
        cell?.selectionStyle = .none
        
        cell?.imgviewEdir.isHidden = true
        
        let objModel = arrData[indexPath.row]
        print(objModel)
        
        cell!.setData(PostModel: objModel)
        
        if Utility.isHtml((objModel.description!)) {
            cell!.lblDescription.attributedText = objModel.description?.html2AttributedString
        } else {
            cell!.lblDescription.text = objModel.description ?? ""
            
        }
        cell?.btnTitleShare.tag = indexPath.row
        cell?.btnTitleShare.addTarget(self, action: #selector(SharePost(sender:)), for: .touchUpInside)
        
        cell?.btnTitleComment.tag = indexPath.row
        cell?.btnTitleComment.addTarget(self, action: #selector(GetCommentList(sender:)), for: .touchUpInside)
        
        cell?.btnTitleLike.tag = indexPath.row
        cell?.btnTitleLike.addTarget(self, action: #selector(self.LikeDislike(sender:)), for: .touchUpInside)
        
        //                cell?.btnTitleComment.tag = indexPath.row
        //                cell?.btnTitleComment.addTarget(self, action: #selector(LabelAction(sender:)), for: .touchUpInside)
        //
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        //        return self.view.frame.height / 1.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
}


extension FeedVC : CommentUpdate
{
    func CommentNew(isUpdateNew: Bool)
    {
        //          self.tblData.isHidden = true
        print("Explore VC view will appear")
        self.tabBarController?.tabBar.isHidden = true
        
        self.arrData = []
        self.tblviewFeed.isHidden = true
        
        self.tblviewFeed.estimatedRowHeight = 330
        self.tblviewFeed.rowHeight = UITableView.automaticDimension
        
        
        SetUI()
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            /*
             appDelegate.ShowProgess()
             let Temp1 = WebURL.get_explore_post_list + "?limit=1000000&offset=0"
             APIMangagerClass.callGetWithHeader(url: URL(string: Temp1)!, finish: FinishSocialWebserviceCall)
             */
            
            super.viewDidLoad()
           
            // Do any additional setup after loading the view.
            self.setUpUi()
            
            //        tblData.estimatedRowHeight =  self.view.frame.height / 1.5
            ////            self.view.frame.height / 1.5
            //        tblData.rowHeight = UITableView.automaticDimension
            appDelegate.ShowProgess()
            self.GetExplorePostList()
            print("Selected Option \(selectedOption)")
            
            
            
        }
    }
    
}
