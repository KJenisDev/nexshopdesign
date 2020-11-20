//
//  SocialViewModel.swift
//  Cellula
//
//  Created by macbook on 18/09/20.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SocialViewModel
{
    func getSocialPostList(limit:Int,offset:Int,completion: @escaping (Bool, String, [SocialPostModel]?) -> ()) {
         Webservice.Social.getExplorePostList(limit: limit, Offset: offset).requestWith(parameter: [:]) { (result) in
            switch result {
            case .success(let response):
                if let responseBody = response.body {
                    
                    if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                        let SocialData = Mapper<SocialPostModel>().mapArray(JSONArray: responceData)
                        completion(true, "", SocialData)
                    }
                    
                } else {
                    print("Fail")
                    completion(false, response.message, nil)
                }
            case .fail(let error):
                completion(false, error, nil)
            }
        }
    }
    
    func getMyOwnSocialPostList(limit:Int,offset:Int,completion: @escaping (Bool, String, [SocialPostModel]?) -> ()) {
         Webservice.Social.getMyPostList(limit: limit, Offset: offset).requestWith(parameter: [:]) { (result) in
            switch result {
            case .success(let response):
                if let responseBody = response.body {
                    
                    if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                        let SocialData = Mapper<SocialPostModel>().mapArray(JSONArray: responceData)
                        completion(true, "", SocialData)
                    }
                    
                } else {
                    print("Fail")
                    completion(false, response.message, nil)
                }
            case .fail(let error):
                completion(false, error, nil)
            }
        }
    }
    
    func getSocialPostDetail(posID:Int,completion: @escaping (Bool, String, SocialPostModel?) -> ()) {
         Webservice.Social.getPostDetail(posID).requestWith(parameter: [:]) { (result) in
            switch result {
            case .success(let response):
                if let responseBody = response.body {
                    
                    if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [String: Any] {
                        let SocialData = Mapper<SocialPostModel>().map(JSON: responceData)
                        completion(true, "", SocialData)
                    }
                    
                } else {
                    print("Fail")
                    completion(false, response.message, nil)
                }
            case .fail(let error):
                completion(false, error, nil)
            }
        }
    }
    func getDeletePost(posID:Int,completion: @escaping (Bool, String) -> ()) {
            Webservice.Social.DeletePost(posID).requestWith(parameter: [:]) { (result) in
               switch result {
                         case .success(let response):
                             completion(true, "")
                         case .fail(let error):
                             completion(false, error)
                         }
           }
       }
    func getSocialMyFriendPostList(limit:Int,offset:Int,completion: @escaping (Bool, String, [SocialPostModel]?) -> ()) {
         Webservice.Social.getFriendPostList(limit: limit, Offset: offset).requestWith(parameter: [:]) { (result) in
            switch result {
            case .success(let response):
                if let responseBody = response.body {
                    
                    if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                        let SocialData = Mapper<SocialPostModel>().mapArray(JSONArray: responceData)
                        completion(true, "", SocialData)
                    }
                    
                } else {
                    print("Fail")
                    completion(false, response.message, nil)
                }
            case .fail(let error):
                completion(false, error, nil)
            }
        }
    }
    func likeDislikePost(postId:Int, is_like: String,Type:String, completion: @escaping (Bool,String,NSDictionary) -> ()) {
           let params = ["id":postId,
               "type":Type,
               "is_like":is_like] as [String : Any]
           Webservice.Social.LikeDislikePost.requestWith(parameter: params) { (result) in
               switch result {
               case .success(let response):
                if let responseBody = response.body
                                    {
                                        if let data = (responseBody as? NSDictionary)?.value(forKey: "data") as? NSDictionary
                                        {
                                           completion(true, "",data)
                                       }
                                    }
                 
               case .fail(let error):
                completion(false, error,[:])
               }
           }
       }
    func RemoveComment(commentID:Int, completion: @escaping (Bool,String) -> ()) {
        let params = ["comment_id":commentID] as [String : Any]
        Webservice.Social.RemoveComment.requestWith(parameter: params) { (result) in
            switch result {
            case .success(let response):
                completion(true, "")
            case .fail(let error):
                completion(false, error)
            }
        }
    }
     func BlocKUser(UserID:Int, completion: @escaping (Bool,String) -> ()) {
            let params = ["user_id":UserID] as [String : Any]
            Webservice.Social.Block.requestWith(parameter: params) { (result) in
                switch result {
                case .success(let response):
                     if let responseBody = response.body
                     {
                         if let message = (responseBody as? NSDictionary)?.value(forKey: "message") as? String
                         {
                            completion(true, message)
                        }
                     }
                    
                case .fail(let error):
                    completion(false, error)
                }
            }
        }
    func FollowPost(UserID:Int,Type:String,completion: @escaping (Bool,String,NSDictionary?) -> ())
    {
        let params = ["profile_id":UserID,
                      "is_follow":Type] as [String : Any]
        Webservice.Social.FollowPost.requestWith(parameter: params) { (result) in
           switch result {
             case .success(let response):
                 if let responseBody = response.body {
                     
                if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [String: Any]
                     {
                        let strMessage = (responseBody as? NSDictionary)?.value(forKey: "message") as! String
                        completion(true,strMessage,responceData as NSDictionary)
                    }
                     
                 } else {
                     print("Fail")
                     completion(false, response.message, nil)
                 }
             case .fail(let error):
                 completion(false, error, nil)
             }
        }
    }
    func ReportPost(postID:Int,subject:String,description:String,completion: @escaping (Bool,String,NSDictionary?) -> ())
    {
        let params = ["post_id":postID,
                      "subject":subject,
                      "description":description] as [String : Any]
        Webservice.Social.PostReport.requestWith(parameter: params) { (result) in
           switch result {
             case .success(let response):
                 if let responseBody = response.body {
                     
                if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [String: Any]
                     {
                        let strMessage = (responseBody as? NSDictionary)?.value(forKey: "message") as! String
                        completion(true,strMessage,responceData as NSDictionary)
                    }
                     
                 } else {
                     print("Fail")
                     completion(false, response.message, nil)
                 }
             case .fail(let error):
                 completion(false, error, nil)
             }
        }
    }
    
    func SearchPostList(strSearch:String,completion: @escaping (Bool, String, [SocialPostModel]?) -> ())
    {
        let params = ["keyword":strSearch,
                    "limit":100,
                    "offset":""] as [String : Any]
         Webservice.Social.SearchPost.requestWith(parameter: params) { (result) in
            switch result {
            case .success(let response):
                if let responseBody = response.body {
                    
                    if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                        let SocialData = Mapper<SocialPostModel>().mapArray(JSONArray: responceData)
                        completion(true, "", SocialData)
                    }
                    
                } else {
                    print("Fail")
                    completion(false, response.message, nil)
                }
            case .fail(let error):
                completion(false, error, nil)
            }
        }
    }
    func EditPost(DeleteID:String,PostID:String,categoryID:String,Desc:String,arrMedia:[PostMediaModel],completion: @escaping (Bool, String) -> ()) {
           
              let params = [
                "id":PostID,
                "catgory_id":categoryID,
                "description":Desc,
                "delete_media":DeleteID
                         ] as [String : Any]
                
                var multipartItems = [MultipartFormData]()
                
            for i in arrMedia
                {
                    if i.MediaType == "image"
                    {
                        let profileImageData  = MultipartFormData(data: i.MediaData!, fileName: "image.jpg", name: "media[]", mimeType: .image_jpeg)
                          multipartItems.append(profileImageData)
                    }
                    else
                    {
    //                     multipartFormData.append(self.imageData, withName: "file", fileName: "video.mov", mimeType: "video/mov")
                        let profileImageData  = MultipartFormData(data: i.MediaData!, fileName: "video.mp4", name: "media[]", mimeType: .video_mp4)
                          multipartItems.append(profileImageData)
                    }
                }
                
                Webservice.Social.EditPost.requestWith(multipart: multipartItems, parameter: params) { (result) in
                    switch result {
                    case .success(let response):
                        
                        if let responseBody = response.body
                                            {
                                                if let message = (responseBody as? NSDictionary)?.value(forKey: "message") as? String
                                                {
                                                   completion(true, message)
                                               }
                                            }
                    case .fail(let error):
                        completion(false, error)
                    }
                }
        }
    func AddPost(categoryID:String,Desc:String,arrMedia:[PostMediaModel],completion: @escaping (Bool, String) -> ()) {
       
          let params = ["catgory_id":categoryID,
                         "description":Desc,
                     ] as [String : Any]
            
            var multipartItems = [MultipartFormData]()
            
        for i in arrMedia
            {
                if i.MediaType == "image"
                {
                    let profileImageData  = MultipartFormData(data: i.MediaData!, fileName: "image.jpg", name: "media[]", mimeType: .image_jpeg)
                      multipartItems.append(profileImageData)
                }
                else
                {
//                     multipartFormData.append(self.imageData, withName: "file", fileName: "video.mov", mimeType: "video/mov")
                    let profileImageData  = MultipartFormData(data: i.MediaData!, fileName: "video.mp4", name: "media[]", mimeType: .video_mp4)
                      multipartItems.append(profileImageData)
                }
            }
            
            Webservice.Social.CreatePost.requestWith(multipart: multipartItems, parameter: params) { (result) in
                switch result {
                case .success(let response):
                    
                    if let responseBody = response.body
                                        {
                                            if let message = (responseBody as? NSDictionary)?.value(forKey: "message") as? String
                                            {
                                               completion(true, message)
                                           }
                                        }
                case .fail(let error):
                    completion(false, error)
                }
            }
    }
    func getUserProfileDetail(userID:Int,completion: @escaping (Bool, String, UserProfilePostModel?) -> ()) {
         Webservice.Social.getUserProfileList(userID).requestWith(parameter: [:]) { (result) in
            switch result {
            case .success(let response):
                if let responseBody = response.body {
                    
                    if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [String: Any] {
                        let SocialData = Mapper<UserProfilePostModel>().map(JSON: responceData)
                        completion(true, "", SocialData)
                        print(responceData)
                        
                    }
                    
                } else {
                    print("Fail")
                    completion(false, response.message, nil)
                }
            case .fail(let error):
                completion(false, error, nil)
            }
        }
    }
    func UserBlockList(strSearch:String,completion: @escaping (Bool, String, [SocialUserModel]?) -> ()) {
            let params = ["search":strSearch,
                          "limit":20,
                        "offset":0] as [String : Any]
          Webservice.Social.BlockList.requestWith(parameter: params)
           { (result) in
               switch result {
               case .success(let response):
                   if let responseBody = response.body {
                       
                       if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                           let SocialData = Mapper<SocialUserModel>().mapArray(JSONArray: responceData)
                           completion(true, "", SocialData)
                       }
                       
                   } else {
                       print("Fail")
                       completion(false, response.message, nil)
                   }
               case .fail(let error):
                   completion(false, error, nil)
               }
           }
       }
    func UserFollowingList(strSearch:String,completion: @escaping (Bool, String, [SocialUserModel]?) -> ()) {
               let params = ["keyword":strSearch,
                             "limit":20,
                           "offset":0] as [String : Any]
             Webservice.Social.FollowingList.requestWith(parameter: params)
              { (result) in
                  switch result {
                  case .success(let response):
                      if let responseBody = response.body {
                          
                          if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                              let SocialData = Mapper<SocialUserModel>().mapArray(JSONArray: responceData)
                              completion(true, "", SocialData)
                          }
                          
                      } else {
                          print("Fail")
                          completion(false, response.message, nil)
                      }
                  case .fail(let error):
                      completion(false, error, nil)
                  }
              }
          }
    func UserFollowersList(strSearch:String,completion: @escaping (Bool, String, [SocialUserModel]?) -> ()) {
               let params = ["keyword":strSearch,
                             "limit":"",
                           "offset":""] as [String : Any]
             Webservice.Social.FollowersList.requestWith(parameter: params)
              { (result) in
                  switch result {
                  case .success(let response):
                      if let responseBody = response.body {
                          
                          if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                              let SocialData = Mapper<SocialUserModel>().mapArray(JSONArray: responceData)
                              completion(true, "", SocialData)
                          }
                          
                      } else {
                          print("Fail")
                          completion(false, response.message, nil)
                      }
                  case .fail(let error):
                      completion(false, error, nil)
                  }
              }
          }
    func RoomListing(limit:Int,offset:Int,completion: @escaping (Bool, String, [RoomHistoryModel]?) -> ()) {
         let params = ["type":"social",
                       "limit":limit,
                     "offset":offset] as [String : Any]
       Webservice.Social.RoomListing.requestWith(parameter: params)
        { (result) in
            switch result {
            case .success(let response):
                if let responseBody = response.body {
                    
                    if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                        let SocialData = Mapper<RoomHistoryModel>().mapArray(JSONArray: responceData)
                        completion(true, "", SocialData)
                    }
                    
                } else {
                    print("Fail")
                    completion(false, response.message, nil)
                }
            case .fail(let error):
                completion(false, error, nil)
            }
        }
    }
    
    func RoomHistory(userID:Int,limit:Int,offset:Int,product_id:Int,completion: @escaping (Bool,String,NSDictionary?) -> ())
    {
        let params = ["to_user_id":userID,
                      "limit":limit,
                      "offset":offset,"product_id":product_id] as [String : Any]
        Webservice.Social.RoomHistory.requestWith(parameter: params) { (result) in
           switch result {
             case .success(let response):
                 if let responseBody = response.body {
                     
                if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [String: Any]
                     {
                        let strMessage = (responseBody as? NSDictionary)?.value(forKey: "message") as! String
                        completion(true,strMessage,responceData as NSDictionary)
                    }
                     
                 } else {
                     print("Fail")
                     completion(false, response.message, nil)
                 }
             case .fail(let error):
                 completion(false, error, nil)
             }
        }
    }

   func likeDislikeProfile(UserID:Int,Type:String, completion: @escaping (Bool,String,NSDictionary) -> ()) {
       let params = ["user_id":UserID,
           "type":Type,
           ] as [String : Any]
       Webservice.Social.LikeDislikeProfile.requestWith(parameter: params) { (result) in
           switch result {
           case .success(let response):
            if let responseBody = response.body
                                {
                                    if let data = (responseBody as? NSDictionary)?.value(forKey: "data") as? NSDictionary
                                    {
                                       completion(true, "",data)
                                   }
                                }
             
           case .fail(let error):
            completion(false, error,[:])
           }
       }
   }
    func SearchFriendList(strSearch:String,completion: @escaping (Bool, String, [SocialUserModel]?) -> ())
    {
        let params = ["keyword":strSearch,
                    "limit":100,
                    "offset":""] as [String : Any]
         Webservice.Social.SearchFriend.requestWith(parameter: params) { (result) in
            switch result {
            case .success(let response):
                if let responseBody = response.body {
                    
                    if let responceData = (responseBody as? NSDictionary)?.value(forKey: "data") as? [[String: Any]] {
                        let SocialData = Mapper<SocialUserModel>().mapArray(JSONArray: responceData)
                        completion(true, "", SocialData)
                    }
                    
                } else {
                    print("Fail")
                    completion(false, response.message, nil)
                }
            case .fail(let error):
                completion(false, error, nil)
            }
        }
    }
}
