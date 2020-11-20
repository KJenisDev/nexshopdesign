//
//	Media.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Media : NSObject, NSCoding{

	var file : String!
	var id : Int!
	var mediaType : String!
    var media_type : String?
    var post_id : Int?

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		file = dictionary["file"] as? String
		id = dictionary["id"] as? Int
		mediaType = dictionary["media_type"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if file != nil{
			dictionary["file"] = file
		}
		if id != nil{
			dictionary["id"] = id
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
         file = aDecoder.decodeObject(forKey: "file") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         mediaType = aDecoder.decodeObject(forKey: "media_type") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if file != nil{
			aCoder.encode(file, forKey: "file")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if mediaType != nil{
			aCoder.encode(mediaType, forKey: "media_type")
		}

	}

}
