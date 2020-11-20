//
//  RateAndReviewProductVC.swift
//  Nexshop
//
//  Created by Mac on 06/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import BottomPopup
import Cosmos
import SwiftyJSON
import Alamofire
import Loaf



protocol UpdateOrder {
    func UpdateOrder(isReload:Bool)
    
}
class RateAndReviewProductVC: BottomPopupViewController,BottomPopupDelegate{
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var viewRatings: CosmosView!
    @IBOutlet weak var txtReview: ACFloatingTextfield!
    
    
    //MARK:- VAIRABLES
    var height: CGFloat = CGFloat()
    var topCornerRadius: CGFloat = 0
    var presentDuration: Double = 1.5
    var dismissDuration: Double = 1.5
    let kHeightMaxValue: CGFloat = 600
    let kTopCornerRadiusMaxValue: CGFloat = 35
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    var type = String()
    var Order_id = String()
    var rating = String()
    var comment = String()
    var file = Data()
    var OrderDetailDict = NSMutableDictionary()
    var imageData = Data()
    let picker123 = UIImagePickerController()
    var videoURL : NSURL?
    var product_id = String()
    var isVideo = false
    var OrderReviewDelegate:UpdateOrder?
    var thumbnailImg = ""
    var booking_type = String()
    
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewRatings.rating = 1.0
        
        viewRatings.didTouchCosmos = didTouchCosmos
        viewRatings.didFinishTouchingCosmos = didFinishTouchingCosmos
        
    }
    
    
    
    //MARK:- ALL FUNCTIONS
    
    
    
    func ReviewAdded (message:String, data:Data?) -> Void
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
                                
                                if dict["status"].int == 1
                                {
                                    self.dismiss(animated: true, completion: nil)
                                    Loaf(dict["message"].string!, state: .success, sender: self).show()
                                    self.OrderReviewDelegate?.UpdateOrder(isReload: true)
                                    
                                }
                                else
                                {
                                    
                                    Loaf(dict["message"].string!, state: .error, sender: self).show()
                                    appDelObj.HideProgress()
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
    
    
    private func didTouchCosmos(_ rating: Double) {
        print(rating)
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
        print(rating)
    }
    
    
    
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnTitleSubmit(_ sender: Any) {
        var passUrl = String()
        
        passUrl = WebURL.add_reviews
        
        
        
        if self.txtReview.text!.isEmpty == true
        {
        
            Loaf("Please enter description", state: .error, sender: self).show()
            return
        }
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelObj.ShowProgess()
        if imageData.count == 0
        {
            let Paramteres = ["type":self.type,"id":self.product_id,"rating":"\(self.viewRatings.rating)","comment":self.txtReview.text!]
            
            print(Paramteres)
            
            
            APIMangagerClass.callPostWithHeader(url: URL(string: passUrl)!, params: Paramteres, finish: self.ReviewAdded )
            
            
        }
        
        
        
        
    }
}
