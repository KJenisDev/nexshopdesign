//
//  LastMessageModel.swift
//  Cellula
//
//  Created by macbook on 22/10/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

struct LastMessageModel : Mappable {
    var id : Int?
    var chat_room_id : Int?
    var from_user_id : Int?
    var to_user_id : Int?
    var message : String?
    var file : String?
    var file_data : String?
    var is_read : Int?
    var is_delivered : Int?
    var created_at : String?
    var updated_at : String?
    var time : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        chat_room_id <- map["chat_room_id"]
        from_user_id <- map["from_user_id"]
        to_user_id <- map["to_user_id"]
        message <- map["message"]
        file <- map["file"]
        file_data <- map["file_data"]
        is_read <- map["is_read"]
        is_delivered <- map["is_delivered"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        time <- map["time"]
    }

}
