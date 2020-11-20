//
//  AddressBottomPopUpVC.swift
//  Nexshop
//
//  Created by Mac on 20/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import Alamofire
import Kingfisher
import SwiftyJSON
import BottomPopup


protocol SelectAddress
{
    func SelectAddressFtn(isAddressId:String,isAddress:String,Name:String,City:String,ZipCode:String)
}

class AddressBottomPopUpVC: BottomPopupViewController {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var tblviewAddress: UITableView!
    
    
    //MARK:- VARIABLES
    var DisplayGetAddressModel = [GetAddressModel]()
    var selected_address_id = String()
    var cart_total = Float()
    var type = String()
    var totalitemscharge = NSNumber()
    var servicecharge = NSNumber()
    var deliverycharge = NSNumber()
    var granndTotal = NSNumber()
    
    var height: CGFloat = CGFloat()
       var topCornerRadius: CGFloat = 35
       var presentDuration: Double = 1.5
       var dismissDuration: Double = 1.5
       let kHeightMaxValue: CGFloat = 600
       let kTopCornerRadiusMaxValue: CGFloat = 35
       let kPresentDurationMaxValue = 3.0
       let kDismissDurationMaxValue = 3.0
       
      var SelectAddressDelegate:SelectAddress?
       

       var NewNavigationController = UINavigationController()
       
       
       
       override var popupHeight: CGFloat { return height ?? CGFloat(300) }
       override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(35) }
       override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
       override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tblviewAddress.register(SelectAddressCellXIB.self, forCellReuseIdentifier: "SelectAddressCellXIB")
        self.tblviewAddress.register(UINib(nibName: "SelectAddressCellXIB", bundle: nil), forCellReuseIdentifier: "SelectAddressCellXIB")
        
        self.tblviewAddress.register(AddNewAddressXIB.self, forCellReuseIdentifier: "AddNewAddressXIB")
        self.tblviewAddress.register(UINib(nibName: "AddNewAddressXIB", bundle: nil), forCellReuseIdentifier: "AddNewAddressXIB")
        
        self.tblviewAddress.register(NoAddressCellXIB.self, forCellReuseIdentifier: "NoAddressCellXIB")
        self.tblviewAddress.register(UINib(nibName: "NoAddressCellXIB", bundle: nil), forCellReuseIdentifier: "NoAddressCellXIB")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        self.selected_address_id = String()
        appDelegate.ShowProgess()
        
        self.tblviewAddress.isHidden = true
        
        let Paramteres = ["":""]
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_addresses)!, params: Paramteres, finish: self.GetAddressWebService)
        
    }
    
    //MARK:- ALL FUNCTIONS
    
    @objc func AddnewAddress(sender:UIButton)
    {
        
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
        Push.UpadteAddressDelegate = self
        self.navigationController?.pushViewController(Push, animated: true)
        
    }
    
    @objc func RemoveAddress(sender:UIButton)
    {
        let alertController = UIAlertController(title: "Nexshop", message: "Are you sure want to delete this address?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            
            
            let Paramteres = ["address_id":"\(self.DisplayGetAddressModel[sender.tag].id!)"]
            
            if CommonClass.sharedInstance.isReachable() == false
            {
                Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
                return
            }
            
            appDelegate.ShowProgess()
            self.tblviewAddress.isHidden = true
            
            
            APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.remove_addresses)!, params: Paramteres, finish: self.RemoveAddressWebService)
            
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func RemoveAddressWebService (message:String, data:Data?) -> Void
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
                                
                                let Paramteres = ["":""]
                                self.selected_address_id = String()
                                
                                APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_addresses)!, params: Paramteres, finish: self.GetAddressWebService)
                                
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
                                
                                self.DisplayGetAddressModel.removeAll()
                                
                                let user_Data:NSArray = (dict["data"].arrayObject! as NSArray)
                                
                                
                                
                                if user_Data.count > 0
                                {
                                    for object in user_Data
                                    {
                                        let Data_Object = GetAddressModel.init(fromDictionary: object as! [String : Any])
                                        self.DisplayGetAddressModel.append(Data_Object)
                                    }
                                    
                                }
                                
                                self.tblviewAddress.reloadData()
                                self.tblviewAddress.isHidden = false
                                
                                appDelegate.HideProgress()
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
    
    //MARK:- BUTTON ACTIONS
    
    
}


//MARK:- TABLEVIEW METHODS

extension AddressBottomPopUpVC:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            if self.DisplayGetAddressModel.count == 0
            {
                return 1
            }
            else
            {
                return self.DisplayGetAddressModel.count
            }
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            if self.DisplayGetAddressModel.count == 0
            {
                let cell = self.tblviewAddress.dequeueReusableCell(withIdentifier: "NoAddressCellXIB") as! NoAddressCellXIB
                
                return cell
            }
            else
            {
                let cell = self.tblviewAddress.dequeueReusableCell(withIdentifier: "SelectAddressCellXIB") as! SelectAddressCellXIB
                
                if self.DisplayGetAddressModel.count > 0
                {
                    if selected_address_id == "\(self.DisplayGetAddressModel[indexPath.row].id!)"
                    {
                        cell.imgviewBlue.image = UIImage(named: "ic_select_blue")
                        
                    }
                    else
                    {
                        cell.imgviewBlue.image = UIImage(named: "ic_check_blue")
                    }
                    
                    
                    cell.btnTitleEdit.tag = indexPath.row
                    cell.btnTitleEdit.addTarget(self, action: #selector(self.RemoveAddress(sender:)), for: .touchUpInside)
                    
                    cell.lblName.text = "\(self.DisplayGetAddressModel[indexPath.row].name!)"
                    cell.lblType.text = "\(self.DisplayGetAddressModel[indexPath.row].tag!)"
                    cell.lblAddress.text = "\(self.DisplayGetAddressModel[indexPath.row].houseNumber!)" + " , " + "\(self.DisplayGetAddressModel[indexPath.row].landmark!)" + " , " + "\(self.DisplayGetAddressModel[indexPath.row].city!)" + " , " + "\(self.DisplayGetAddressModel[indexPath.row].zipcode!)"
                }
                
                return cell
            }
            
        }
        else
        {
            let cell = self.tblviewAddress.dequeueReusableCell(withIdentifier: "AddNewAddressXIB") as! AddNewAddressXIB
            
            cell.btnTitleAdd.addTarget(self, action: #selector(self.AddnewAddress(sender:)), for: .touchUpInside)
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            if self.DisplayGetAddressModel.count == 0
            {
                return 50
            }
            else
            {
                return 90
            }
            
        }
        else
            
        {
            return 50
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.DisplayGetAddressModel.count > 0
                    {
                        self.selected_address_id = String()
                        self.selected_address_id = "\(self.DisplayGetAddressModel[indexPath.row].id!)"
                        self.tblviewAddress.reloadData()
                        
                        
                         let isfirstAddress = "\(self.DisplayGetAddressModel[indexPath.row].name!)" + " , " + "\(self.DisplayGetAddressModel[indexPath.row].city!)" + " , " +  "\(self.DisplayGetAddressModel[indexPath.row].zipcode!)"
//                        self.SelectAddress?.UpdateAddress(isAddressId: selected_address_id, isAddress: isfirstAddress, Name: "\(self.DisplayGetAddressModel[indexPath.row].name!)", City: "\(self.DisplayGetAddressModel[indexPath.row].city!)", ZipCode: "\(self.DisplayGetAddressModel[indexPath.row].zipcode!)")
//
        //                if(self.DisplayGetAddressModel[indexPath.row].is_default != 1){
                        
                        
                        

          //              }
                        
                        
                        self.SelectAddressDelegate?.SelectAddressFtn(isAddressId: selected_address_id, isAddress: isfirstAddress, Name: "\(self.DisplayGetAddressModel[indexPath.row].name!)", City: "\(self.DisplayGetAddressModel[indexPath.row].city!)", ZipCode: "\(self.DisplayGetAddressModel[indexPath.row].zipcode!)")
                        
                        dismiss(animated: true, completion: nil)
                        
                        
                        
                    }
        
    }
}



extension AddressBottomPopUpVC : UpdateAddress
{
    func UpdateAddress(isAddressId:String)
    {
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        self.selected_address_id = String()
        appDelegate.ShowProgess()
        
        self.tblviewAddress.isHidden = true
        
        let Paramteres = ["":""]
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_addresses)!, params: Paramteres, finish: self.GetAddressWebService)
    }
    
    
    
}
