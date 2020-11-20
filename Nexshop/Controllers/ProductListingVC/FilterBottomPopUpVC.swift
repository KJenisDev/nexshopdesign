//
//  FilterBottomPopUpVC.swift
//  Nexshop
//
//  Created by Mac on 05/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import BottomPopup
import SwiftyJSON
import Loaf

protocol UpdateProductList {
    func UpdateProductList(Sortby:String,Ratings:String,SubCategory:NSMutableArray, delivery_day: String)
    
}

class FilterBottomPopUpVC: BottomPopupViewController {
    let unselectedColor  = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
    
    
    //MARK:- OUTLETS
    
    
    @IBOutlet weak var CollectionviewHome: UICollectionView!
    @IBOutlet weak var viewBottom: UIView!
    
    
    //MARK:- VARIABLES
    var strViewId = String()
    var SubCategoryDeleagate:UpdateProductList?
    var order_by = String()
    var customer_review = String()
    var delivery_day = String()
    
    var budget = ""
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var isFromMedical = false
    var isFromDoctor = false
    var isFromLabTest = false
    var SortbyDisplayModel = [SortByModel]()
    var DeliveryDayDisplayModel = [SortByModel]()
    
    var StartDispalyModel = [SortByModel]()
    var BudgetDispalyModel = [SortByModel]()
    var Categoryid = String()
    var sectionArray = [String]()
    var SubCategoryArray = NSMutableArray()
    
    var DisplayAllCategories = [SubcategoryMainModel]()
    var SubCategoryModel = [Subcategory]()
    var FinalSubCategoriesDisplayModelData = [SubCategoriesDisplayModelData]()
    
    var isFromService = false
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CollectionviewHome.isHidden = true
        
        
        self.CollectionviewHome.register(UINib(nibName: "FilterHeaderCellXIB", bundle: nil), forCellWithReuseIdentifier: "FilterHeaderCellXIB")
        
        self.CollectionviewHome.register(UINib(nibName: "FilterDataCellXIB", bundle: nil), forCellWithReuseIdentifier: "FilterDataCellXIB")
        
        DispatchQueue.main.async {
            CommonClass .sharedInstance.setShadow(obj: self.viewBottom!
                , cornurRadius: 0.0, ClipToBound: true, masksToBounds: false, shadowColor: "D3D3D3", shadowOpacity: 0.9, shadowOffset: .zero, shadowRadius: 5, shouldRasterize: false, shadowPath: self.viewBottom.bounds)
            
        }
        
        if self.Categoryid.isEmpty == true
        {
            
            let FirstDict = NSMutableDictionary()
            FirstDict.setValue("Featured", forKey: "name")
            FirstDict.setValue(false, forKey: "isselected")
            
            let SecondDict = NSMutableDictionary()
            SecondDict.setValue("Price: Low to High", forKey: "name")
            SecondDict.setValue(false, forKey: "isselected")
            
            let ThirdDict = NSMutableDictionary()
            ThirdDict.setValue("Price: High to Low", forKey: "name")
            ThirdDict.setValue(false, forKey: "isselected")
            
            let Data_Object1 = SortByModel.init(fromDictionary: FirstDict as! [String : Any])
            let Data_Object2 = SortByModel.init(fromDictionary: SecondDict as! [String : Any])
            let Data_Object3 = SortByModel.init(fromDictionary: ThirdDict as! [String : Any])
            
            
            self.SortbyDisplayModel.append(Data_Object1)
            self.SortbyDisplayModel.append(Data_Object2)
            self.SortbyDisplayModel.append(Data_Object3)
            
            //DeliveryDayDisplayModel
            let DDFirstDict = NSMutableDictionary()
            DDFirstDict.setValue("Get it by 2 days", forKey: "name")
            DDFirstDict.setValue(false, forKey: "isselected")
            
            let DDSecondDict = NSMutableDictionary()
            DDSecondDict.setValue("Get it by tomorrow", forKey: "name")
            DDSecondDict.setValue(false, forKey: "isselected")
            
            
            let DDData_Object1 = SortByModel.init(fromDictionary: DDFirstDict as! [String : Any])
            let DDData_Object2 = SortByModel.init(fromDictionary: DDSecondDict as! [String : Any])
            
            
            self.DeliveryDayDisplayModel.append(DDData_Object1)
            self.DeliveryDayDisplayModel.append(DDData_Object2)
            
            
            let StarAllDict = NSMutableDictionary()
            StarAllDict.setValue("All", forKey: "name")
            StarAllDict.setValue(false, forKey: "isselected")
            
            let StarSingletDict = NSMutableDictionary()
            StarSingletDict.setValue("1 Star", forKey: "name")
            StarSingletDict.setValue(false, forKey: "isselected")
            
            let StarSecondDict = NSMutableDictionary()
            StarSecondDict.setValue("2 Star", forKey: "name")
            StarSecondDict.setValue(false, forKey: "isselected")
            
            let StarThirdDict = NSMutableDictionary()
            StarThirdDict.setValue("3 Star", forKey: "name")
            StarThirdDict.setValue(false, forKey: "isselected")
            
            let StarFourthtDict = NSMutableDictionary()
            StarFourthtDict.setValue("4 Star", forKey: "name")
            StarFourthtDict.setValue(false, forKey: "isselected")
            
            
            let StarFifthDict = NSMutableDictionary()
            StarFifthDict.setValue("5 Star", forKey: "name")
            StarFifthDict.setValue(false, forKey: "isselected")
            
            let StarData_ObjectAll = SortByModel.init(fromDictionary: StarAllDict as! [String : Any])
            let StarData_Object1 = SortByModel.init(fromDictionary: StarSingletDict as! [String : Any])
            let StarData_Object2 = SortByModel.init(fromDictionary: StarSecondDict as! [String : Any])
            let StarData_Object3 = SortByModel.init(fromDictionary: StarThirdDict as! [String : Any])
            let StarData_Object4 = SortByModel.init(fromDictionary: StarFourthtDict as! [String : Any])
            let StartData_Object5 = SortByModel.init(fromDictionary: StarFifthDict as! [String : Any])
            
            self.StartDispalyModel.append(StarData_ObjectAll)
            self.StartDispalyModel.append(StarData_Object1)
            self.StartDispalyModel.append(StarData_Object2)
            self.StartDispalyModel.append(StarData_Object3)
            self.StartDispalyModel.append(StarData_Object4)
            self.StartDispalyModel.append(StartData_Object5)
            
            print(self.StartDispalyModel[0].name)
            
            
            var Tempint = 0
            
            for Starobject in self.StartDispalyModel
            {
                if self.customer_review == Starobject.name
                {
                    self.StartDispalyModel[Tempint].isselected = true
                }
                Tempint = Tempint + 1
            }
            
            
            Tempint = 0
            
            for Orderobject in self.SortbyDisplayModel
            {
                if self.order_by == Orderobject.name
                {
                    self.SortbyDisplayModel[Tempint].isselected = true
                }
                Tempint = Tempint + 1
            }
            
            Tempint = 0
            
            
            for day1 in self.DeliveryDayDisplayModel
            {
                if self.delivery_day == "0"
                {
                    self.DeliveryDayDisplayModel[0].isselected = true
                    
                }
                else
                {
                    self.DeliveryDayDisplayModel[1].isselected = true
                    
                }
                
                Tempint = Tempint + 1
            }
            
            self.sectionArray = ["Sort by","Delivery Day", "Customer Reviews"]
            
            
            
            self.CollectionviewHome.register(UINib(nibName: "FilterDataCellXIB", bundle: nil), forCellWithReuseIdentifier: "FilterDataCellXIB")
            
            self.CollectionviewHome.register(UINib(nibName: "FliterHeaderCellXIB", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FliterHeaderCellXIB")
            
            self.CollectionviewHome.register(UINib(nibName: "FilterHeaderCellXIB", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterHeaderCellXIB")
            
            
            self.CollectionviewHome.reloadData()
            self.CollectionviewHome.isHidden = false
            
            appDelegate.HideProgress()
            
            
        }
        else
        {
            appDelegate.ShowProgess()
            
            let Paramteres = ["category_id":self.Categoryid]
            
            APIMangagerClass.callPostWithHeader(url: URL(string: WebURL.SubCategoryData)!, params: Paramteres, finish: self.GetSubCategoriesWebserviceCall)
        }
        
        
        
    }
    
    
    //MARK:- ALL FUNCTIONS
    
    func GetSubCategoriesWebserviceCall (message:String, data:Data?) -> Void
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
                                
                                self.DisplayAllCategories.removeAll()
                                
                                let user_Data:NSArray = (dict["data"].arrayObject! as NSArray)
                                let FinalArray = NSMutableArray()
                                for object1 in user_Data
                                {
                                    let TempDict = object1 as! NSDictionary
                                    let subcategoriesArray = TempDict.value(forKey: "subcategories") as! NSArray
                                    FinalArray.addObjects(from: subcategoriesArray as! [Any])
                                    
                                }
                                
                                let TempData1 = user_Data.compactMap({$0}) as NSArray
                                FinalArray.addObjects(from: TempData1 as! [Any])
                                
                                
                                for object in FinalArray
                                {
                                    let Data_Object = SubCategoriesDisplayModelData.init(fromDictionary: object as! [String : Any])
                                    self.FinalSubCategoriesDisplayModelData.append(Data_Object)
                                }
                                
                                
                                let FirstDict = NSMutableDictionary()
                                FirstDict.setValue("Featured", forKey: "name")
                                FirstDict.setValue(false, forKey: "isselected")
                                
                                let SecondDict = NSMutableDictionary()
                                SecondDict.setValue("Price: Low to High", forKey: "name")
                                SecondDict.setValue(false, forKey: "isselected")
                                
                                let ThirdDict = NSMutableDictionary()
                                ThirdDict.setValue("Price: High to Low", forKey: "name")
                                ThirdDict.setValue(false, forKey: "isselected")
                                
                                let Data_Object1 = SortByModel.init(fromDictionary: FirstDict as! [String : Any])
                                let Data_Object2 = SortByModel.init(fromDictionary: SecondDict as! [String : Any])
                                let Data_Object3 = SortByModel.init(fromDictionary: ThirdDict as! [String : Any])
                                
                                
                                self.SortbyDisplayModel.append(Data_Object1)
                                self.SortbyDisplayModel.append(Data_Object2)
                                self.SortbyDisplayModel.append(Data_Object3)
                                
                                //DeliveryDayDisplayModel
                                let DDFirstDict = NSMutableDictionary()
                                DDFirstDict.setValue("Get it by 2 days", forKey: "name")
                                DDFirstDict.setValue(false, forKey: "isselected")
                                
                                let DDSecondDict = NSMutableDictionary()
                                DDSecondDict.setValue("Get it by tomorrow", forKey: "name")
                                DDSecondDict.setValue(false, forKey: "isselected")
                                
                                
                                let DDData_Object1 = SortByModel.init(fromDictionary: DDFirstDict as! [String : Any])
                                let DDData_Object2 = SortByModel.init(fromDictionary: DDSecondDict as! [String : Any])
                                
                                
                                self.DeliveryDayDisplayModel.append(DDData_Object1)
                                self.DeliveryDayDisplayModel.append(DDData_Object2)
                                
                                
                                let StarAllDict = NSMutableDictionary()
                                StarAllDict.setValue("All", forKey: "name")
                                StarAllDict.setValue(false, forKey: "isselected")
                                
                                let StarSingletDict = NSMutableDictionary()
                                StarSingletDict.setValue("1 Star", forKey: "name")
                                StarSingletDict.setValue(false, forKey: "isselected")
                                
                                let StarSecondDict = NSMutableDictionary()
                                StarSecondDict.setValue("2 Star", forKey: "name")
                                StarSecondDict.setValue(false, forKey: "isselected")
                                
                                let StarThirdDict = NSMutableDictionary()
                                StarThirdDict.setValue("3 Star", forKey: "name")
                                StarThirdDict.setValue(false, forKey: "isselected")
                                
                                let StarFourthtDict = NSMutableDictionary()
                                StarFourthtDict.setValue("4 Star", forKey: "name")
                                StarFourthtDict.setValue(false, forKey: "isselected")
                                
                                
                                let StarFifthDict = NSMutableDictionary()
                                StarFifthDict.setValue("5 Star", forKey: "name")
                                StarFifthDict.setValue(false, forKey: "isselected")
                                
                                let StarData_ObjectAll = SortByModel.init(fromDictionary: StarAllDict as! [String : Any])
                                let StarData_Object1 = SortByModel.init(fromDictionary: StarSingletDict as! [String : Any])
                                let StarData_Object2 = SortByModel.init(fromDictionary: StarSecondDict as! [String : Any])
                                let StarData_Object3 = SortByModel.init(fromDictionary: StarThirdDict as! [String : Any])
                                let StarData_Object4 = SortByModel.init(fromDictionary: StarFourthtDict as! [String : Any])
                                let StartData_Object5 = SortByModel.init(fromDictionary: StarFifthDict as! [String : Any])
                                
                                self.StartDispalyModel.append(StarData_ObjectAll)
                                self.StartDispalyModel.append(StarData_Object1)
                                self.StartDispalyModel.append(StarData_Object2)
                                self.StartDispalyModel.append(StarData_Object3)
                                self.StartDispalyModel.append(StarData_Object4)
                                self.StartDispalyModel.append(StartData_Object5)
                                
                                var Tempint = 0
                                
                                for day1 in self.DeliveryDayDisplayModel
                                {
                                    if self.delivery_day == "0"
                                    {
                                        self.DeliveryDayDisplayModel[0].isselected = true
                                        
                                    }
                                    else
                                    {
                                        self.DeliveryDayDisplayModel[1].isselected = true
                                        
                                    }
                                    
                                    Tempint = Tempint + 1
                                }
                                
                                Tempint = 0
                                
                                
                                for Starobject in self.StartDispalyModel
                                {
                                    if self.customer_review == Starobject.name
                                    {
                                        self.StartDispalyModel[Tempint].isselected = true
                                    }
                                    Tempint = Tempint + 1
                                }
                                
                                
                                Tempint = 0
                                
                                for Orderobject in self.SortbyDisplayModel
                                {
                                    if self.order_by == Orderobject.name
                                    {
                                        self.SortbyDisplayModel[Tempint].isselected = true
                                    }
                                    Tempint = Tempint + 1
                                }
                                
                                Tempint = 0
                                
                                if self.FinalSubCategoriesDisplayModelData.count > 0
                                {
                                    self.sectionArray = ["Sort by", "Delivery Day","By Product's Categories","Customer Reviews"]
                                    
                                    for Cateobj in self.FinalSubCategoriesDisplayModelData
                                    {
                                        if self.SubCategoryArray.contains(Cateobj.id!)
                                        {
                                            self.FinalSubCategoriesDisplayModelData[Tempint].isSelected = true
                                            
                                        }
                                        
                                        Tempint = Tempint + 1
                                    }
                                    
                                    
                                }
                                else
                                {
                                    self.sectionArray = ["Sort by","Delivery Day", "Customer Reviews"]
                                    
                                }
                                
                                self.CollectionviewHome.register(UINib(nibName: "FilterDataCellXIB", bundle: nil), forCellWithReuseIdentifier: "FilterDataCellXIB")
                                //
                                //                                          self.CollectionviewFilter.register(UINib(nibName: "FilterButtonsCell", bundle: nil), forCellWithReuseIdentifier: "FilterButtonsCell")
                                //
                                self.CollectionviewHome.register(UINib(nibName: "FliterHeaderCellXIB", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FliterHeaderCellXIB")
                                
                                self.CollectionviewHome.register(UINib(nibName: "FilterHeaderCellXIB", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterHeaderCellXIB")
                                
                                
                                self.CollectionviewHome.reloadData()
                                self.CollectionviewHome.isHidden = false
                                
                                appDelegate.HideProgress()
                                
                                
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
    
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerApply(_ sender: Any)
    {
        
        self.SubCategoryDeleagate!.UpdateProductList(Sortby: self.order_by, Ratings: self.customer_review, SubCategory: self.SubCategoryArray, delivery_day: self.delivery_day)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnHandlerClearAll(_ sender: Any)
    {
        self.SubCategoryArray = NSMutableArray()
        self.CollectionviewHome.reloadData()
        self.SubCategoryDeleagate!.UpdateProductList(Sortby: "", Ratings: "", SubCategory: self.SubCategoryArray, delivery_day: "")
        dismiss(animated: true, completion: nil)
        
    }
    
}


extension FilterBottomPopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerView = self.CollectionviewHome.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilterHeaderCellXIB", for: indexPath) as? FilterHeaderCellXIB
            
            if sectionArray.count > 0
            {
                headerView?.lblHeader.text = sectionArray[indexPath.section]
                
            }
            else
            {
                
            }
            
            return headerView!
            
        } else {
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CollectionviewHome.frame.width, height: 40)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return sectionArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0
        {
            return SortbyDisplayModel.count
            
        }
        else if section == 1{
            return DeliveryDayDisplayModel.count
        }
        else if section == 2
        {
            if self.isFromService == true
            {
                return BudgetDispalyModel.count
            }
            else
            {
                
                if self.Categoryid.isEmpty == true
                {
                    return self.StartDispalyModel.count
                }
                else
                {
                    if self.FinalSubCategoriesDisplayModelData.count == 0
                    {
                        return 0
                    }
                    else
                    {
                        return FinalSubCategoriesDisplayModelData.count
                    }
                }
                
                
            }
            
        }
        else
        {
            
            return StartDispalyModel.count
            
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0
        {
            let cell = CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "FilterDataCellXIB", for: indexPath) as? FilterDataCellXIB
            cell?.lblData.text = self.SortbyDisplayModel[indexPath.row].name!
            
            if self.SortbyDisplayModel[indexPath.row].isselected == false
            {
                cell?.lblData.textColor = UIColor.black
                cell?.viewBackground.layer.borderWidth = 1
                cell?.viewBackground.layer.borderColor = UIColor.lightGray.cgColor
                
            }
            else
            {
                cell?.viewBackground.layer.borderWidth = 1
                cell?.viewBackground.layer.borderColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD").cgColor
            }
            
            
            return cell!
        }
        else if indexPath.section == 1
        {
            let cell = CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "FilterDataCellXIB", for: indexPath) as? FilterDataCellXIB
            cell?.lblData.text = self.DeliveryDayDisplayModel[indexPath.row].name!
            
            
            if self.DeliveryDayDisplayModel[indexPath.row].isselected == false
            {
                cell?.lblData.textColor = UIColor.black
                cell?.viewBackground.layer.borderWidth = 1
                cell?.viewBackground.layer.borderColor = UIColor.lightGray.cgColor
                
            }
            else
            {
                cell?.viewBackground.layer.borderWidth = 1
                cell?.viewBackground.layer.borderColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD").cgColor
            }
            
            
            return cell!
        }
        else if indexPath.section == 2
        {
            let cell = CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "FilterDataCellXIB", for: indexPath) as? FilterDataCellXIB
            
            if self.Categoryid.isEmpty == true
            {
                cell?.lblData.text = self.StartDispalyModel[indexPath.row].name!

                
                if self.StartDispalyModel[indexPath.row].isselected == false
                {
                    
                    cell?.lblData.textColor = UIColor.black
                    cell?.viewBackground.layer.borderWidth = 1
                    cell?.viewBackground.layer.borderColor = UIColor.lightGray.cgColor
                    
                }
                else
                {
                    cell?.viewBackground.layer.borderWidth = 1
                    cell?.viewBackground.layer.borderColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD").cgColor
                }
                
                return cell!
            }
            else
            {
                if self.isFromService == true
                {
                    cell?.lblData.text = self.BudgetDispalyModel[indexPath.row].name!
                    
                    
                    
                    if self.BudgetDispalyModel[indexPath.row].isselected == false
                    {
                        cell?.lblData.textColor = UIColor.black
                        cell?.viewBackground.layer.borderWidth = 1
                        cell?.viewBackground.layer.borderColor = UIColor.lightGray.cgColor
                        
                    }
                    else
                    {
                        cell?.viewBackground.layer.borderWidth = 1
                        cell?.viewBackground.layer.borderColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD").cgColor
                    }
                    
                    
                    return cell!
                }
                else
                {
                    cell?.lblData.text = self.FinalSubCategoriesDisplayModelData[indexPath.row].name!
                    
                    
                    
                    if self.FinalSubCategoriesDisplayModelData[indexPath.row].isSelected == false
                    {
                        cell?.lblData.textColor = UIColor.black
                        cell?.viewBackground.layer.borderWidth = 1
                        cell?.viewBackground.layer.borderColor = UIColor.lightGray.cgColor
                        
                    }
                    else
                    {
                        cell?.viewBackground.layer.borderWidth = 1
                        cell?.viewBackground.layer.borderColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD").cgColor
                    }
                    
                    
                    return cell!
                }
            }
            
            
            
        }
        else
        {
            let cell = CollectionviewHome.dequeueReusableCell(withReuseIdentifier: "FilterDataCellXIB", for: indexPath) as? FilterDataCellXIB
            cell?.lblData.text = self.StartDispalyModel[indexPath.row].name!
            
            if self.StartDispalyModel[indexPath.row].isselected == false
            {
                cell?.lblData.textColor = UIColor.black
                cell?.viewBackground.layer.borderWidth = 1
                cell?.viewBackground.layer.borderColor = UIColor.lightGray.cgColor
                
            }
            else
            {
                cell?.viewBackground.layer.borderWidth = 1
                cell?.viewBackground.layer.borderColor = CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD").cgColor
            }
            
            
            return cell!
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0
        {
            let hash = SortbyDisplayModel[indexPath.item].name!
            
            let font = UIFont(name: "Metropolis-SemiBold", size: 1.0)
            let size:CGSize = hash.size(withAttributes: [NSAttributedString.Key.font: font!])
            size.height
            return CGSize(width: (self.CollectionviewHome.frame.width - 20)/3, height: 40 )
            
        }
        else if indexPath.section == 1
        {
            let hash = DeliveryDayDisplayModel[indexPath.item].name!
            
            let font = UIFont(name: "Metropolis-SemiBold", size: 1.0)
            let size:CGSize = hash.size(withAttributes: [NSAttributedString.Key.font: font!])
            size.height
            return CGSize(width: (self.CollectionviewHome.frame.width - 10)/3, height: 40 )
            
        }
        else if indexPath.section == 2
        {
            if self.Categoryid.isEmpty == true
            {
                let hash = StartDispalyModel[indexPath.item].name!
                
                let font = UIFont(name: "Metropolis-SemiBold", size: 6.0)
                let size:CGSize = hash.size(withAttributes: [NSAttributedString.Key.font: font!])
                size.height
                return CGSize(width: size.width + 45, height: 40)
            }
            else
            {
                if self.isFromService == true
                {
                    let hash = BudgetDispalyModel[indexPath.item].name!
                    
                    let font = UIFont(name: "Metropolis-SemiBold", size: 6.0)
                    let size:CGSize = hash.size(withAttributes: [NSAttributedString.Key.font: font!])
                    size.height
                    return CGSize(width: size.width + 45, height: 40)
                }
                else
                {
                    return CGSize(width: (self.CollectionviewHome.frame.width - 10)/2, height: 40 )
                    
                }
            }
            
            
        }
        else
        {
            let hash = StartDispalyModel[indexPath.item].name!
            
            let font = UIFont(name: "Metropolis-SemiBold", size: 6.0)
            let size:CGSize = hash.size(withAttributes: [NSAttributedString.Key.font: font!])
            size.height
            return CGSize(width: size.width + 55, height: 40)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0
        {
            for i in SortbyDisplayModel
            {
                i.isselected = false
                
            }
            
            self.SortbyDisplayModel[indexPath.row].isselected = true
            self.order_by = SortbyDisplayModel[indexPath.row].name!
            self.CollectionviewHome.reloadData()
        }
        else if indexPath.section == 1
        {
            for i in DeliveryDayDisplayModel
            {
                i.isselected = false
                
            }
            
            self.DeliveryDayDisplayModel[indexPath.row].isselected = true
            self.delivery_day = DeliveryDayDisplayModel[indexPath.row].name!
            self.CollectionviewHome.reloadData()
        }
        else if indexPath.section == 2
        {
            
            if self.isFromService == true
            {
                
                for i in BudgetDispalyModel
                {
                    i.isselected = false
                    
                }
                
                self.BudgetDispalyModel[indexPath.row].isselected = true
                self.budget = BudgetDispalyModel[indexPath.row].name!
                self.CollectionviewHome.reloadData()
            }
            else
            {
                if self.FinalSubCategoriesDisplayModelData[indexPath.row].isSelected == false
                {
                    self.FinalSubCategoriesDisplayModelData[indexPath.row].isSelected = true
                    self.SubCategoryArray.add(FinalSubCategoriesDisplayModelData[indexPath.row].id!)
                }
                else
                {
                    self.FinalSubCategoriesDisplayModelData[indexPath.row].isSelected = false
                    self.SubCategoryArray.remove(FinalSubCategoriesDisplayModelData[indexPath.row].id!)
                    
                }
                self.CollectionviewHome.reloadData()
            }
        }
        else
        {
            for i in StartDispalyModel
            {
                i.isselected = false
                
            }
            
            self.StartDispalyModel[indexPath.row].isselected = true
            self.customer_review = StartDispalyModel[indexPath.row].name!
            self.CollectionviewHome.reloadData()
            
            
        }
    }
    
    
}
