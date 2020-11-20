//
//  PostDetailVC.swift
//  Nexshop
//
//  Created by Mac on 10/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON
import UIKit
import AVFoundation
import AVKit
import FirebaseDynamicLinks

class PostDetailVC: UIViewController {
    
    
    // MARK: - UIControlers Outlets
    
    @IBOutlet weak var tblviewHome: UITableView!
    
    
    // MARK: - Variables
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
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.GetPostDetail()
        // Do any additional setup after loading the view.
        self.setUpUi()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Other Functions
    
    func setUpUi()
    {
        
        tblviewHome.register(UINib(nibName: "ExploreCell", bundle: nil), forCellReuseIdentifier: "ExploreCell")
        //            tblView.tableHeaderView = headerView
        
        self.tblviewHome.reloadData()
    }
    
    @objc func commentClick(sender:UIButton)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
        Push.isCommentid = "\(self.arrData[sender.tag].id!)"
        self.navigationController?.pushViewController(Push, animated: true)
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
        let dynamicLinksDomainURIPrefix = "https://nexshopcustomer.page.link"
        
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
        sender.setTitle("\(totalLikes)", for: [])
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
    
    // MARK: - UIButton Actions
    
    // MARK: - UITableView Delegate Methods
    
    // MARK: - UICollectionView Delegate Methods
    
    // MARK: - WEB API Methods
    
    func GetPostDetail()
    {
        appDelegate.ShowProgess()
        objViewModel.getSocialPostDetail(posID: postID) { (status, message, result) in
            appDelegate.HideProgress()
            if status
            {
                if result != nil
                {
                    
                    self.arrData = [result!]
                    self.tblviewHome.reloadData()
                }
            }
            else
            {
                Loaf(message, state: .error, sender: self).show()
                return
            }
        }
        
    }
    
}


extension PostDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblviewHome.dequeueReusableCell(withIdentifier: "FeedDataCellXIB") as? FeedDataCellXIB
        cell?.selectionStyle = .none
        
        cell?.btnTitleComment.tag = indexPath.row
        cell?.btnTitleComment.addTarget(self, action: #selector(self.commentClick(sender:)), for: .touchUpInside)
        
        
        let objModel = arrData[indexPath.row]
        cell!.setData(PostModel: <#T##FeedModel?#>, DataDict: <#T##NSDictionary#>)(PostModel: objModel)
        
        cell?.btnTitleLike.tag = indexPath.row
        cell?.btnTitleLike.addTarget(self, action: #selector(btnLikeAction(sender:)), for: .touchUpInside)
        
        cell?.btnTitleShare.isHidden = false
        cell?.btnTitleShare.tag = indexPath.row
        cell?.btnTitleShare.addTarget(self, action: #selector(shareAction(sender:)), for: .touchUpInside)
        
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 2
    }
    
    
    
}
