//
//  CommentListVC.swift
//  Nexshop
//
//  Created by Mac on 09/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import GrowingTextView
import Loaf
import SwiftyJSON

protocol CommentUpdate
{
    func CommentNew(isUpdateNew:Bool)
    

}

class CommentListVC: UIViewController {
    
    
    // MARK: - UIControlers Outlets
    
    @IBOutlet weak var txtComment: GrowingTextView!
    @IBOutlet weak var tblviewMain: UITableView!
    @IBOutlet weak var viewMain: UIView!
    
    // MARK: - Variables
    var isCommentid = String()
    var Comments = [CommentModel]()
    var CommentAdd:CommentUpdate?
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblviewMain.estimatedRowHeight = 330
        self.tblviewMain.rowHeight = UITableView.automaticDimension
        
        self.tblviewMain.isHidden = true
        
        SetUI()
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            appDelegate.ShowProgess()
            
            let Temp1 = WebURL.get_comment_list + "?" + "post_id=" + "\(self.isCommentid)" +  "&limit=1000000&offset=0"
            
            print(Temp1)
            
            
            APIMangagerClass.callGetWithHeader(url: URL(string: Temp1)!, finish: FinishSocialWebserviceCall)
            
        }
        
    }
    
    func SetUI()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        self.tblviewMain.register(CommentCellXIB.self, forCellReuseIdentifier: "CommentCellXIB")
        self.tblviewMain.register(UINib(nibName: "CommentCellXIB", bundle: nil), forCellReuseIdentifier: "CommentCellXIB")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Other Functions
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - UIButton Actions
    
    @IBAction func btnHandlerback(_ sender: Any)
    {
        self.CommentAdd?.CommentNew(isUpdateNew: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHandlerSendComment(_ sender: Any)
    {
        if self.txtComment.text.isEmpty == true
        {
            Loaf("Please enter comment", state: .error, sender: self).show()
            return
            
        }
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        else
        {
            appDelegate.ShowProgess()
            
            self.tblviewMain.isHidden = true
            
            let Paramteres = ["post_id":"\(self.isCommentid)","description":"\(self.txtComment.text!)"]
            
            APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.add_comment)!, params: Paramteres, finish: self.GetAddressWebService)
        }
    }
    
    
    
    
    // MARK: - WEB API Methods
    
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
                                
                                
                                var Shoppingdata = dict["data"].arrayObject! as NSArray
                                
                                print(Shoppingdata)
                                
                                Shoppingdata = Shoppingdata.reversed() as NSArray
                                
                                
                                
                                self.Comments.removeAll()
                                
                                for object in Shoppingdata
                                {
                                    let Data_Object = CommentModel.init(fromDictionary: object as! [String : Any])
                                    self.Comments.append(Data_Object)
                                    
                                }
                                
                                self.tblviewMain.reloadData()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:
                                    {
                                        
                                        self.tblviewMain.isHidden = false
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
                                
                                print(dict)
                                
                                self.txtComment.text = ""
                                
                                let Temp1 = WebURL.get_comment_list + "?" + "post_id=" + "\(self.isCommentid)" +  "&limit=1000000&offset=0"
                                
                                print(Temp1)
                                
                                
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
    
    
}

// MARK: - UITableView Delegate Methods


extension CommentListVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.Comments.count == 0
        {
            self.tblviewMain.setEmptyMessage("No Comments Found")
        }
        else
        {
            self.tblviewMain.restore()
        }
        
        return self.Comments.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblviewMain.dequeueReusableCell(withIdentifier: "CommentCellXIB") as! CommentCellXIB
        
        if self.Comments.count > 0
        {
            cell.lblName.text = "\(self.Comments[indexPath.row].user.name!)"
            cell.lblTime.text = "\(self.Comments[indexPath.row].createdAt!)"
            cell.lblComment.text = "\(self.Comments[indexPath.row].comment!)"
            
            cell.imgviewUser.kf.indicatorType = .activity
            cell.imgviewUser.kf.setImage(with: URL(string: (self.Comments[indexPath.row].user.avatar!)))
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}
