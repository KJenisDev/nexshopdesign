//
//  ProfileVC.swift
//  Nexshop
//
//  Created by Mac on 01/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import ParallaxHeader
import Loaf
import SwiftyJSON
import UIKit
import AVFoundation
import AVKit
import FirebaseDynamicLinks

class ProfileVC: UIViewController
{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var viewParallax: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblviewHome: UITableView!
    
    
    
    //MARK:- VARIABLES
    var FeedModelData = [FeedModel]()
    var imageSliderArray = NSMutableArray()
    var arrData = [UserProfilePostModel]()
    var postData:SocialUserPostModel?
    var objViewModel = SocialViewModel()
    var arrData1 = [SocialPostModel]()
    
    
    
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func setUI() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
            
            var frame = CGRect.zero
            frame.size.height = .leastNonzeroMagnitude
            
            self.tblviewHome.register(FeedDataCellXIB.self, forCellReuseIdentifier: "FeedDataCellXIB")
            self.tblviewHome.register(UINib(nibName: "FeedDataCellXIB", bundle: nil), forCellReuseIdentifier: "FeedDataCellXIB")
            
            
            self.tblviewHome.register(ProfileUserDataHeaderCellXIB.self, forCellReuseIdentifier: "ProfileUserDataHeaderCellXIB")
            self.tblviewHome.register(UINib(nibName: "ProfileUserDataHeaderCellXIB", bundle: nil), forCellReuseIdentifier: "ProfileUserDataHeaderCellXIB")
            
            self.tblviewHome.estimatedRowHeight = 330
            self.tblviewHome.rowHeight = UITableView.automaticDimension
            self.tblviewHome.backgroundColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "FAFAFA")
            
            
            
            
            
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        let Temp1 = WebURL.get_my_post_list + "?limit=1000000&offset=0"
        
        //APIMangagerClass.callGetWithHeader(url: URL(string: Temp1)!, finish: FinishSocialWebserviceCall)
        
        self.getUserProfilePostDetail()
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
    
    func getUserProfilePostDetail()
    {
        let id1 = appDelegate.get_user_Data(Key: "id")
        
        objViewModel.getUserProfileDetail(userID: Int(id1)!) { (status, message, result) in
            
            if status
            {
                if result != nil
                {
                    self.arrData = []
                    
                    self.arrData = [result!]
                    //                        print("after Adding\(self.arrData[0].post?.count)")
                    print(self.FeedModelData.count)
                    print(self.arrData[0].post!.count)
                    
                    self.tblviewHome.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:
                        {
                            
                            self.tblviewHome.isHidden = false
                            appDelegate.HideProgress()
                    })
                    
                }
            }
            else
            {
                
            }
        }
    }
    
    
    
    @objc func EditPost(sender:UIButton)
    {
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let imagealbums = UIAlertAction(title: "Edit Post", style: .default)
        { _ in
            
            if  CommonClass.sharedInstance.isReachable() == false
            {
                Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                return
            }
            
            let navObj = mainStoryboard.instantiateViewController(withIdentifier: "CreateFeedVC") as! CreateFeedVC
            navObj.postData = self.arrData[0].post![sender.tag]
            self.hidesBottomBarWhenPushed = true
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(navObj, animated: true)
            
        }
        actionSheetControllerIOS8.addAction(imagealbums)
        
        let selectfromcamera = UIAlertAction(title: "Remove Post", style: .default)
        { _ in
            
            if  CommonClass.sharedInstance.isReachable() == false
            {
                Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                return
            }
            
            self.objViewModel.getDeletePost(posID: self.arrData[0].post![sender.tag].id!) { (result, message) in
                appDelObj.ShowProgess()
                guard result == false else
                {
                    appDelObj.HideProgress()
                    self.getUserProfilePostDetail()
                    return
                }
                Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                return
            }
        }
        actionSheetControllerIOS8.addAction(selectfromcamera)
        
        
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    
    
    
    
    @objc func RemovePost(sender:Int)
    {
        
        if  CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        
        let Temp1 = WebURL.social_delete_post + "/" + "\(self.FeedModelData[sender].id!)"
        
        print(Temp1)
        
        
        APIMangagerClass.callGetWithHeader(url: URL(string: Temp1)!, finish: RemovePost)
        
        
        
    }
    
    func RemovePost (message:String, data:Data?) -> Void
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
                                
                                print(dict)
                                
                                
                                appDelegate.ShowProgess()
                                
                                let Temp1 = WebURL.get_my_post_list + "?limit=1000000&offset=0"
                                
                                APIMangagerClass.callGetWithHeader(url: URL(string: Temp1)!, finish: self.FinishSocialWebserviceCall)
                                
                                
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
    
    @objc func LikeDislike(sender:UIButton)
    {
        /*
         if self.FeedModelData[sender.tag].isLike == 0
         {
         
         if CommonClass.sharedInstance.isReachable() == false
         {
         Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
         return
         }
         
         if CommonClass.sharedInstance.isReachable() == false
         {
         Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
         return
         }
         
         let Paramteres = ["id":"\(self.FeedModelData[sender.tag].id!)","type":"social_media","is_like":"like"]
         
         APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_addresses)!, params: Paramteres, finish: self.FinishLikeDislikeWebserviceCall)
         
         self.FeedModelData[sender.tag].isLike = 1
         
         self.FeedModelData[sender.tag].totalLikes = self.FeedModelData[sender.tag].totalLikes + 1
         self.tblviewHome.reloadData()
         
         }
         else
         {
         if CommonClass.sharedInstance.isReachable() == false
         {
         Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
         return
         }
         
         let Paramteres = ["id":"\(self.FeedModelData[sender.tag].id!)","type":"social_media","is_like":"dislike"]
         
         APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_addresses)!, params: Paramteres, finish: self.FinishLikeDislikeWebserviceCall)
         
         self.FeedModelData[sender.tag].isLike = 0
         
         if self.FeedModelData[sender.tag].totalLikes > 0
         {
         self.FeedModelData[sender.tag].totalLikes = self.FeedModelData[sender.tag].totalLikes  - 1
         }
         self.tblviewHome.reloadData()
         }
         */
        
        
        let objModel = arrData[0].post![sender.tag]
        
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
        
        var likes = ""
        if totalLikes > 1
        {
            likes = "\(totalLikes)" + " Likes"
        }
        else
        {
            likes = "\(totalLikes)" + " Like"
        }
        
        print(likes)
        arrData[0].post![sender.tag].total_likes = totalLikes
        sender.setTitle(likes, for: [])
        
        let like = sender.isSelected ? "like" : "dislike"
        objViewModel.likeDislikePost(postId: objModel.id!, is_like:like , Type: "social_media") { (result, message,data)  in
            if result
            {
                
            }
            else
            {
                appDelObj.HideProgress()
                Loaf(message, state: .error, sender: self).show()
                return
            }
        }
        
        
        
    }
    
    @objc func GetCommentList(sender:UIButton)
    {
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
        Push.isCommentid = "\(arrData[0].post![sender.tag].id!)"
        Push.CommentAdd = self
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
    @objc func SharePost(sender:UIButton)
    {
        let objModel = arrData[0].post![sender.tag]
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
            linkBuilder.socialMetaTagParameters!.imageURL = URL(string: (objModel.user?.avatar!)!)
            linkBuilder.shorten() { url, warnings, error in
                guard let url = url, error == nil else { return
                    
                    
                    print(error!.localizedDescription)
                    //Loaf(error!.localizedDescription, state: .error, sender: self).show()
                    Loaf(error!.localizedDescription, state: .error, sender: self).show()
                    return
                    
                }
                print("The short URL is: \(url)")
                self.sharePopUp(sharingItems: [url])
            }
        }
        
    }
    
    @objc func EditProfile(senderr:UIButton)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(Push, animated: true)
        
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
                                
                                self.getUserProfilePostDetail()
                                
                                self.imageSliderArray = Shoppingdata.mutableCopy() as! NSMutableArray
                                
                                self.FeedModelData.removeAll()
                                
                                for object in Shoppingdata
                                {
                                    let Data_Object = FeedModel.init(fromDictionary: object as! [String : Any])
                                    self.FeedModelData.append(Data_Object)
                                    
                                }
                                
                                
                                print(self.FeedModelData.count)
                                
                                
                                
                                
                                
                                
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
    
}


//MARK:- COLLECTIONVIEW METHODS

extension ProfileVC:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 1
        }
        else
        {
            
            if self.arrData.count == 0
            {
                return 0
            }
            
            if self.arrData[0].post!.count == 0
            {
                self.tblviewHome.setEmptyMessage("No Records Found")
            }
            else
            {
                self.tblviewHome.restore()
            }
            
            return self.arrData[0].post!.count
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.arrData.count == 0
        {
            return UITableViewCell()
        }
        
        if indexPath.section == 0
        {
            let cell = self.tblviewHome.dequeueReusableCell(withIdentifier: "ProfileUserDataHeaderCellXIB") as! ProfileUserDataHeaderCellXIB
            
            DispatchQueue.main.async {
                cell.viewImage.applyShadowWithCornerRadius(color: .darkGray, opacity: 0.2, radius: 1, edge: AIEdge.All, shadowSpace: 1, CornerRadius: 50)
            }
            
            cell.btnEditProfile.addTarget(self, action: #selector(self.EditProfile(senderr:)), for: .touchUpInside)
            
            cell.lblDob.text = "\(appDelegate.get_user_Data(Key: "dob") as! String)"
            cell.lblAbout.text = "\(appDelegate.get_user_Data(Key: "about") as! String)"
            cell.lblUserName.text = "\(appDelegate.get_user_Data(Key: "name") as! String)"
            cell.lblEmail.text = "\(appDelegate.get_user_Data(Key: "email") as! String)"
            cell.lblMobileNumber.text = appDelegate.get_user_Data(Key: "country_code") as! String + " " +  "\(appDelegate.get_user_Data(Key: "mobile") as! String)"
            
            cell.lblGender.text = "\(appDelegate.get_user_Data(Key: "gender") as! String)"
            
            cell.imgviewPic.kf.indicatorType = .activity
            cell.imgviewPic.kf.setImage(with: URL(string: "\(appDelegate.get_user_Data(Key: "avatar") as! String)"   ))
            
            return cell
            
            
            return cell
        }
        else
        {
            
            let cell = tblviewHome.dequeueReusableCell(withIdentifier: "FeedDataCellXIB") as! FeedDataCellXIB
            cell.selectionStyle = .none
            
            
            
            cell.btnTitleComment.tag = indexPath.row
            cell.btnTitleComment.addTarget(self, action: #selector(self.GetCommentList(sender:)), for: .touchUpInside)
            
            cell.btnTitleLike.tag = indexPath.row
            cell.btnTitleLike.addTarget(self, action: #selector(LikeDislike(sender:)), for: .touchUpInside)
            
            
            cell.btnTitleShare.tag = indexPath.row
            cell.btnTitleShare.addTarget(self, action: #selector(self.SharePost(sender:)), for: .touchUpInside)
            
            
            cell.imgviewEdir.isHidden = false
            cell.btnTitleClose.tag = indexPath.row
            cell.btnTitleClose.addTarget(self, action: #selector(self.EditPost(sender:)), for: .touchUpInside)
            
            
            
            let objModel = arrData[0].post![indexPath.row]
            cell.isFromUserProfile = true
            
            cell.setUserProfilePostData(PostModel: objModel)
            if Utility.isHtml((objModel.description!)) {
                cell.lblDescription.attributedText = objModel.description?.html2AttributedString
            } else {
                cell.lblDescription.text = objModel.description ?? ""
                
            }
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
}


extension ProfileVC : CommentUpdate
{
    func CommentNew(isUpdateNew: Bool) {
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        self.tblviewHome.backgroundColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "FAFAFA")
        
        
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        let Temp1 = WebURL.get_my_post_list + "?limit=1000000&offset=0"
        
        //APIMangagerClass.callGetWithHeader(url: URL(string: Temp1)!, finish: FinishSocialWebserviceCall)
        
        self.getUserProfilePostDetail()
        
        
        
    }
    
}
