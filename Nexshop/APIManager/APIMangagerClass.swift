//
//  APIMangagerClass.swift
//  Nexshop
//
//  Created by Mac on 12/10/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let _sharedInstance = APIMangagerClass()


class APIMangagerClass: NSObject {
    
    class var sharedInstance: APIMangagerClass {
        return _sharedInstance
    }
    
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    static func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                result.message = "Success"
                result.data = data
            }
            
            finish(result)
        }
        task.resume()
    }
    
    static func callGet(url:URL, finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                result.message = "Success"
                result.data = data
            }
            
            finish(result)
        }
        task.resume()
    }
    
    static func callPostWithHeader(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(appDelegate.get_user_Data(Key: "token"))", forHTTPHeaderField: "Authorization")
        print("TOKEN :"  + "\(appDelegate.get_user_Data(Key: "token"))")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if(error != nil)
            {
                result.message = "Fail Error not null : \(error.debugDescription)"
            }
            else
            {
                result.message = "Success"
                result.data = data
            }
            
            finish(result)
        }
        task.resume()
    }
    static func callGetWithHeader(url:URL, finish: @escaping ((message:String, data:Data?)) -> Void)
      {
          var request = URLRequest(url: url)
          request.httpMethod = "GET"
          request.setValue("Bearer \(appDelegate.get_user_Data(Key: "token"))", forHTTPHeaderField: "Authorization")
          request.setValue("application/json", forHTTPHeaderField: "Accept")
          print("VTOKEN :"  + "\((appDelegate.get_user_Data(Key: "token")))")
          
          var result:(message:String, data:Data?) = (message: "Fail", data: nil)
          let task = URLSession.shared.dataTask(with: request) { data, response, error in
              
              if(error != nil)
              {
                  result.message = "Fail Error not null : \(error.debugDescription)"
              }
              else
              {
                  result.message = "Success"
                  result.data = data
              }
              
              finish(result)
          }
          task.resume()
      }
    
}

struct WebURL {
    
    
    static let baseURL:String = "https://zestbrains.techboundary.xyz/public/api/v1/app/"
    
    static let CellulabaseURL:String = "https://staging.thecellula.com/api/v1/app/"
    
    static let login:String = WebURL.baseURL + "login"
    
    static let resend_otp:String = WebURL.baseURL + "resend_otp"
    
    static let verify_otp:String = WebURL.baseURL + "verify_otp"
    
    static let signup:String = WebURL.baseURL + "signup"
    
    static let social_login:String = WebURL.baseURL + "social_login"
    
    static let shoppinghome:String = WebURL.baseURL + "get_shopping_landing_data"
    
    static let get_orders:String = WebURL.baseURL + "get_orders"
    
    static let get_wishlist:String = WebURL.baseURL + "get_wishlist"
    
    static let notification_set:String = WebURL.baseURL + "notification_set"
    
    static let edit_profile:String = WebURL.baseURL + "edit_profile"
    
    static let get_notification_list:String = WebURL.baseURL + "general/get_notification_list"
    
    static let clear_notification:String = WebURL.baseURL + "clear_notification"
    
    static let repeat_order:String = WebURL.baseURL + "repeat_order"
    
    static let search:String = WebURL.baseURL + "global/search"
    
    static let CategoryData:String = WebURL.baseURL + "get_products"
    
    static let get_addresses:String = WebURL.baseURL + "get_addresses"
    
    static let get_cart_details:String = WebURL.baseURL + "get_cart_details"
    
    static let manage_wishlist:String = WebURL.baseURL + "manage_wishlist"
    
    static let remove_item_from_cart:String = WebURL.baseURL + "remove_item_from_cart"
    
    static let remove_addresses:String = WebURL.baseURL + "remove_addresses"
    
    static let create_order:String = WebURL.baseURL + "create_order"
    
    static let add_address:String = WebURL.baseURL + "add_address"
    
    static let get_product_variant_price:String = WebURL.baseURL + "get_product_variant_price"
    
    static let remove_from_wishlist:String = WebURL.baseURL + "remove_from_wishlist"
    
    static let add_item_to_cart:String = WebURL.baseURL + "add_item_to_cart"
    
        static let SubCategoryData:String = WebURL.baseURL + "get_sub_categories"

    static let logout:String = WebURL.baseURL + "logout"
    
    static let get_my_post_list:String = WebURL.baseURL + "get_my_post_list"
    
    static let get_explore_post_list:String = WebURL.baseURL + "get_explore_post_list"

    static let order_tracking:String = WebURL.baseURL + "order_tracking"
    
    static let get_comment_list:String = WebURL.baseURL + "get_comment_list"
    
    static let add_comment:String = WebURL.baseURL + "add_comment"
    
    static let create_post:String = WebURL.baseURL + "create_post"
    
    static let edit_post:String = WebURL.baseURL + "edit_post"
    
    static let social_delete_post:String = WebURL.baseURL + "social_delete_post"
    
    static let chat:String = WebURL.baseURL + "chat/send_messages"
    
    static let add_reviews:String = WebURL.baseURL + "add_reviews"
    
    static let addDevice:String = WebURL.baseURL + "addDevice"
    
    static let get_post_detail:String = WebURL.baseURL + "get_post_detail"
    
    static let forget_password:String = WebURL.baseURL + "forget_password"
    
    static let check_username:String = WebURL.baseURL + "check_username"

    
    
    
   
    
    
    
}
