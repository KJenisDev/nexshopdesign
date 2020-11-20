//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class FeedModel : NSObject, NSCoding{

	var createdAt : String!
	var descriptionField : String!
	var exploreCategory : ExploreCategory!
	var id : Int!
	var isLike : Int!
	var media : [Media]!
	var totalComments : Int!
	var totalLikes : Int!
	var user : User!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdAt = dictionary["created_at"] as? String
		descriptionField = dictionary["description"] as? String
		if let exploreCategoryData = dictionary["explore_category"] as? [String:Any]{
			exploreCategory = ExploreCategory(fromDictionary: exploreCategoryData)
		}
		id = dictionary["id"] as? Int
		isLike = dictionary["is_like"] as? Int
		media = [Media]()
		if let mediaArray = dictionary["media"] as? [[String:Any]]{
			for dic in mediaArray{
				let value = Media(fromDictionary: dic)
				media.append(value)
			}
		}
		totalComments = dictionary["total_comments"] as? Int
		totalLikes = dictionary["total_likes"] as? Int
		if let userData = dictionary["user"] as? [String:Any]{
			user = User(fromDictionary: userData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if exploreCategory != nil{
			dictionary["explore_category"] = exploreCategory.toDictionary()
		}
		if id != nil{
			dictionary["id"] = id
		}
		if isLike != nil{
			dictionary["is_like"] = isLike
		}
		if media != nil{
			var dictionaryElements = [[String:Any]]()
			for mediaElement in media {
				dictionaryElements.append(mediaElement.toDictionary())
			}
			dictionary["media"] = dictionaryElements
		}
		if totalComments != nil{
			dictionary["total_comments"] = totalComments
		}
		if totalLikes != nil{
			dictionary["total_likes"] = totalLikes
		}
		if user != nil{
			dictionary["user"] = user.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         exploreCategory = aDecoder.decodeObject(forKey: "explore_category") as? ExploreCategory
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isLike = aDecoder.decodeObject(forKey: "is_like") as? Int
         media = aDecoder.decodeObject(forKey :"media") as? [Media]
         totalComments = aDecoder.decodeObject(forKey: "total_comments") as? Int
         totalLikes = aDecoder.decodeObject(forKey: "total_likes") as? Int
         user = aDecoder.decodeObject(forKey: "user") as? User

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if exploreCategory != nil{
			aCoder.encode(exploreCategory, forKey: "explore_category")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if isLike != nil{
			aCoder.encode(isLike, forKey: "is_like")
		}
		if media != nil{
			aCoder.encode(media, forKey: "media")
		}
		if totalComments != nil{
			aCoder.encode(totalComments, forKey: "total_comments")
		}
		if totalLikes != nil{
			aCoder.encode(totalLikes, forKey: "total_likes")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}
