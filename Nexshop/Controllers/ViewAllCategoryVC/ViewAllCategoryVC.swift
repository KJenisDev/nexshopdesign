//
//  ViewAllCategoryVC.swift
//  Nexshop
//
//  Created by Mac on 03/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class ViewAllCategoryVC: UIViewController {
    
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblviewHome: UITableView!
    
    
    //MARK:- VARIABLES
    
    var CategoriesDisplayModel = [CategoriesModel]()
    
    
    //MARK:- VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
            
        }
        
        self.tblviewHome.register(ViewCategoriesXIB.self, forCellReuseIdentifier: "ViewCategoriesXIB")
        self.tblviewHome.register(UINib(nibName: "ViewCategoriesXIB", bundle: nil), forCellReuseIdentifier: "ViewCategoriesXIB")
        
        self.tblviewHome.reloadData()
        
    }
    
    
    
    
    //MARK:- ALL FUNCTIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerSearch(_ sender: Any)
    {
        let Push = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(Push, animated: true)
    }
    @IBAction func btnHandlerSideMenu(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- TABLEVIEW METHODS


extension ViewAllCategoryVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.CategoriesDisplayModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblviewHome.dequeueReusableCell(withIdentifier: "ViewCategoriesXIB") as! ViewCategoriesXIB
        cell.selectionStyle = .none
        
        if self.CategoriesDisplayModel.count > 0
        {
            cell.lblCategoty.text = self.CategoriesDisplayModel[indexPath.row].name!
            cell.imgviewPic.kf.indicatorType = .activity
            cell.imgviewPic.kf.setImage(with: URL(string: self.CategoriesDisplayModel[indexPath.row].icon!))
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Push = self.storyboard!.instantiateViewController(withIdentifier: "ProductListingVC") as! ProductListingVC
        Push.Headername = self.CategoriesDisplayModel[indexPath.row].name!
        Push.Categoryid = "\(self.CategoriesDisplayModel[indexPath.row].id!)"
        
        self.navigationController?.pushViewController(Push, animated: true)
    }
}
