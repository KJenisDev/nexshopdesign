//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class NotificationModel : NSObject, NSCoding{

	var createdAt : String!
	var extra : String!
	var fromUser : AnyObject!
	var fromUserId : String!
	var id : Int!
	var message : String!
	var objectId : String!
	var pushType : String!
	var updatedAt : String!
	var userId : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdAt = dictionary["created_at"] as? String
		extra = dictionary["extra"] as? String
		fromUser = dictionary["from_user"] as? AnyObject
		fromUserId = dictionary["from_user_id"] as? String
		id = dictionary["id"] as? Int
		message = dictionary["message"] as? String
		objectId = dictionary["object_id"] as? String
		pushType = dictionary["push_type"] as? String
		updatedAt = dictionary["updated_at"] as? String
		userId = dictionary["user_id"] as? String
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
		if extra != nil{
			dictionary["extra"] = extra
		}
		if fromUser != nil{
			dictionary["from_user"] = fromUser
		}
		if fromUserId != nil{
			dictionary["from_user_id"] = fromUserId
		}
		if id != nil{
			dictionary["id"] = id
		}
		if message != nil{
			dictionary["message"] = message
		}
		if objectId != nil{
			dictionary["object_id"] = objectId
		}
		if pushType != nil{
			dictionary["push_type"] = pushType
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if userId != nil{
			dictionary["user_id"] = userId
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
         extra = aDecoder.decodeObject(forKey: "extra") as? String
         fromUser = aDecoder.decodeObject(forKey: "from_user") as? AnyObject
         fromUserId = aDecoder.decodeObject(forKey: "from_user_id") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         message = aDecoder.decodeObject(forKey: "message") as? String
         objectId = aDecoder.decodeObject(forKey: "object_id") as? String
         pushType = aDecoder.decodeObject(forKey: "push_type") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? String

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
		if extra != nil{
			aCoder.encode(extra, forKey: "extra")
		}
		if fromUser != nil{
			aCoder.encode(fromUser, forKey: "from_user")
		}
		if fromUserId != nil{
			aCoder.encode(fromUserId, forKey: "from_user_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if objectId != nil{
			aCoder.encode(objectId, forKey: "object_id")
		}
		if pushType != nil{
			aCoder.encode(pushType, forKey: "push_type")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
