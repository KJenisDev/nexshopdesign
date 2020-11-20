//
//  ProductDetailHeaderPriceCellXIB.swift
//  Nexshop
//
//  Created by Mac on 07/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Cosmos

class ProductDetailHeaderPriceCellXIB: UITableViewCell {

    @IBOutlet weak var lblStrike: UILabel!
    @IBOutlet weak var lblinStock: UILabel!
    @IBOutlet weak var lblAvgRatings: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var lblTotalRatings: UILabel!
    @IBOutlet weak var RatingsBar: CosmosView!
    
    
    @IBOutlet weak var btnTitleQTY: UIButton!
    @IBOutlet weak var lQTY: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
