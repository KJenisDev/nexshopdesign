//
//  SocialExploreCategoryModel.swift
//  Cellula
//
//  Created by macbook on 18/09/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import ObjectMapper
struct SocialExploreCategoryModel : Mappable {
    var id : Int?
    var name : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}
