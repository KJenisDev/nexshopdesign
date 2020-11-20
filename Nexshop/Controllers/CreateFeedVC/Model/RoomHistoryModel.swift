//
//  RoomHistoryModel.swift
//  Cellula
//
//  Created by macbook on 22/10/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

struct RoomHistoryModel : Mappable {
    var id : Int?
    var created_user_id : Int?
    var type : String?
    var object_id : String?
    var other_user_id : Int?
    var created_at : String?
    var updated_at : String?
    var unread_msg : String?
    var receiver_id : String?
    var last_message : LastMessageModel?
    var created_user_data : CreatedUserDataModel?
    var other_user_data : OtherUserDataModel?
    var created_user_block : Int?
    var other_user_block : Int?
    var to_user_data : ToUserDataModel?
    var product : ProductDataModel?
    

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        created_user_id <- map["created_user_id"]
        type <- map["type"]
        object_id <- map["object_id"]
        other_user_id <- map["other_user_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        unread_msg <- map["unread_msg"]
        receiver_id <- map["receiver_id"]
        last_message <- map["last_message"]
        created_user_data <- map["created_user_data"]
        other_user_data <- map["other_user_data"]
        created_user_block <- map["created_user_block"]
        other_user_block <- map["other_user_block"]
        //to_user_data <- map["to_user_data"]
        to_user_data <- map["other_user_data"]
        product <- map["product"]
        
    }

}
struct CreatedUserDataModel : Mappable {
    var id : Int?
    var username : String?
    var name : String?
    var avatar : String?
    var last_activity : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        username <- map["username"]
        name <- map["name"]
        avatar <- map["avatar"]
        last_activity <- map["last_activity"]
    }

}
struct ToUserDataModel : Mappable {
    var id : Int?
    var user_id : Int?
    var name : String?
    var profile_picture : String?
    var shop : ShopModel?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        name <- map["name"]
        profile_picture <- map["profile_picture"]
        shop <- map["shop"]
    }

}
