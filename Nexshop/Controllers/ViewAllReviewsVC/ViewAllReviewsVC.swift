//
//  ViewAllReviewsVC.swift
//  Nexshop
//
//  Created by Mac on 03/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class ViewAllReviewsVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var viewCart: UIView!
    
    @IBOutlet weak var tblviewReview: UITableView!
    
    //MARK:- VARIABLES
    var reviews = NSMutableArray()

    
    
    
    //MARK:- VIEW DID LOAD
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   self.viewCart.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
                   
               }
        
         self.tblviewReview.isHidden = true
        
        
        self.tblviewReview.register(ReviewsCellXIB.self, forCellReuseIdentifier: "ReviewsCellXIB")
        self.tblviewReview.register(UINib(nibName: "ReviewsCellXIB", bundle: nil), forCellReuseIdentifier: "ReviewsCellXIB")
        
        self.tblviewReview.reloadData()
        self.tblviewReview.isHidden = false
        

        
    }
    

    //MARK:- ALL FUNCTIONS
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
      }
    
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- TABLEVIEW METHODS
    
    
    

}

//MARK:- TABLEVIEW METHODS


extension ViewAllReviewsVC:UITableViewDelegate,UITableViewDataSource
{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.reviews.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.reviews.count == 0
        {
            return UITableViewCell()
        }
        else
        {
            
            
           let cell = self.tblviewReview.dequeueReusableCell(withIdentifier: "ReviewsCellXIB") as! ReviewsCellXIB
                let ReviewDict = (self.reviews.object(at: indexPath.row) as! NSDictionary)
                cell.lblName.text = ((ReviewDict.value(forKey: "user") as! NSDictionary).value(forKey: "name") as! String)
                cell.lblTime.text = "On " +  "\(ReviewDict.value(forKey: "date") as! String)"
                cell.lblAvgRatings.text = "\(Float((ReviewDict.value(forKey: "rating") as! String))!)"
                cell.lblProductReview.text = (ReviewDict.value(forKey: "comment") as! String)
                cell.selectionStyle = .none
                
                return cell
            
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
            return UITableView.automaticDimension
       
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
