//
//  ProductDetailHeaderCellXIB.swift
//  Nexshop
//
//  Created by Mac on 06/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class ProductDetailHeaderCellXIB: UITableViewCell {
    
    
    
    @IBOutlet weak var imgviewProduct: UIImageView!
    @IBOutlet weak var btnHandlerRed: UIButton!
    @IBOutlet weak var imgviewRed: UIImageView!
    @IBOutlet weak var btnHandlerShare: UIButton!
    @IBOutlet weak var lblProductName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
