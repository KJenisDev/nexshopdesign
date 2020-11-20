//
//  OrderShippingDetailsVC.swift
//  Cellula
//
//  Created by Mac on 27/04/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class OrderShippingDetailsVC: UITableViewCell {
    
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDiscountStatic: UILabel!
    @IBOutlet weak var lblTotalCharge: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var lblShippingCharge: UILabel!
    @IBOutlet weak var lblServiceCharge: UILabel!
    @IBOutlet weak var lblGrandTotal: UILabel!
    
    @IBOutlet weak var lblDiscountStaticConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDiscountPriceConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
