//
//  AddToCartButtonXIB.swift
//  Nexshop
//
//  Created by Mac on 07/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class AddToCartButtonXIB: UITableViewCell {
    
    
    @IBOutlet weak var viewBackground: UIView!
    
    @IBOutlet weak var btnTitleAddToCart: UIButton!
    
    @IBOutlet weak var btnTitleBuy: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
