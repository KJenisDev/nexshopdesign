//
//  FeedDataCellXIB.swift
//  Nexshop
//
//  Created by Mac on 01/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Lightbox
import AVKit
import SKPhotoBrowser
import SDWebImage

class FeedDataCellXIB: UITableViewCell,FSPagerViewDataSource,FSPagerViewDelegate,SKPhotoBrowserDelegate{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var btnTitleClose: UIButton!
    @IBOutlet weak var btnTitleShare: UIButton!
    @IBOutlet weak var btnTitleComment: UIButton!
    @IBOutlet weak var btnTitleLike: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgviewEdir: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var imgviewlike: UIImageView!
    
    
    @IBOutlet weak var pageControl: FSPageControl!{
        didSet {
            
            self.pageControl.itemSpacing = 10
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.pageControl.hidesForSinglePage = false
            self.pageControl.backgroundColor = UIColor.clear
            
            
        }
    }
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = FSPagerView.automaticSize
            self.pagerView.backgroundColor = UIColor.clear
         //   self.pagerView.automaticSlidingInterval = 5.0

            self.pagerView.backgroundView?.removeFromSuperview()
          // pagerView.automaticSlidingInterval = 2.0
            
            
        }}
    
    //MARK:- VARIABLES
    
    
    var FeedModelData = [FeedModel]()
    var arrMedia = [SocialMediaModel]()
    var arrMediaOne = [Media]()
    var playerController = AVPlayerViewController()
    var DataSetDict = NSDictionary()
    var Image_Zoom = String()
    var isOnlyDict = false
    
    var dataModel : SocialPostModel?
    var userPostDataModel:SocialUserPostModel?
    
    
    var isFromUserProfile = false
    
    
    //MARK:- OTHER FUNCTIONS
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pagerView.dataSource = self
        pagerView.delegate = self
        
        
             
        self.pageControl.setImage(UIImage(named:"ic_white_Circle-3"), for: .normal)
        self.pageControl.setImage(UIImage(named:"ic_blue_circle-3"), for: .selected)
        
        //------ image slider configure ------
        
        //self.imageSlider.pageControlPosition = .insideScrollView
        
        //----- adding pagecontrol -----
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.clear
        
        imgviewUser.layer.cornerRadius = self.imgviewUser.frame.size.height / 2
        
        //        self.ViewMain.layer.cornerRadius = 5
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    /*
     func setData(PostModel:FeedModel?,DataDict:NSDictionary)
     {
     DispatchQueue.main.async {
     
     self.DataSetDict = DataDict
     
     self.lblUsername.text = PostModel?.user?.name
     
     if PostModel?.isLike == 1
     {
     self.imgviewlike.image = UIImage(named: "ic_red_heart")
     }
     else
     {
     self.imgviewlike.image = UIImage(named: "ic_grey_heart")
     }
     
     //self.btnLike.isSelected = PostModel?.is_like == 1
     
     if PostModel!.totalLikes > 1
     {
     self.lblLike.text = "\(PostModel!.totalLikes!)" + " Likes"
     }
     else
     {
     self.lblLike.text = "\(PostModel!.totalLikes!)" + " Like"
     
     }
     
     
     self.lblComment.text = "\(PostModel!.totalComments!)" + " Comments"
     
     self.imgviewUser.kf.indicatorType = .activity
     self.imgviewUser.kf.setImage(with: URL(string: (PostModel?.user.avatar!)!))
     
     
     print(PostModel!.user.id!)
     
     self.lblTime.text = PostModel?.createdAt!
     
     let arrGallery = PostModel?.media
     
     guard arrGallery!.count > 0 else
     {
     return
     }
     self.arrMediaOne = arrGallery!
     self.pagerView.automaticSlidingInterval = 5.0
     self.pagerView.reloadData()
     self.pageControl.numberOfPages = self.arrMediaOne.count
     
     
     }
     }
     
     func setOnlyData(DataDict:NSDictionary,isOnlyOneData:Bool)
     {
     DispatchQueue.main.async {
     
     
     self.DataSetDict = DataDict
     
     // isOnlyOneData = self.isOnlyDict
     
     print(self.isOnlyDict)
     
     
     
     
     /*
     self.lblUsername.text = PostModel?.user?.name
     
     if PostModel?.isLike == 1
     {
     self.imgviewlike.image = UIImage(named: "ic_red_heart")
     }
     else
     {
     self.imgviewlike.image = UIImage(named: "ic_grey_heart")
     }
     
     //self.btnLike.isSelected = PostModel?.is_like == 1
     
     if PostModel!.totalLikes > 1
     {
     self.lblLike.text = "\(PostModel!.totalLikes!)" + " Likes"
     }
     else
     {
     self.lblLike.text = "\(PostModel!.totalLikes!)" + " Like"
     
     }
     
     
     self.lblComment.text = "\(PostModel!.totalComments!)" + " Comments"
     
     self.imgviewUser.kf.indicatorType = .activity
     self.imgviewUser.kf.setImage(with: URL(string: (PostModel?.user.avatar!)!))
     
     
     print(PostModel!.user.id!)
     
     self.lblTime.text = PostModel?.createdAt!
     
     let arrGallery = PostModel?.media
     
     guard arrGallery!.count > 0 else
     {
     return
     }
     self.arrMediaOne = arrGallery!
     self.pagerView.automaticSlidingInterval = 5.0
     self.pagerView.reloadData()
     self.pageControl.numberOfPages = self.arrMediaOne.count
     
     */
     }
     }
     */
    
    func setData(PostModel:SocialPostModel?)
    {
        DispatchQueue.main.async {
            
            self.dataModel = PostModel
            self.lblUsername.text = PostModel?.user?.name
            
            if PostModel?.is_like == 1
            {
                self.imgviewlike.image = UIImage(named: "ic_red_heart")
            }
            else
            {
                self.imgviewlike.image = UIImage(named: "ic_grey_heart")
            }
            
            //self.btnLike.isSelected = PostModel?.is_like == 1
            var likes = ""
            if PostModel!.total_likes! > 1
            {
                likes = "\(PostModel!.total_likes!)" + " Likes"
                
            }
            else
            {
                likes = "\(PostModel!.total_likes!)" + " Like"
                
            }
            self.btnTitleLike.setTitle(likes, for: .normal)
            self.lblComment.text = "\(PostModel!.total_comments!)" + " Comments"
            
            self.imgviewUser.sd_setImage(with: URL(string: (PostModel!.user?.avatar!)!), placeholderImage: UIImage(named: "Artboard – 1"))
            
            self.lblTime.text = PostModel?.created_at!
            
            let arrGallery = PostModel?.media
            
            guard arrGallery!.count > 0 else
            {
                return
            }
            self.arrMedia = arrGallery!
            
            self.pagerView.reloadData()
            self.pageControl.numberOfPages = self.arrMedia.count
            
            
        }
    }
    
    func setUserProfilePostData(PostModel:SocialUserPostModel?)
          {
            DispatchQueue.main.async {

                self.userPostDataModel = PostModel
                
                self.lblUsername.text = PostModel?.user?.name

                if PostModel?.is_like == 1
                           {
                               self.imgviewlike.image = UIImage(named: "ic_red_heart")
                           }
                           else
                           {
                               self.imgviewlike.image = UIImage(named: "ic_grey_heart")
                           }
                
                var likes = ""
                if PostModel!.total_likes! > 1
                {
                    likes = "\(PostModel!.total_likes!)" + " Likes"
                    
                }
                else
                {
                    likes = "\(PostModel!.total_likes!)" + " Like"
                    
                }
                
                self.btnTitleLike.setTitle(likes, for: .normal)
                           self.lblComment.text = "\(PostModel!.total_comments!)" + " Comments"
                           
                           self.imgviewUser.sd_setImage(with: URL(string: (PostModel!.user?.avatar!)!), placeholderImage: UIImage(named: "Artboard – 1"))
                           
                           self.lblTime.text = PostModel?.created_at!
                           
                
                self.lblTime.text = PostModel?.created_at
    //            if Utility.isHtml((PostModel!.description!)) {
    //            self.lblDescription.attributedText = PostModel!.description?.html2AttributedString
    //               } else {
    //            self.lblDescription.text = PostModel?.description ?? ""
    //               }
                let arrGallery = PostModel?.post_detail

                guard arrGallery!.count > 0 else
                {
                return
                }
                self.arrMedia = arrGallery!

                self.pagerView.reloadData()
                self.pageControl.numberOfPages = self.arrMedia.count


              }
        }
    // MARK:- FSPagerView DataSource
    
    /*
    public func numberOfItems(in pagerView: FSPagerView) -> Int
    {
        if self.DataSetDict.count > 0
        {
            return (self.DataSetDict.value(forKey: "media") as! NSArray).count
            
        }
        else
        {
            return 0
        }
        
        
        
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        cell.contentView.layer.shadowColor = UIColor.clear.cgColor
        cell.backgroundColor = UIColor.clear
        cell.imageView?.image = UIImage(named: "")
        
        if self.DataSetDict.count > 0
        {
            let Data1 = ((self.DataSetDict.value(forKey: "media") as! NSArray).object(at: index) as! NSDictionary)
            
            let File1 = Data1.value(forKey: "file") as! String
            
            if File1.isEmpty == false
            {
                
                if File1.contains(".jpeg") || File1.contains(".jpg") == true || File1.contains(".png") == true
                {
                    cell.imageView?.kf.indicatorType = .activity
                    cell.imageView?.kf.setImage(with: URL(string: File1))
                }
                else
                {
                    
                    let Fileurl =  URL(string: File1)
                    cell.imageView?.kf.indicatorType = .activity
                    
                    self.getThumbnailImageFromVideoUrl(url: Fileurl!) { (thumbNailImage) in
                        
                        
                        cell.imageView!.image = thumbNailImage
                        
                        
                    }
                    
                    
                }
                
                
            }
            
        }
        
        
        
        //       cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.isHidden = true
        return cell
    }
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int)
    {
        var file:String?
        var mediatype:String?
        for i in 0..<arrMedia.count
        {
            if i == index
            {
                arrMedia[i].isSelectedIndex = true
            }
            else
            {
                arrMedia[i].isSelectedIndex = false
            }
        }
        mediatype = arrMedia[index].media_type!
        file = arrMedia[index].file!
        
        
        var images = [SKPhoto]()
        if mediatype == "image"
        {
            
            for i in arrMedia
            {
                
                if i.media_type == "image"
                {
                    let photo = SKPhoto.photoWithImageURL(i.file!)
                    photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
                    images.append(photo)
                }
                
            }
            let defaultAddressArr = self.arrMedia.filter({$0.isSelectedIndex == true})
            var Selindex:Int = 0
            for i in 0..<images.count
            {
                if defaultAddressArr[0].file == images[i].photoURL
                {
                    Selindex = i
                }
            }
            
            print("Images:\(images)")
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(Selindex)
            UIApplication.topViewController()?.present(browser, animated: true, completion: {})
            
        }
        else
        {
            let urlString = file
            let player = AVPlayer(url:URL(string: urlString!)!)
            
            playerController = AVPlayerViewController()
            playerController.player = player
            playerController.allowsPictureInPicturePlayback = true
            
            //            playerController.delegate = self
            
            playerController.player?.play()
            
            UIApplication.topViewController()!.present(playerController,animated:true,completion:nil)
        }
        
        /*
         if self.DataSetDict.count > 0
         {
         let Data1 = ((self.DataSetDict.value(forKey: "media") as! NSArray).object(at: index) as! NSDictionary)
         
         let File1 = Data1.value(forKey: "file") as! String
         
         if File1.isEmpty == false
         {
         
         if File1.contains(".jpeg") || File1.contains(".jpg") == true || File1.contains(".png") == true
         {
         if File1.isEmpty == false
         {
         let imgUrl = URL(string: (File1))
         
         let image = [LightboxImage(imageURL: imgUrl!)]
         let controller = LightboxController(images: image)
         controller.dynamicBackground = true
         UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
         
         }
         }
         else
         {
         let urlString = File1
         let player = AVPlayer(url:URL(string: urlString)!)
         playerController = AVPlayerViewController()
         playerController.player = player
         playerController.allowsPictureInPicturePlayback = true
         
         playerController.player?.play()
         
         UIApplication.topViewController()!.present(playerController,animated:true,completion:nil)
         }
         
         
         }
         
         
         }
         */
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
        
        let Data1 = ((self.DataSetDict.value(forKey: "media") as! NSArray).object(at: targetIndex) as! NSDictionary)
        self.btnPlay.isHidden = true
        
        let File1 = Data1.value(forKey: "file") as! String
        
        if File1.isEmpty == false
        {
            
            if File1.contains(".jpeg") || File1.contains(".jpg") == true || File1.contains(".png") == true
            {
                self.btnPlay.isHidden = true
                
            }
            else
            {
                self.btnPlay.isHidden = false
                
            }
        }
        else
        {
            self.btnPlay.isHidden = true
        }
        
    }
    
    
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int)
    {
        if let mediaType = arrMediaOne[index].media_type
        {
            if mediaType == "image"
            {
                self.btnPlay.isHidden = true
                print("Will Display Media Type :\(mediaType)")
                print("Will Display Current Index: \(index)")
                print("Will Dispaly Page Control Index: \(self.pageControl.currentPage)")
            }
            else
            {
                self.btnPlay.isHidden = false
                print("Will Dispaly Media Type :\(mediaType)")
                print("Will Dispaly Current Index: \(index)")
                print("Will Dispaly Page Control Index: \(self.pageControl.currentPage)")
            }
            
        }
        
        if self.DataSetDict.count > 0
        {
            let Data1 = ((self.DataSetDict.value(forKey: "media") as! NSArray).object(at: index) as! NSDictionary)
            
            let File1 = Data1.value(forKey: "file") as! String
            
            self.btnPlay.isHidden = true
            
            
            if File1.isEmpty == false
            {
                
                if File1.contains(".jpeg") || File1.contains(".jpg") == true || File1.contains(".png") == true
                {
                    self.btnPlay.isHidden = true
                }
                else
                {
                    
                    let Fileurl =  URL(string: File1)
                    
                    
                    self.getThumbnailImageFromVideoUrl(url: Fileurl!) { (thumbNailImage) in
                        self.btnPlay.isHidden = false
                        cell.imageView!.image = thumbNailImage
                        
                        
                    }
                    
                    
                }
                
                
            }
                
            else
            {
                self.btnPlay.isHidden = true
                
            }
            
        }
        else
        {
            self.btnPlay.isHidden = true
            
        }
        
    }
    
    
    
    //MARK:- OTHER FUNCTIONS
    
    
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
}


private extension FeedDataCellXIB {
    
    func createWebPhotos() -> [SKPhotoProtocol]
    {
        let FinalimageArray = NSMutableArray()
        FinalimageArray.add(self.Image_Zoom)
        return (0..<FinalimageArray.count).map { (i: Int) -> SKPhotoProtocol in
            
            let photo = SKPhoto.photoWithImageURL(self.Image_Zoom)
            photo.shouldCachePhotoURLImage = true
            return photo
            
        }
    }
 */
    
     public func numberOfItems(in pagerView: FSPagerView) -> Int
       {
        return self.arrMedia.count
       }
       
       public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
           let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
    //    self.pageControl.currentPage = index
        cell.textLabel?.isHidden = true
        
    //        cell.contentView.layer.shadowColor = UIColor.red.cgColor
    //    cell.l
             self.pageControl.currentPage = pagerView.currentIndex
        
            let Fileurl =  URL(string: arrMedia[index].file!)
            let mediaType = arrMedia[index].media_type!
    //    if mediaType == "image"
    //    {
    //               self.btnPlay.isHidden = true
    //               print("Cell for Row Media Type :\(mediaType)")
    //               print("Cell for Row Current Index: \(index)")
    //              print("Cell for Row Current Page Index: \(self.pageControl.currentPage)")
    //    }
    //    else
    //    {
    //                self.btnPlay.isHidden = false
    //                print("Cell for Row  Media Type :\(mediaType)")
    //                print("Cell for Row Current Index: \(index)")
    //                 print("Cell for Row Current Page Index: \(self.pageControl.currentPage)")
    //    }
               
            if mediaType == "video" || mediaType != "image"
            {
              //  cell.imageView?.setImage(UIImage(named: "PlaceHolderSquare")!)
                cell.imageView?.image = UIImage(named: "Artboard – 1")
                Utility.getThumbnailImageFromVideoUrl(url: Fileurl!) { (image) in
                guard image != nil else
                {
                    return
                }
                print("Cell for Row  Media Type :\(mediaType)")
                print("Cell for Row Current Index: \(index)")
                print("Cell for Row Current Page Index: \(self.pageControl.currentPage)")
                    
                    cell.imageView?.image = image!
                    
              //  cell.imageView?.setImage(image!)
    //            self.btnPlay.isHidden = false
                print("Btn play is Hidden:\(self.btnPlay.isHidden)")
                }

            }
            else
            {
                
                 cell.imageView?.sd_setImage(with: Fileurl, placeholderImage: UIImage(named: "Artboard – 1"))
    //             self.btnPlay.isHidden = true
                 print("Cell for Row  Media Type :\(mediaType)")
                print("Cell for Row Current Index: \(index)")
                print("Cell for Row Current Page Index: \(self.pageControl.currentPage)")
                 print("Btn play is Hidden:\(self.btnPlay.isHidden)")
            }
        
    //       cell.imageView?.image = UIImage(named: self.imageNames[index])
           cell.imageView?.contentMode = .scaleAspectFill
           cell.imageView?.clipsToBounds = true
           cell.textLabel?.text = index.description+index.description
           return cell
       }
        func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int)
        {
    //        pagerView.deselectItem(at: index, animated: true)
    //        pagerView.scrollToItem(at: index, animated: true)
            var file:String?
            var mediatype:String?
            for i in 0..<arrMedia.count
            {
                if i == index
                {
                    arrMedia[i].isSelectedIndex = true
                }
                else
                {
                    arrMedia[i].isSelectedIndex = false
                }
            }
            
    //         self.arrMedia.filter({$0.isSelectedIndex == true }).first?.isSelectedIndex = false
    //      self.arrMedia.filter({$0.isselected == true }).first?.isselected = false
    //        self.arrMedia.filter { (arrMedia) -> Bool in
    //            if arrMedia[index]
    //        }
            if isFromUserProfile == true
            {
                mediatype = userPostDataModel?.post_detail![index].media_type!
                file = userPostDataModel?.post_detail![index].file!
            }
            else
            {
                mediatype = dataModel?.media![index].media_type!
                file = dataModel?.media![index].file!
            }
            
            var images = [SKPhoto]()
            if mediatype == "image"
              {
               
               for i in arrMedia
               {
                
                if i.media_type == "image"
                {
                    let photo = SKPhoto.photoWithImageURL(i.file!)
                    photo.shouldCachePhotoURLImage = true // you can use image cache by true(NSCache)
                    images.append(photo)
                }
                
               }
                let defaultAddressArr = self.arrMedia.filter({$0.isSelectedIndex == true})
                var Selindex:Int = 0
                for i in 0..<images.count
                {
                    if defaultAddressArr[0].file == images[i].photoURL
                    {
                        Selindex = i
                    }
                }
              
                print("Images:\(images)")
                let browser = SKPhotoBrowser(photos: images)
                browser.initializePageIndex(Selindex)
                 UIApplication.topViewController()?.present(browser, animated: true, completion: {})

              }
              else
              {
                  let urlString = file
                  let player = AVPlayer(url:URL(string: urlString!)!)
                              
                    playerController = AVPlayerViewController()
                    playerController.player = player
                    playerController.allowsPictureInPicturePlayback = true
                              
                  //            playerController.delegate = self
                              
                              playerController.player?.play()
                              
                              UIApplication.topViewController()!.present(playerController,animated:true,completion:nil)
              }
        }
        
        
        func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
            self.pageControl.currentPage = targetIndex
            let mediaType = arrMedia[targetIndex].media_type!
            if mediaType == "image"
            {
                self.btnPlay.isHidden = true
            } else {
                self.btnPlay.isHidden = false
            }
            //        print("pagerViewWillEndDragging:\(pagerView.currentIndex)")
        }
    //    func pagerViewWillBeginDragging(_ pagerView: FSPagerView) {
    ////        print("Did Begin Dragging:\(pagerView.currentIndex)")
    //    }
        func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
            self.pageControl.currentPage = pagerView.currentIndex
    //         print("Did End Scroll Animation:\(pagerView.currentIndex)")
        }
        func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int)
        {
             let mediaType = arrMedia[index].media_type!
            print("Will Dispaly method called")
            if mediaType == "image"
            {
                self.btnPlay.isHidden = true
                print("Will Display Media Type :\(mediaType)")
                print("Will Display Current Index: \(index)")
                 print("Will Dispaly Page Control Index: \(self.pageControl.currentPage)")
            }
            else
            {
                 self.btnPlay.isHidden = false
                 print("Will Dispaly Media Type :\(mediaType)")
                 print("Will Dispaly Current Index: \(index)")
                print("Will Dispaly Page Control Index: \(self.pageControl.currentPage)")
            }
    //
        }
        func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
            print("Highlighted Index: \(index)")
            print("Highlighted MediaType: \(arrMedia[index].media_type!)")
        }
}

