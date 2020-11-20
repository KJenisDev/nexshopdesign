//
//  ReviewsCellXIB.swift
//  Nexshop
//
//  Created by Mac on 07/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class ReviewsCellXIB: UITableViewCell {
    
    @IBOutlet weak var lblAvgRatings: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblProductReview: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
