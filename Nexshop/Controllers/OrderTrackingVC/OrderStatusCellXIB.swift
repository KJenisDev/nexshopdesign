//
//  OrderStatusCellXIB.swift
//  Nexshop
//
//  Created by Mac on 06/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class OrderStatusCellXIB: UITableViewCell {

    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSingeLine: UIView!
    
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var lblOrderDescription: UILabel!
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
