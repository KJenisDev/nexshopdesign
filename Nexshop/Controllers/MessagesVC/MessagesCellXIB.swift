//
//  MessagesCellXIB.swift
//  Nexshop
//
//  Created by Mac on 04/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class MessagesCellXIB: UITableViewCell {
    
    

    @IBOutlet weak var lblRed: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgviewPic: UIImageView!
    @IBOutlet weak var lblSeller: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
