//
//  ChatDetailVC.swift
//  Nexshop
//
//  Created by Mac on 08/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import GrowingTextView
import SwiftyJSON
import Alamofire
import QuickLook
import UserNotifications
import WebKit
import IQKeyboardManagerSwift
import Loaf
import UserNotifications


class ChatDetailVC: UIViewController, UITextViewDelegate,UNUserNotificationCenterDelegate{
    
    // MARK: - UIControlers Outlets
    @IBOutlet weak var viewCart: UIView!
    @IBOutlet weak var txtMessage: GrowingTextView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblviewChat: UITableView!
    
    // MARK: - Variables
    
    var objViewModel = SocialViewModel()
    let objv = SocialViewModel()
    var dicData:NSDictionary?
    var dicUserData:NSDictionary?
    let loginUserID = appDelegate.get_user_Data(Key: "id")
    var loginSocialID = 0
    var isBlock = 0
    var blockMessage = ""
    var BlockUserID = 0
    var arrChat:NSArray?
    var dicChat:NSDictionary?
    var RecieverID = 0
    var AdminChatMessages = NSMutableArray()
    var documentPicker: UIDocumentPickerViewController?
    var senderImageUrl = ""
    var RecieverImageUrl = ""
    var DocUrls:[URL]?
    var OtherUserName = ""
    var ToUserID = 0
    lazy var previewItem = NSURL()
    var BottomViewYFrame:CGFloat?
    var Primarylang = "en"
    var HeaderName = String()
    var Product_id = String()
    var isFrom = false
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblHeader.text = OtherUserName
        
        self.hideKeyboardWhenTappedAround()
        
        
        self.tblviewChat.register(SenderUserCellXIB.self, forCellReuseIdentifier: "SenderUserCellXIB")
        self.tblviewChat.register(UINib(nibName: "SenderUserCellXIB", bundle: nil), forCellReuseIdentifier: "SenderUserCellXIB")
        
        self.tblviewChat.register(ReceiverMessageCellXIB.self, forCellReuseIdentifier: "ReceiverMessageCellXIB")
        self.tblviewChat.register(UINib(nibName: "ReceiverMessageCellXIB", bundle: nil), forCellReuseIdentifier: "ReceiverMessageCellXIB")
        
        self.tblviewChat.isHidden = true
        
        self.ChatHistory()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        appDelObj.Primarylang = "en-US"
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        UNUserNotificationCenter.current().delegate = self

    }
    
    
    // MARK: - Other Functions
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func ChatHistory()
    {
        print(ToUserID)
        
        appDelegate.ShowProgess()
        
        objViewModel.RoomHistory(userID: ToUserID, limit: 100, offset: 0, product_id: Int(self.Product_id)!) { (status, message, dic) in
            if status
            {
                self.AdminChatMessages = []
                self.arrChat = []
                guard dic!.count > 0 else {
                    return
                }
                self.dicData = dic
                print(dic)
                
                if self.RecieverImageUrl.isEmpty == true
                {
                    if dic!.count > 0
                    {
                        let users_data = dic?.value(forKey: "users_data") as! NSDictionary
                        let created_user_data = users_data.value(forKey: "created_user_data") as! NSDictionary
                        let other_user_data = users_data.value(forKey: "other_user_data") as! NSDictionary
                        
                        
                        if created_user_data.count > 0
                        {
                            var myid = created_user_data.value(forKey: "id") as! Int
                            
                            
                            
                            let id1 = Int(appDelegate.get_user_Data(Key: "id"))
                            print(myid)
                            print(id1)
                            if id1 != myid
                            {
                                if other_user_data.count > 0
                                {
                                    self.RecieverImageUrl = other_user_data.value(forKey: "avatar") as! String
                                    print(self.RecieverImageUrl)
                                    
                                    
                                }
                            }
                            
                            
                        }
                        
                        
                    }
                }
                
                self.RecieverID = Int(self.dicData?.value(forKey: "receiver_id") as! String)!
                self.arrChat = self.dicData?.value(forKey: "chat") as? NSArray
                self.SetUI()
                guard self.arrChat!.count > 0 else
                {
                    
                    return
                }
                
                //                self.arrChat?.reversed()
                //                self.arrChat?.addingObjects(from: <#T##[Any]#>)
                
            }
            else
            {
                appDelegate.HideProgress()
                Loaf(message, state: .error, sender: self).show()
                return
            }
            
        }
    }
    
    func SetUI()
    {
        
        self.lblHeader.text = OtherUserName
        
        var FirstNsdict = NSDictionary()
        var FirstNsmutabledict = NSMutableDictionary()
        for i in 0..<self.arrChat!.count
        {
            
            let item = self.arrChat![i] as! NSDictionary
            FirstNsdict = item
            FirstNsmutabledict = FirstNsdict.mutableCopy() as! NSMutableDictionary
            let selectedData = Data()
            FirstNsmutabledict.setValue(selectedData, forKey: "data")
            FirstNsmutabledict.setValue("", forKey: "type")
            FirstNsmutabledict.setValue(false, forKey: "is_local")
            FirstNsmutabledict.setValue("", forKey: "is_local_path")
            FirstNsmutabledict.setValue("", forKey: "file_name")
            FirstNsmutabledict.setValue("", forKey: "file_size")
            self.AdminChatMessages.add(FirstNsmutabledict)
            
        }
        
        print(self.AdminChatMessages.count)
        
        
        guard self.arrChat!.count > 0 else
        {
            appDelObj.HideProgress()
            return
        }
        
        var reversedArray = NSArray()
        
        reversedArray =  NSMutableArray(array:self.AdminChatMessages.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
        
        
        
        self.AdminChatMessages = NSMutableArray()
        self.AdminChatMessages = reversedArray.mutableCopy() as! NSMutableArray
        
        self.tblviewChat.reloadData()
        DispatchQueue.main.async
            {
                let indexPath = IndexPath(row: self.AdminChatMessages.count-1, section: 0)
                self.tblviewChat.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        
        
        print(self.AdminChatMessages)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
        {
            appDelegate.HideProgress()
            self.tblviewChat.isHidden = false

        }
        
    }
    
    
    
    // MARK: - UIButton Actions
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        if self.isFrom == true
        {
            appDelObj.SetHomeRoot()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    @IBAction func btnHandlerSend(_ sender: Any)
    {
        
        
        if self.txtMessage.text.isEmpty == true
        {
            Loaf("Please enter message", state: .error, sender: self).show()
            return
        }
        self.view.endEditing(true)
//        var dCreatedDate = String()
//        let selectedData = Data()
//        var vMessage = ""
//        var to_user_id = Int()
//        var chat_room_id = Int()
//        vMessage = self.txtMessage.text!
//
//        self.txtMessage.text = ""
//
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let result = formatter.string(from: date)
//
//        dCreatedDate = result
//        if  self.AdminChatMessages.count <= 0
//        {
//            chat_room_id = 0
//            to_user_id = self.ToUserID
//
//        }
//        else
//        {
//            let dicData = self.AdminChatMessages.object(at: 0) as! NSDictionary
//
//            chat_room_id = Int(dicData.value(forKey: "chat_room_id") as! String)!
//
//            if self.loginUserID != "\(dicData.value(forKey: "to_user_id") as! String)"
//            {
//                to_user_id = Int(dicData.value(forKey: "to_user_id") as! String)!
//            }
//            else
//            {
//                to_user_id = Int(dicData.value(forKey: "from_user_id") as! String)!
//            }
//        }
//        let NewDict = NSMutableDictionary()
//
//
//
//        NewDict.setValue(chat_room_id, forKey: "chat_room_id")
//        NewDict.setValue(dCreatedDate, forKey: "created_at")
//        NewDict.setValue(selectedData, forKey: "data")
//        NewDict.setValue("", forKey: "file")
//        NewDict.setValue("", forKey: "file_data")
//        NewDict.setValue(loginUserID, forKey: "from_user_id")
//        NewDict.setValue("", forKey: "id")
//        NewDict.setValue(false, forKey: "is_delivered")
//        NewDict.setValue(false, forKey: "is_local")
//        NewDict.setValue("is_local_path", forKey: "is_local_path")
//        NewDict.setValue(false, forKey: "is_read")
//        NewDict.setValue(vMessage, forKey: "message")
//        NewDict.setValue(to_user_id, forKey: "to_user_id")
//        NewDict.setValue("message", forKey: "type")
//        NewDict.setValue(dCreatedDate, forKey: "updated_at")
//        NewDict.setValue("", forKey: "file_name")
//        NewDict.setValue("", forKey: "file_size")
//
//        var FinalNewdict = NSDictionary()
//        FinalNewdict = NewDict
//        self.AdminChatMessages.add(FinalNewdict)
//        self.tblviewChat.reloadData()
//
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: self.AdminChatMessages.count-1, section: 0)
//            self.tblviewChat.scrollToRow(at: indexPath, at: .bottom, animated: false)
//        }
        var Paramteres = ["to_user_id":ToUserID,"message":self.txtMessage.text!,"type":"social","product_id":self.Product_id] as [String : Any]
        let api =  WebURL.chat
        print(api)
        print(Paramteres)
        appDelegate.ShowProgess()
        APIMangagerClass.callPostWithHeader(url: URL(string: api)!, params: Paramteres, finish: self.ReviewAdded )
        //        self.a
    }
    
    //MARK:- OTHER FUNCTIONS
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        
        let data_item = notification.request.content.userInfo as NSDictionary
        print(data_item)
        
        if data_item.value(forKey: "push_type") as! String == "1"
        {
            
            if CommonClass.sharedInstance.isReachable() == false
            {
                Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                return
            }
            
            if data_item.value(forKey: "object_id") as! String == self.Product_id
            {
                self.tblviewChat.isHidden = true
                       
                       self.ChatHistory()
            }
            else
            {
                completionHandler([.alert, .sound,])

            }
            
            
        }
            
        else
        {
            completionHandler([.alert, .sound,])
        }
    }
    
    
    // MARK: - UICollectionView Delegate Methods
    
    // MARK: - WEB API Methods
    
    func ReviewAdded (message:String, data:Data?) -> Void
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
                            
                            DispatchQueue.main.async
                                {
                                    
                                    print(dict)
                                    self.txtMessage.text = ""
                                    self.tblviewChat.isHidden = true
                                    self.view.endEditing(true)
                                    self.ChatHistory()
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
    
}

// MARK: - UITableView Delegate Methods



extension ChatDetailVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.AdminChatMessages.count != 0
        {
            return AdminChatMessages.count
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //        let file = ((self.AdminChatMessages.object(at: indexPath.row) as! NSDictionary).value(forKey: "file") as! String)
        let MessageData = (AdminChatMessages.object(at: indexPath.row) as! NSDictionary)
        print(MessageData)
        
        
        if Int(loginUserID) != Int((MessageData.value(forKey: "from_user_id") as! String))
        {
            
            let cell = self.tblviewChat.dequeueReusableCell(withIdentifier: "ReceiverMessageCellXIB") as! ReceiverMessageCellXIB
            
            cell.lblMessage.text = MessageData.value(forKey: "message") as? String
            //cell.lblDate.text = MessageData.value(forKey: "updated_at") as? String
            
            cell.lblDate.text = CommonClass.sharedInstance.convertDateFormatter3(date: (MessageData.value(forKey: "updated_at") as? String)!)
            
            if RecieverImageUrl.isEmpty == true
            {
                
            }
            
            cell.imgviewUser.kf.indicatorType = .activity
            cell.imgviewUser.kf.setImage(with: URL(string: RecieverImageUrl))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
            {
                CommonClass.sharedInstance.roundCorners(view: cell.viewBackground, corners: [.topLeft, .topRight, .bottomLeft], radius: 10)
                
                cell.selectionStyle = .none
            }
            return cell
            
            
            
        }
        else
        {
            let cell = self.tblviewChat.dequeueReusableCell(withIdentifier: "SenderUserCellXIB") as! SenderUserCellXIB
            cell.lblMessage.text = MessageData.value(forKey: "message") as? String
            //  cell.lblTime.text = MessageData.value(forKey: "updated_at") as? String
            
            cell.lblTime.text = CommonClass.sharedInstance.convertDateFormatter3(date: (MessageData.value(forKey: "updated_at") as? String)!)
            
            cell.imgviewUser.isHidden = false
            // cell.imgviewUser.sd_setImage(with:URL(string:RecieverImageUrl), completed: nil)
            
            cell.imgviewUser.kf.indicatorType = .activity
            cell.imgviewUser.kf.setImage(with: URL(string: "\(appDelegate.get_user_Data(Key: "avatar") as! String)"))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                CommonClass.sharedInstance.roundCorners(view: cell.viewBackground, corners: [.topLeft, .topRight, .bottomLeft], radius: 10)
                
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}


extension UITextView {
    
    private func getKeyboardLanguage() -> String? {
        return appDelObj.Primarylang // here you can choose keyboard any way you need
    }
    
    open override var textInputMode: UITextInputMode? {
        if let language = getKeyboardLanguage() {
            for tim in UITextInputMode.activeInputModes {
                if tim.primaryLanguage!.contains(language) {
                    return tim
                }
            }
        }
        return super.textInputMode
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //view.endEditing(true)
    }
}
