//
//  ProfileHeaderCellXIB.swift
//  Nexshop
//
//  Created by Mac on 02/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit

class ProfileHeaderCellXIB: UICollectionViewCell {
    
    
    @IBOutlet weak var btnTitleEditProfile: UIButton!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var imgviewProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
