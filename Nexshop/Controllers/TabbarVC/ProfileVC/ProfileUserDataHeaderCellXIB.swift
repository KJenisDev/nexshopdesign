//
//  ProfileUserDataHeaderCellXIB.swift
//  Nexshop
//
//  Created by Mac on 09/11/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class ProfileUserDataHeaderCellXIB: UITableViewCell {

    
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgviewPic: UIImageView!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblDob: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
