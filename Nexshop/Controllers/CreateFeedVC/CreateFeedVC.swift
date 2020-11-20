//
//  CreateFeedVC.swift
//  Nexshop
//
//  Created by Mac on 06/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import BSImagePicker
import Gallery
import MobileCoreServices
import AVKit
import GrowingTextView
import Loaf

class SocialPostMediaModel{
    var MediaData:Data? = nil
    var MediaType:String = ""
    
    init(MedData:Data,MedType:String) {
        self.MediaData = MedData
        self.MediaType = MedType
    }
}
class PostMediaModel
{
    var MediaData:Data? = nil
    var MediaType:String = ""
    var MediaImage:UIImage? = nil
    var MediaID:String = ""
    
    init(MedData:Data,MedType:String,MedID:String,MedImage:UIImage) {
        self.MediaData = MedData
        self.MediaType = MedType
        self.MediaID = MedID
        self.MediaImage = MedImage
    }
    
}



class CreateFeedVC: UIViewController,GrowingTextViewDelegate{
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var lblProgress: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var CollectionviewHome: UICollectionView!
    @IBOutlet weak var txtViewPost: GrowingTextView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnTitlePost: MyRoundedButton!
    
    
    @IBOutlet var viewPopup: UIView!
    
    
    //MARK:- VARIABLES
    
    var gallery: GalleryController!
    var arrImages = [UIImage]()
    
    var selectedCategoryID  = 0
    var selectedCategoryName = ""
    let editor: VideoEditing = VideoEditor()
    private var compression: Compression?
    private var compressedPath: URL?
    var arrMedia = [SocialPostMediaModel]()
    var arrPostMedia = [PostMediaModel]()
    var APIViewModel = SocialViewModel()
    var CheckaddPost = false
    var isProfileEdit = false
    let picker123 = UIImagePickerController()
    
    var postData:SocialUserPostModel?
    
    var arrDeleteIDs = [String]()
    
    
    //MARK:- VIEW DIDLOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        
        picker123.delegate = self
        
        imgviewUser.layer.cornerRadius = imgviewUser.frame.size.height / 2
        if let imgUrl = URL(string: (appDelegate.get_user_Data(Key: "avatar") as! String))
        {
            self.imgviewUser.kf.indicatorType = .activity
            self.imgviewUser.kf.setImage(with: URL(string: (appDelegate.get_user_Data(Key: "avatar") as! String)))
            
        }
        lblUserName.text = "\(appDelegate.get_user_Data(Key: "name") as! String)"
        self.PostView(IsEnable: false)
        
        self.configure()
        
        
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
        images[0].resolve { (image) in
            self.arrImages.append(image!)
            self.arrMedia.append(SocialPostMediaModel(MedData: (image?.jpegData(compressionQuality: 0.7))!, MedType: "image"))
            self.PostView(IsEnable:true)
            self.CollectionviewHome.reloadData()
        }
        
        print(" Image count\(arrImages.count)")
        
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video)
    {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
        
        
        self.viewPopup.frame = self.view.frame
        self.view.addSubview(self.viewPopup)
        
        editor.edit(video: video) { (editedVideo: Video?, tempPath: URL?) in
            DispatchQueue.main.async {
                if let tempPath = tempPath
                {
                    let VideoSize = Double(tempPath.fileSizeInMB().dropLast(2).trimmingCharacters(in: .whitespaces))
                    
                    guard VideoSize?.isLessThanOrEqualTo(50.0) == true else
                    {
                        
                        self.viewPopup.removeFromSuperview()
                        
                        
                        self.viewPopup.removeFromSuperview()
                        
                        
                        Loaf("Video should be less than 50 MB", state: .error, sender: self).show()
                        
                        return
                    }
                    
                    self.CompressVideo(videoUrl: tempPath)
                }
            }
        }
    }
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    
    func PostView(IsEnable:Bool)
    {
        if IsEnable
        {
            
            btnTitlePost.isEnabled = true
        }
        else
        {
            
            btnTitlePost.isEnabled = true
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configure(){
        self.CollectionviewHome.register(UINib(nibName: "PhotoVideoCellPost", bundle: nil), forCellWithReuseIdentifier: "PhotoVideoCellPost")
        Config.VideoEditor.maximumDuration = 600
        Config.Camera.imageLimit = 1
        guard postData?.post_detail == nil else
        {
            appDelegate.ShowProgess()
            setEditPostData()
            
            return
        }
        CollectionviewHome.reloadData()
    }
    
    func setEditPostData()
    {
        appDelegate.ShowProgess()
        self.isProfileEdit = true
        self.lblTitle.text = "Edit Post"
        
        self.PostView(IsEnable:true)
        if (postData?.description!.isEmpty)!
        {
            txtViewPost.text = "What are you up-to?"
            txtViewPost.textColor = UIColor.lightGray
        }
        else
        {
            txtViewPost.text = postData?.description!
            txtViewPost.textColor = UIColor.black
        }
        
        for i in postData!.post_detail!
        {
            if i.media_type == "image"
            {
                if let data = try? Data(contentsOf:  URL(string: i.file!)!)
                {
                    let image: UIImage = UIImage(data: data)!
                    let imageID = "\(i.id ?? 0)"
                    
                    self.arrMedia.append(SocialPostMediaModel(MedData: (image.jpegData(compressionQuality: 0.7))!, MedType: "image"))
                    self.arrPostMedia.append(PostMediaModel(MedData: (image.jpegData(compressionQuality: 0.7))!, MedType: "image", MedID: imageID, MedImage: image))
                    
                    
                    self.CollectionviewHome.reloadData()
                }
            }
            else
            {
                let imageID = "\(i.id ?? 0)"
                Utility.getThumbnailImageFromVideoUrl(url: URL(string: i.file!)!)
                { (image) in
                    print(image)
                    
                    if image != nil
                    {
                        self.arrPostMedia.append(PostMediaModel(MedData: (image!.jpegData(compressionQuality: 0.7))!, MedType: "video", MedID: imageID, MedImage: image!))
                                           
                                           self.CollectionviewHome.reloadData()
                    }
                    
                   
                }
                
                
            }
        }
        
        
        appDelegate.HideProgress()
    }
    
    func CompressVideo(videoUrl:URL)
    {
        let videoToCompress = videoUrl
        let destinationPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressed.mp4")
        try? FileManager.default.removeItem(at: destinationPath)
        let startingPoint = Date()
        let videoCompressor = LightCompressor()
        
        self.compression = videoCompressor.compressVideo(source: videoToCompress,
                                                         destination: destinationPath as URL,quality: .high,isMinBitRateEnabled: true,keepOriginalResolution: false,progressQueue: .main,progressHandler:
            { progress in
                DispatchQueue.main.async { [unowned self] in
                    self.ProgressBar.progress = Float(progress.fractionCompleted)
                    self.lblProgress.text = "Please wait for your video is compressing \(String(format: "%.0f", progress.fractionCompleted * 100))%"
                    print("Progress \(Float(progress.fractionCompleted))")
                    print("\(String(format: "%.0f", progress.fractionCompleted * 100))%")
                }},
                                                         
                                                         completion: {[weak self] result in
                                                            guard let `self` = self else { return }
                                                            
                                                            switch result {
                                                                
                                                            case .onSuccess(let path):
                                                                self.compressedPath = path
                                                                
                                                                DispatchQueue.main.async { [unowned self] in
                                                                    
                                                                    self.viewPopup.removeFromSuperview()
                                                                    
                                                                    
                                                                    Utility.getThumbnailImageFromVideoUrl(url: path) { (image) in
                                                                        self.arrImages.append(image!)
                                                                        self.CollectionviewHome.reloadData()
                                                                    }
                                                                    print("Size after compression: \(path.fileSizeInMB())")
                                                                    print("Duration: \(String(format: "%.2f", startingPoint.timeIntervalSinceNow * -1)) seconds")
                                                                    do {
                                                                        let data =  try Data(contentsOf: path)
                                                                        appDelegate.HideProgress()
                                                                        self.arrMedia.append(SocialPostMediaModel(MedData: data, MedType: "video"))
                                                                        Utility.getThumbnailImageFromVideoUrl(url: path) { (image) in
                                                                            self.arrPostMedia.append(PostMediaModel(MedData: data, MedType: "video", MedID: "", MedImage: image!))
                                                                            self.CollectionviewHome.reloadData()
                                                                        }
                                                                        
                                                                    }
                                                                    catch
                                                                    {
                                                                        print(error)
                                                                    }
                                                                    
                                                                }
                                                                
                                                            case .onStart:
                                                                print("Start")
                                                                self.viewPopup.isHidden = false
                                                                
                                                            case .onFailure(let error):
                                                                self.viewPopup.removeFromSuperview()
                                                                
                                                                
                                                                
                                                                Utility.getThumbnailImageFromVideoUrl(url: videoUrl) { (image) in
                                                                    self.arrImages.append(image!)
                                                                    self.CollectionviewHome.reloadData()
                                                                }
                                                                do {
                                                                    let data =  try Data(contentsOf: videoUrl)
                                                                    self.arrMedia.append(SocialPostMediaModel(MedData: data, MedType: "video"))
                                                                    Utility.getThumbnailImageFromVideoUrl(url: videoUrl) { (image) in
                                                                        self.arrPostMedia.append(PostMediaModel(MedData: data, MedType: "video", MedID: "", MedImage: image!))
                                                                        self.CollectionviewHome.reloadData()
                                                                    }
                                                                    
                                                                }
                                                                catch
                                                                {
                                                                    print(error)
                                                                }
                                                                print(error.localizedDescription.asNumberString)
                                                                
                                                            case .onCancelled:
                                                                print("---------------------------")
                                                                print("Cancelled")
                                                                
                                                            }
        })
        
    }
    func openCameraVideo()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker123.mediaTypes = ["public.movie"]
            picker123.mediaTypes = [kUTTypeMovie as String]
            if #available(iOS 11.0, *) {
                picker123.videoExportPreset = AVAssetExportPresetPassthrough
            }
            picker123.sourceType = UIImagePickerController.SourceType.camera
            picker123.videoQuality = .typeMedium
            self .present(picker123, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    
    func openGallaryVideo()
    {
        picker123.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker123.mediaTypes = ["public.movie"]
        picker123.mediaTypes = [kUTTypeMovie as String]
        picker123.videoQuality = .typeMedium
        picker123.sourceType = .photoLibrary
        picker123.delegate = self
        self.present(picker123, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker123.mediaTypes = ["public.image"]
            picker123.sourceType = UIImagePickerController.SourceType.camera
            self .present(picker123, animated: true, completion: nil)
        }
        else
        {
            openGallaryVideo()
        }
    }
    
    
    func openGallary()
    {
        picker123.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker123.mediaTypes = ["public.image"]
        picker123.sourceType = .photoLibrary
        picker123.delegate = self
        self.present(picker123, animated: true, completion: nil)
    }
    
    @objc func DeleteImages(sender:UIButton)
    {
        //        self.arrImages.remove(at: sender.tag)
        //        self.arrMedia.remove(at: sender.tag)
        if arrPostMedia[sender.tag].MediaID.isEmpty == false
        {
            print(arrPostMedia[sender.tag].MediaID)
            self.arrDeleteIDs.append(arrPostMedia[sender.tag].MediaID)
            
        }
        print("Array of Strings\(arrDeleteIDs)")
        self.arrPostMedia.remove(at: sender.tag)
        
        self.CollectionviewHome.reloadData()
    }
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerSelectimage(_ sender: Any) {
        
        //        gallery = GalleryController()
        //        gallery.delegate = self
        //        present(gallery, animated: true, completion: nil)
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let imagealbums = UIAlertAction(title: "Choose Photo", style: .default)
        { _ in
            
            self.openGallary()
        }
        actionSheetControllerIOS8.addAction(imagealbums)
        
        let selectfromcamera = UIAlertAction(title: "Take Photo", style: .default)
        { _ in
            
            self.openCamera()
        }
        actionSheetControllerIOS8.addAction(selectfromcamera)
        
        
        let selectvideofromcamera = UIAlertAction(title: "Record Video", style: .default)
        { _ in
            
            self.openCameraVideo()
        }
        
        let selectvideofromgallery = UIAlertAction(title: "Choose Video", style: .default)
        { _ in
            
            self.openGallaryVideo()
        }
        
        actionSheetControllerIOS8.addAction(selectvideofromgallery)
        actionSheetControllerIOS8.addAction(selectvideofromcamera)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnHandlerDismissCompress(_ sender: Any) {
    }
    
    
    @IBAction func btnHandlerCreatePost(_ sender: Any)
    {
        
        guard self.arrPostMedia.count > 0 else
        {
            
            Loaf("Add Photo/Video", state: .error, sender: self).show()
            return
        }
        let id = "\(selectedCategoryID)"
        
        var txtViewString = ""
        if txtViewPost.text == "What are you up-to?" || txtViewPost.text.isEmpty == true
        {
            Loaf("Please enter description", state: .error, sender: self).show()
            return
        }
        else
        {
            txtViewString = txtViewPost.text
        }
        
        if  CommonClass.sharedInstance.isReachable() == false
               {
                   Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                   return
               }
        appDelegate.ShowProgess()
        guard isProfileEdit == false else
        {
            
            
            let postID = "\(postData!.id ?? 0)"
            let ids = arrDeleteIDs.joined(separator: ",")
            print(ids)
            
            arrPostMedia = arrPostMedia.filter({$0.MediaID.isEmpty == true})
            
            APIViewModel.EditPost(DeleteID: ids, PostID:postID, categoryID: id, Desc:txtViewString , arrMedia: arrPostMedia) { (status, message) in
                guard status == true else
                {
                    
                    appDelegate.HideProgress()
                    Loaf(message, state: .error, sender: self).show()
                    return
                }
                
                appDelegate.HideProgress()
                let nc = NotificationName.editPost
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: nc), object: nil)
                self.navigationController?.popViewController(animated: true)

                Loaf(message, state: .success, sender: self).show()
                self.CheckaddPost = true
                
            }
            return
        }
        APIViewModel.AddPost(categoryID: id, Desc: txtViewString, arrMedia: arrPostMedia) { (status, message) in
            
            guard status == true else
            {
                appDelegate.HideProgress()
                Loaf(message, state: .error, sender: self).show()
                return
            }
            appDelegate.HideProgress()
            let nc = NotificationName.addPost
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: nc), object: nil)
            self.navigationController?.popViewController(animated: true)

            Loaf(message, state: .success, sender: self).show()
            self.CheckaddPost = true
            
        }
    }
    
    
    
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    //MARK:- IMAGE PICKER METHOD
    
    
    
}

extension CreateFeedVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let type:String = info[UIImagePickerController.InfoKey.mediaType] as! String
        print(type)
        
        guard type == (kUTTypeMovie as String) else
        {
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let imageData = selectedImage.jpegData(compressionQuality: 0.7)!
            self.arrPostMedia.append(PostMediaModel(MedData: imageData, MedType: "image", MedID: "", MedImage: selectedImage))
            self.CollectionviewHome.reloadData()
            dismiss(animated: true, completion: nil)
            return
        }
        let videoToCompress = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaURL")] as? URL
        guard videoToCompress != nil else
        {
            
            Loaf("Something went wrong please pick again", state: .error, sender: self).show()
            
            return
        }
        dismiss(animated: true, completion: nil)
        let VideoSize = Double(videoToCompress!.fileSizeInMB().dropLast(2).trimmingCharacters(in: .whitespaces))
        guard VideoSize?.isLessThanOrEqualTo(50.0) == true else
        {
            
            //self.viewPopUp.isHidden = true
            
            
            Loaf("Video should be less than 50 MB", state: .error, sender: self).show()
            
            return
        }
        do {
            let data =  try Data(contentsOf: videoToCompress!)
            appDelegate.HideProgress()
            self.arrMedia.append(SocialPostMediaModel(MedData: data, MedType: "video"))
            Utility.getThumbnailImageFromVideoUrl(url: videoToCompress!) { (image) in
                self.arrPostMedia.append(PostMediaModel(MedData: data, MedType: "video", MedID: "", MedImage: image!))
                self.CollectionviewHome.reloadData()
            }
            
        }
        catch
        {
            print(error)
        }
        //        self.CompressVideo(videoUrl: videoToCompress!)
    }
}

extension URL {
    func fileSizeInMB() -> String {
        let p = self.path
        
        let attr = try? FileManager.default.attributesOfItem(atPath: p)
        
        if let attr = attr {
            let fileSize = Float(attr[FileAttributeKey.size] as! UInt64) / (1024.0 * 1024.0)
            
            return String(format: "%.2f MB", fileSize)
        } else {
            return "Failed to get size"
        }
    }
}


//MARK::- COLLECTIONVIEW  METHODS

extension CreateFeedVC : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if arrPostMedia.count == 0
        {
            return 0
        }
        else if arrPostMedia.count == 1
        {
            return 1
        }
        else
        {
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        if arrPostMedia.count == 0
        {
            return 0
        }
        
        if arrPostMedia.count == 1
        {
            if section == 0
            {
                return 1
            }
            else
            {
                return 0
            }
        }
        else
        {
            if section == 0
            {
                return 1
            }
            else
            {
                return arrPostMedia.count - 1
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.arrPostMedia.count == 0
        {
            return UICollectionViewCell()
        }
        else if self.arrPostMedia.count == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoVideoCellPost", for: indexPath) as! PhotoVideoCellPost
            
            DispatchQueue.main.async
                {
                    
                    let path = UIBezierPath(roundedRect: cell.imgviewMedia.bounds, byRoundingCorners:  [.bottomLeft,.topRight,.bottomRight], cornerRadii: CGSize(width: 8, height: 8))
                    let mask = CAShapeLayer()
                    mask.path = path.cgPath
                    cell.imgviewMedia.layer.mask = mask
                    
            }
            cell.imgviewMedia.image = self.arrPostMedia[indexPath.item].MediaImage!
            
            
            
            
            //            cell.imgPost.setImage(arrImages[indexPath.item])
            cell.btnRemove.tag = indexPath.item
            cell.btnRemove.addTarget(self, action: #selector(DeleteImages(sender:)), for: .touchUpInside)
            return cell
            
        }
        else
        {
            if indexPath.section == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoVideoCellPost", for: indexPath) as! PhotoVideoCellPost
                
                DispatchQueue.main.async
                    {
                        
                        let path = UIBezierPath(roundedRect: cell.imgviewMedia.bounds, byRoundingCorners:  [.bottomLeft,.topRight,.bottomRight], cornerRadii: CGSize(width: 8, height: 8))
                        let mask = CAShapeLayer()
                        mask.path = path.cgPath
                        cell.imgviewMedia.layer.mask = mask
                        
                }
                // Initialization code
                
                cell.imgviewMedia.image = self.arrPostMedia[0].MediaImage!
                
                
                //cell.imgviewMedia.setImage(self.arrPostMedia[0].MediaImage!)
                //                cell.imgPost.setImage(arrImages[0])
                cell.btnRemove.tag = 0
                cell.btnRemove.addTarget(self, action: #selector(DeleteImages(sender:)), for: .touchUpInside)
                return cell
                
            }
            else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoVideoCellPost", for: indexPath) as! PhotoVideoCellPost
                
                DispatchQueue.main.async
                    {
                        
                        let path = UIBezierPath(roundedRect: cell.imgviewMedia.bounds, byRoundingCorners:  [.bottomLeft,.topRight,.bottomRight], cornerRadii: CGSize(width: 8, height: 8))
                        let mask = CAShapeLayer()
                        mask.path = path.cgPath
                        cell.imgviewMedia.layer.mask = mask
                        
                }
                
                
                
                
                cell.imgviewMedia.image = self.arrPostMedia[indexPath.item + 1].MediaImage!
                
                //                cell.imgPost.setImage(arrImages[indexPath.item + 1 ])
                cell.btnRemove.tag = indexPath.item + 1
                cell.btnRemove.addTarget(self, action: #selector(DeleteImages(sender:)), for: .touchUpInside)
                return cell
                
            }
        }
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.arrPostMedia.count == 0
        {
            return CGSize(width: 0, height:0)
        }
        else if self.arrPostMedia.count == 1
        {
            return CGSize(width:  self.CollectionviewHome.frame.width, height:200)
            
        }
        else
        {
            if indexPath.section == 0 {
                
                return CGSize(width: self.CollectionviewHome.frame.width, height:200)
            }
            else{
                return CGSize(width: 100, height: 100)
            }
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
