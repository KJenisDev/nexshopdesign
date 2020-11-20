//
//  SearchVC.swift
//  Nexshop
//
//  Created by Mac on 03/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import SwiftyJSON
import Loaf

class SearchVC: UIViewController,UITextFieldDelegate{
    
    //MARK:- OUTLETS
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblviewSearch: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblNoData: UILabel!
    
    //MARK:- VARIABLES
    let debounce = Debouncer()
    var ProductSearchDisplayModel = [ProductSearchModel]()
    
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblviewSearch.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
            
        }
        
        self.tblviewSearch.register(SearchCellXIB.self, forCellReuseIdentifier: "SearchCellXIB")
        self.tblviewSearch.register(UINib(nibName: "SearchCellXIB", bundle: nil), forCellReuseIdentifier: "SearchCellXIB")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func GetSearchResults (message:String, data:Data?) -> Void
    {
        do
        {
            if data != nil
            {
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
                        DispatchQueue.main.async {
                            
                            let ErrorDic:String = dict["message"].string!
                            appDelegate.HideProgress()
                            appDelegate.ErrorMessage(Message: ErrorDic, ContorllerName: self)
                            return
                        }
                        
                    }
                    else if status == 1
                    {
                        
                        DispatchQueue.main.async {
                            
                            self.ProductSearchDisplayModel.removeAll()
                            
                            var user_Data:NSArray = NSArray()
                            
                            let user:NSDictionary = (dict["data"].dictionaryObject! as NSDictionary)
                            
                            user_Data = user.value(forKey: "products") as! NSArray
                            
                            self.ProductSearchDisplayModel.removeAll()
                            
                            if user_Data.count > 0
                            {
                                for object in user_Data
                                {
                                    
                                    let Data_Object = ProductSearchModel.init(fromDictionary: object as! [String : Any])
                                    self.ProductSearchDisplayModel.append(Data_Object)
                                    
                                    
                                    
                                }
                                self.tblviewSearch.reloadData()
                                self.tblviewSearch.isHidden = false
                                self.lblNoData.text = ""
                                self.lblNoData.isHidden = true
                            }
                            else
                            {
                                
                                self.lblNoData.text =  "No products found!"
                                
                                
                                self.lblNoData.isHidden = false
                                self.tblviewSearch.isHidden  = true
                            }
                        }
                    }
                    else if status == 3
                    {
                        DispatchQueue.main.async {
                            
                            let ErrorDic:String = dict["message"].string!
                            appDelegate.HideProgress()
                            appDelegate.LoginAgainMessage(Message: ErrorDic, ContorllerName: self)
                            return
                            
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            
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
    
    @objc func textFieldTyping(textField:UITextField)
    {
        
        if textField.text?.count == 0
        {
            self.ProductSearchDisplayModel.removeAll()
            self.tblviewSearch.isHidden = true
            self.lblNoData.text =  ""
            self.lblNoData.isHidden = true
            self.tblviewSearch.isHidden  = true
            appDelegate.HideProgress()
        }
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.text == "" {
            
            self.ProductSearchDisplayModel.removeAll()
            self.lblNoData.isHidden = true
            self.lblNoData.text =  ""
            self.tblviewSearch.isHidden  = true
            
            
            
        }
        else
        {
            debounce.debounce {
                
                if textField.text == "" {
                    self.ProductSearchDisplayModel.removeAll()
                    self.lblNoData.text =  "No products found!"
                    self.lblNoData.isHidden = true
                    self.tblviewSearch.isHidden  = true
                    
                    
                }
                else{
                    
                    self.CheckSearchResult()
                }
                
                
            }
        }
        
        
    }
    
    
    func CheckSearchResult() {
        
        var Paramteres = ["search":self.txtSearch.text!]
        var UrlPass = String()
        
        
        UrlPass = WebURL.search
        
        
        APIMangagerClass.callPostWithHeader(url: URL(string: UrlPass)!, params: Paramteres, finish: self.GetSearchResults)
        
    }
    
    
    
    
    
    //MARK:- BUTTON ACTIONS
    
    
    @IBAction func btnHandlerNotifications(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

//MARK:- TABLEVIEW METHODS


extension SearchVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.ProductSearchDisplayModel.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblviewSearch.dequeueReusableCell(withIdentifier: "SearchCellXIB") as! SearchCellXIB
        
        if self.ProductSearchDisplayModel.count > 0
                   {
                       cell.lblHeader.text = "\(self.ProductSearchDisplayModel[indexPath.row].name!)"
                   }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        Push.product_id = "\(self.ProductSearchDisplayModel[indexPath.row].id!)"
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
}


class Debouncer {
    var pendingRequestItem: DispatchWorkItem?
    
    func debounce(after delay: Double = 0.5, _ block: @escaping ()->Void) {
        self.cancel()
        
        let requestWorkItem = DispatchWorkItem(block: block)
        pendingRequestItem = requestWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: requestWorkItem)
    }
    
    func cancel() {
        pendingRequestItem?.cancel()
    }
}
