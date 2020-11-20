//
//  CartCellXIB.swift
//  Nexshop
//
//  Created by Mac on 02/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class CartCellXIB: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgviewPic: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewLeftSide: UIView!
    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var btnTitleRepeat: UIButton!
    @IBOutlet weak var btnTitleMove: UIButton!
    
    @IBOutlet weak var lblReturn: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblOldPrice: UILabel!
    
    @IBOutlet weak var viewMainLef: UIView!
    @IBOutlet weak var lblVariations: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
