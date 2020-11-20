//
//  ProductDetailAboutXIB.swift
//  Nexshop
//
//  Created by Mac on 07/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Cosmos

class ProductDetailAboutXIB: UITableViewCell {
    
    @IBOutlet weak var LblProductDetail: UILabel!
    @IBOutlet weak var lblAvgRatings: UILabel!
    @IBOutlet weak var RatingsBar: CosmosView!
    @IBOutlet weak var lblTotalRatings: UILabel!
    
    @IBOutlet weak var FiveRatings: UILabel!
    @IBOutlet weak var FiveProgress: UIProgressView!
    
    @IBOutlet weak var FourProgress: UIProgressView!
    @IBOutlet weak var FourRatings: UILabel!
    
    
    @IBOutlet weak var ThreeRatings: UIProgressView!
    @IBOutlet weak var ThreePoints: UILabel!
    
    
    @IBOutlet weak var TwoProgress: UIProgressView!
    @IBOutlet weak var TwoRatings: UILabel!
    
    
    @IBOutlet weak var viewRatings: UIProgressView!
    @IBOutlet weak var lblPOits: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
