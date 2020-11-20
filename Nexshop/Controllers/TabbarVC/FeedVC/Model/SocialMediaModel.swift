//
//  SocialMediaModel.swift
//  Cellula
//
//  Created by macbook on 18/09/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper

struct SocialMediaModel : Mappable {
    var id : Int?
    var media_type : String?
    var file : String?
    var post_id : Int?
    var image: UIImage? = nil
    var isSelectedIndex = false

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        media_type <- map["media_type"]
        post_id <- map["post_id"]
        file <- map["file"]
        isSelectedIndex <- map["isSelectedIndex"]

    }

}
