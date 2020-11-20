//
//  SocialPostModel.swift
//  Cellula
//
//  Created by macbook on 18/09/20.
//  Copyright © 2020 Mac. All rights reserved.
//


import Foundation
import ObjectMapper

struct SocialPostModel : Mappable {
    var id : Int?
    var description : String?
    var created_at : String?
    var media : [SocialMediaModel]?
    var explore_category : SocialExploreCategoryModel?
    var is_like : Int?
    var total_likes : Int?
    var total_comments : Int?
    var user : SocialUserModel?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        description <- map["description"]
        created_at <- map["created_at"]
        media <- map["media"]
        explore_category <- map["explore_category"]
        is_like <- map["is_like"]
        total_likes <- map["total_likes"]
        total_comments <- map["total_comments"]
        user <- map["user"]
    }

}
