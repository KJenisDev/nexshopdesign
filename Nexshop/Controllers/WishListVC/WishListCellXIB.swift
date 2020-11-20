//
//  WishListCellXIB.swift
//  Nexshop
//
//  Created by Mac on 16/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class WishListCellXIB: UITableViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imgviewProduct: UIImageView!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var lblQTY: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    @IBOutlet weak var lblSecondPrice: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    
    @IBOutlet weak var viewMainLeft: UIView!
    @IBOutlet weak var viewLeftSide: UIView!
    @IBOutlet weak var btnTitleRemove: UIButton!
    @IBOutlet weak var btnTitleMove: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
