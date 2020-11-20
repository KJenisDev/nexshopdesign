//
//	VariationsModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class VariationsModel : NSObject, NSCoding{

	var name : String!
	var options : [String]!
	var title : String!
    var isSelectedindex : Int = 0


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		name = dictionary["name"] as? String
		options = dictionary["options"] as? [String]
		title = dictionary["title"] as? String
        isSelectedindex = 0
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if name != nil{
			dictionary["name"] = name
		}
		if options != nil{
			dictionary["options"] = options
		}
		if title != nil{
			dictionary["title"] = title
		}
        if isSelectedindex != nil{
            isSelectedindex = 0
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         name = aDecoder.decodeObject(forKey: "name") as? String
         options = aDecoder.decodeObject(forKey: "options") as? [String]
         title = aDecoder.decodeObject(forKey: "title") as? String
        isSelectedindex = 0

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if options != nil{
			aCoder.encode(options, forKey: "options")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}
        if isSelectedindex != nil{
            isSelectedindex = 0
        }

	}

}
