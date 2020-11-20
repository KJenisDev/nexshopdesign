//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BanneraftertoppickModel : NSObject, NSCoding{

	var clickObjectId : String!
	var clickType : String!
	var file : String!
	var mediaType : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		clickObjectId = dictionary["click_object_id"] as? String
		clickType = dictionary["click_type"] as? String
		file = dictionary["file"] as? String
		mediaType = dictionary["media_type"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if clickObjectId != nil{
			dictionary["click_object_id"] = clickObjectId
		}
		if clickType != nil{
			dictionary["click_type"] = clickType
		}
		if file != nil{
			dictionary["file"] = file
		}
		if mediaType != nil{
			dictionary["media_type"] = mediaType
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         clickObjectId = aDecoder.decodeObject(forKey: "click_object_id") as? String
         clickType = aDecoder.decodeObject(forKey: "click_type") as? String
         file = aDecoder.decodeObject(forKey: "file") as? String
         mediaType = aDecoder.decodeObject(forKey: "media_type") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if clickObjectId != nil{
			aCoder.encode(clickObjectId, forKey: "click_object_id")
		}
		if clickType != nil{
			aCoder.encode(clickType, forKey: "click_type")
		}
		if file != nil{
			aCoder.encode(file, forKey: "file")
		}
		if mediaType != nil{
			aCoder.encode(mediaType, forKey: "media_type")
		}

	}

}
