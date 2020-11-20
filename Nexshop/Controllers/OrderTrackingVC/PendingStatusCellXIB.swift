//
//  PendingStatusCellXIB.swift
//  Cellula
//
//  Created by Mac on 19/07/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit

class PendingStatusCellXIB: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
