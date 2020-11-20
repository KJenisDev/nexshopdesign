//
//  OrderDataCellXIB.swift
//  Nexshop
//
//  Created by Mac on 05/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class OrderDataCellXIB: UITableViewCell {
    
    @IBOutlet weak var imgviewProduct: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var lblQTY: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblVariations: UILabel!
    @IBOutlet weak var btnTitleRate: UIButton!
    @IBOutlet weak var btnTitlePlaced: UIButton!
    
    @IBOutlet weak var viewMainLeft: UIView!
    @IBOutlet weak var viewLeftSide: UIView!
    
    
    @IBOutlet weak var btnReview: UIButton!
    
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var viewMainRight: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
