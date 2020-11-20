//
//  PostFullScreenVC.swift
//  Nexshop
//
//  Created by Mac on 12/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import BottomPopup
import FirebaseDynamicLinks
import Loaf
import SwiftyJSON

class PostFullScreenVC: UIViewController {
    
    //MARK:- OUTLETLS
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblviewHome: UITableView!
    
    
    var height: CGFloat = UIScreen.main.bounds.size.height - 120
    var topCornerRadius: CGFloat = 0
    var presentDuration: Double = 0.5
    var dismissDuration: Double = 0.5
    let kHeightMaxValue: CGFloat = 600
    let kTopCornerRadiusMaxValue: CGFloat = 35
    let kPresentDurationMaxValue = 0.5
    let kDismissDurationMaxValue = 0.5
    var objViewModel = SocialViewModel()
    var arrData = [SocialPostModel]()
    var selectedOption = ""
    var postID = 0
    var arrGallery = [SocialMediaModel]()
    var imageSliderArray = NSMutableDictionary()
    var FeedModelData = [FeedModel]()
    var Post_Detail = String()
    
    //MARK:-VARIABLES
    
    
    //MARK:- VIEW DID LOAD
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        print(postID)
        print(Post_Detail)
        
        
        self.tblviewHome.backgroundColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "FAFAFA")
        
        appDelegate.ShowProgess()
        setUpUi()
        GetPostDetail()
        //        let Temp1 = WebURL.get_post_detail + "?post_id=" + "\(self.Post_Detail)"
        //        APIMangagerClass.callGetWithHeader(url: URL(string: Temp1)!, finish: FinishSocialWebserviceCall)
        
    }
    
    
    
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnHandlerback(_ sender: Any)
    {
        appDelObj.SetHomeRoot()
    }
    
    //MARK:- ALL FUNCTIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
                                
                                
                                let Shoppingdata = dict["data"].dictionaryObject! as NSDictionary
                                
                                print(Shoppingdata)
                                
                                self.imageSliderArray = Shoppingdata.mutableCopy() as! NSMutableDictionary
                                
                                self.FeedModelData.removeAll()
                                
                                let cate_objec = FeedModel.init(fromDictionary: Shoppingdata as! [String : Any] )
                                self.FeedModelData.append(cate_objec)
                                
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
    
    func setUpUi()
    {
        
        tblviewHome.register(UINib(nibName: "FeedDataCellXIB", bundle: nil), forCellReuseIdentifier: "FeedDataCellXIB")
        //            tblView.tableHeaderView = headerView
        
    }
    
    @objc func commentClick(sender:UIButton)
    {
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
        Push.isCommentid = "\(self.arrData[sender.tag].id!)"
        Push.CommentAdd = self
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
    func GetPostDetail()
    {
        appDelObj.ShowProgess()
        
        objViewModel.getSocialPostDetail(posID: Int(Post_Detail)!) { (status, message, result) in
            
            if status
            {
                if result != nil
                {
                    
                    self.arrData = [result!]
                    self.tblviewHome.reloadData()
                    self.tblviewHome.isHidden = false
                    appDelObj.HideProgress()
                }
            }
            else
            {
                appDelObj.HideProgress()
                Loaf(message, state: .error, sender: self).show()
                return
            }
        }
    }
    
    @objc func btnLikeAction(sender:UIButton)
    {
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
                appDelObj.HideProgress()
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
    
    @objc func shareAction(sender:UIButton)
    {
        
        let objModel = arrData[sender.tag]
        let postId = objModel.id!
        guard let link = URL(string: "https://nexshopcustomer.post_details.com/?post_id=\(postId)" ) else { return }
        let dynamicLinksDomainURIPrefix = "https://nexshop.page.link"
        
        if let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix) {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.NexshopCustomer.Zb")
            linkBuilder.iOSParameters?.fallbackURL = URL(string: "")
            linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.nexshop")
            linkBuilder.androidParameters?.fallbackURL = URL(string: "")
            linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
            linkBuilder.socialMetaTagParameters!.title = objModel.user?.name
            linkBuilder.socialMetaTagParameters!.descriptionText = objModel.description!.trunc(length: 1000)
            linkBuilder.socialMetaTagParameters!.imageURL = URL(string: objModel.media![0].file!)
            linkBuilder.shorten() { url, warnings, error in
                guard let url = url, error == nil else { return
                    
                    Loaf(error!.localizedDescription, state: .error, sender: self).show()
                    return
                }
                print("The short URL is: \(url)")
                self.sharePopUp(sharingItems: [url])
            }
        }
        
    }
    
    
    
    
}


extension PostFullScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblviewHome.dequeueReusableCell(withIdentifier: "FeedDataCellXIB") as? FeedDataCellXIB
        cell?.selectionStyle = .none
        print(self.FeedModelData.count)
        print(self.arrData.count)
        
        cell?.viewBG.backgroundColor = UIColor.white
        
        if self.arrData.count > 0
        {
            cell?.btnTitleComment.tag = indexPath.row
            cell?.btnTitleComment.addTarget(self, action: #selector(self.commentClick(sender:)), for: .touchUpInside)
            
            
            cell?.btnTitleLike.tag = indexPath.row
            cell?.btnTitleLike.addTarget(self, action: #selector(btnLikeAction(sender:)), for: .touchUpInside)
            
            cell?.btnTitleShare.isHidden = false
            cell?.btnTitleShare.tag = indexPath.row
            cell?.btnTitleShare.addTarget(self, action: #selector(shareAction(sender:)), for: .touchUpInside)
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
            
            
            
            return cell!
        }
        else
        {
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 2
    }
    
    
    
}



extension PostFullScreenVC : CommentUpdate
{
    func CommentNew(isUpdateNew: Bool) {
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        self.tblviewHome.backgroundColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "FAFAFA")
        
        appDelegate.ShowProgess()
        setUpUi()
        GetPostDetail()
        
    }
    
}


