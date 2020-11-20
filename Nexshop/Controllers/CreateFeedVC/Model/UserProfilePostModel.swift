//
//  UserProfilePostModel.swift
//  Cellula
//
//  Created by macbook on 11/10/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

import ObjectMapper

struct UserProfilePostModel : Mappable {
    var id : Int?
    var user_id : Int?
    var profile_picture : String?
    var name : String?
    var bio : String?
    var dob : String?
    var gender : String?
    var location : String?
   
    var user_data : SocialUserModel?
    var total_post : Int?
    var follow : Int?
    var followers : Int?
    var following : Int?
    var healt_score : Int?
    var block : Int?
    var post : [SocialUserPostModel]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        profile_picture <- map["profile_picture"]
        name <- map["name"]
        bio <- map["bio"]
        dob <- map["dob"]
        gender <- map["gender"]
        location <- map["location"]
     
        user_data <- map["user_data"]
        total_post <- map["total_post"]
        follow <- map["follow"]
        followers <- map["followers"]
        following <- map["following"]
        healt_score <- map["healt_score"]
        block <- map["block"]
        post <- map["post"]
    }

}
