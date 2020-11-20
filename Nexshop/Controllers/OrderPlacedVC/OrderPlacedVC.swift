//
//  OrderPlacedVC.swift
//  Nexshop
//
//  Created by Mac on 05/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class OrderPlacedVC: UIViewController {
    
    
    // MARK:- OUTLETS
    @IBOutlet weak var ViewMain: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    
    
    //MARK:- VARIABLES
    var Expected_Date = String()
    var ShippingDetails = NSMutableDictionary()
    var type = String()
    
    
    //MARK:- VIEW DID LOAD
    

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                         self.ViewMain.roundCorners(corners: [.topLeft, .topRight], radius: 32.0)
                     }
        
        //self.lblDate.text = "\(self.Expected_Date)"
        
        self.lblDate.text = "5 - 10 working days delivery"
        
    }
    

   // MARK:- ALL FUNCTIONS
    
  
    
    //MARK:- BUTTON ACTIONS
    
    @IBAction func btnHandlerShopping(_ sender: Any)
    {
        appDelegate.SetHomeRoot()
    }
    
    
    

}
