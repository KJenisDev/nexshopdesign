//
//  SocialUserModel.swift
//  Cellula
//
//  Created by macbook on 18/09/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

struct SocialUserModel : Mappable {
    var id : Int?
    var name : String?
    var username : String?
    var avatar : String?
    var is_follow : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
        avatar <- map["avatar"]
        is_follow <- map["is_follow"]
    }

}
