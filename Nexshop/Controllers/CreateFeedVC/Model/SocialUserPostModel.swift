//
//  SocialUserPostModel.swift
//  Cellula
//
//  Created by macbook on 12/10/20.
//  Copyright © 2020 Mac. All rights reserved.
//
import Foundation
import ObjectMapper

struct SocialUserPostModel : Mappable {
    var id : Int?
    var profile_id : Int?
    var explore_category_id : Int?
    var description : String?
    var created_at : String?
    var updated_at : String?
    var is_report : Int?
    var is_user_block : Int?
    var is_like : Int?
    var total_likes : Int?
    var total_comments : Int?
    var user : SocialUserModel?
   
    var post_detail : [SocialMediaModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        profile_id <- map["profile_id"]
        explore_category_id <- map["explore_category_id"]
        description <- map["description"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        is_report <- map["is_report"]
        is_user_block <- map["is_user_block"]
        is_like <- map["is_like"]
        total_likes <- map["total_likes"]
        total_comments <- map["total_comments"]
        user <- map["user"]
        post_detail <- map["post_detail"]
    }

}

