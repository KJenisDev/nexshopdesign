//
//  CurrentStatusCellXIB.swift
//  Cellula
//
//  Created by Mac on 19/07/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class CurrentStatusCellXIB: UITableViewCell {

    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
