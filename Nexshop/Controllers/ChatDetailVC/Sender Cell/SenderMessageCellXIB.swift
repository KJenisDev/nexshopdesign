//
//  SenderMessageCellXIB.swift
//  Nexshop
//
//  Created by Mac on 10/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class SenderMessageCellXIB: UITableViewCell {
    
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}