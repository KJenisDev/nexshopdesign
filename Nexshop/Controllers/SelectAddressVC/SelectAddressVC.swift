//
//  SelectAddressVC.swift
//  Nexshop
//
//  Created by Mac on 05/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Loaf
import SwiftyJSON

protocol UpdateAddresswithLocation
{
    func UpdateAddresswithLocation(isAddressId:String,isAddress:String,Name:String,City:String,State:String,ZipCode:String,latitude:String,longitude:String,selectedAddModel:GetAddressModel?)

}

class SelectAddressVC: UIViewController {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var tblviewAddress: UITableView!
    @IBOutlet weak var viewCart: UIView!
    
    
    //MARK:- VARIABLES
    var DisplayGetAddressModel = [GetAddressModel]()
    var selected_address_id = String()
    var cart_total = Float()
    var type = String()
    var totalitemscharge = NSNumber()
    var servicecharge = NSNumber()
    var deliverycharge = NSNumber()
    var granndTotal = NSNumber()
    var isFromPush = false
    var UpadteAddresswithLocationDelegate:UpdateAddresswithLocation?

    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblviewAddress.isHidden = true
        
        self.tblviewAddress.register(SelectAddressCellXIB.self, forCellReuseIdentifier: "SelectAddressCellXIB")
        self.tblviewAddress.register(UINib(nibName: "SelectAddressCellXIB", bundle: nil), forCellReuseIdentifier: "SelectAddressCellXIB")
        
        self.tblviewAddress.register(AddNewAddressXIB.self, forCellReuseIdentifier: "AddNewAddressXIB")
        self.tblviewAddress.register(UINib(nibName: "AddNewAddressXIB", bundle: nil), forCellReuseIdentifier: "AddNewAddressXIB")
        
        self.tblviewAddress.register(NoAddressCellXIB.self, forCellReuseIdentifier: "NoAddressCellXIB")
        self.tblviewAddress.register(UINib(nibName: "NoAddressCellXIB", bundle: nil), forCellReuseIdentifier: "NoAddressCellXIB")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewCart.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
        }
        
        if CommonClass.sharedInstance.isReachable() == false
        {
            Loaf(LocalValidations.checkinternetConnection, state: .error, sender: self).show()
            return
        }
        
        appDelegate.ShowProgess()
        
        self.tblviewAddress.isHidden = true
        
        let Paramteres = ["":""]
        
        APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.get_addresses)!, params: Paramteres, finish: self.GetAddressWebService)
        
    }
    
    // MARK:- ALL FUNCTIONS
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnHandlerContinue(_ sender: Any)
    {
        if self.selected_address_id.isEmpty == true
        {
            Loaf(LocalValidations.SelectAddress, state: .error, sender: self).show()
            return
        }
        if self.isFromPush == true
        {
            
        }
        else
        {
            let Push = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
            Push.totalitemscharge = self.totalitemscharge
            Push.servicecharge = self.servicecharge
            Push.deliverycharge = self.deliverycharge
            Push.granndTotal = self.granndTotal
            Push.isAddressid = self.selected_address_id
            self.navigationController?.pushViewController(Push, animated: true)
        }
        
    }
}


//MARK:- TABLEVIEW METHODS

extension SelectAddressVC:UITableViewDelegate,UITableViewDataSource
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
        
        if indexPath.section == 0
        {
            if self.DisplayGetAddressModel.count > 0
            {
                self.selected_address_id = String()
                self.selected_address_id = "\(self.DisplayGetAddressModel[indexPath.row].id!)"
                self.tblviewAddress.reloadData()
                
                if self.isFromPush == true
                {
                    let isfirstAddress = "\(self.DisplayGetAddressModel[indexPath.row].name!)" + " , " + "\(self.DisplayGetAddressModel[indexPath.row].city!)" + " , " +  "\(self.DisplayGetAddressModel[indexPath.row].zipcode!)"
                                   
                                   self.UpadteAddresswithLocationDelegate?.UpdateAddresswithLocation(isAddressId: selected_address_id, isAddress: isfirstAddress, Name: "\(self.DisplayGetAddressModel[indexPath.row].name!)", City: "\(self.DisplayGetAddressModel[indexPath.row].city!)", State: "\(self.DisplayGetAddressModel[indexPath.row].state!)", ZipCode: "\(self.DisplayGetAddressModel[indexPath.row].zipcode!)", latitude: "\(self.DisplayGetAddressModel[indexPath.row].lat!)", longitude: "\(self.DisplayGetAddressModel[indexPath.row].lng!)",selectedAddModel:self.DisplayGetAddressModel[indexPath.row])
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
               
            }
            
        }
        else
        {
            
        }
        
    }
}



extension SelectAddressVC : UpdateAddress
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
