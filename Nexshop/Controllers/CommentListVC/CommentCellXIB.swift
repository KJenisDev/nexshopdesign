//
//  CommentCellXIB.swift
//  Nexshop
//
//  Created by Mac on 09/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class CommentCellXIB: UITableViewCell {
    
    
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
