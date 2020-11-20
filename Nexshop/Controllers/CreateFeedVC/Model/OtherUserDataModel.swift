//
//  OtherUserDataModel.swift
//  Cellula
//
//  Created by macbook on 22/10/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

struct OtherUserDataModel : Mappable {
    var id : Int?
    var username : String?
    var name : String?
    var avatar : String?
    var last_activity : String?
    var shop : ShopModel?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        username <- map["username"]
        name <- map["name"]
        avatar <- map["avatar"]
        last_activity <- map["last_activity"]
        shop <- map["shop"]
    }

}
