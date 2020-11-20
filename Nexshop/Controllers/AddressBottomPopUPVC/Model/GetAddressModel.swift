//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class GetAddressModel : NSObject, NSCoding{

	var city : String!
	var country : String!
	var houseNumber : String!
	var id : Int!
	var landmark : String!
	var lat : String!
	var lng : String!
	var mobileNo : String!
	var name : String!
	var state : String!
	var tag : String!
	var zipcode : String!
    var is_default: NSNumber!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		city = dictionary["city"] as? String
		country = dictionary["country"] as? String
		houseNumber = dictionary["house_number"] as? String
		id = dictionary["id"] as? Int
		landmark = dictionary["landmark"] as? String
		lat = dictionary["lat"] as? String
		lng = dictionary["lng"] as? String
		mobileNo = dictionary["mobile_no"] as? String
		name = dictionary["name"] as? String
		state = dictionary["state"] as? String
		tag = dictionary["tag"] as? String
		zipcode = dictionary["zipcode"] as? String
        is_default = dictionary["is_default"] as? NSNumber
        
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if city != nil{
			dictionary["city"] = city
		}
		if country != nil{
			dictionary["country"] = country
		}
		if houseNumber != nil{
			dictionary["house_number"] = houseNumber
		}
		if id != nil{
			dictionary["id"] = id
		}
		if landmark != nil{
			dictionary["landmark"] = landmark
		}
		if lat != nil{
			dictionary["lat"] = lat
		}
		if lng != nil{
			dictionary["lng"] = lng
		}
		if mobileNo != nil{
			dictionary["mobile_no"] = mobileNo
		}
		if name != nil{
			dictionary["name"] = name
		}
		if state != nil{
			dictionary["state"] = state
		}
		if tag != nil{
			dictionary["tag"] = tag
		}
		if zipcode != nil{
			dictionary["zipcode"] = zipcode
            
		}
        if is_default != nil{
            dictionary["is_default"] = is_default
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         city = aDecoder.decodeObject(forKey: "city") as? String
         country = aDecoder.decodeObject(forKey: "country") as? String
         houseNumber = aDecoder.decodeObject(forKey: "house_number") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         landmark = aDecoder.decodeObject(forKey: "landmark") as? String
         lat = aDecoder.decodeObject(forKey: "lat") as? String
         lng = aDecoder.decodeObject(forKey: "lng") as? String
         mobileNo = aDecoder.decodeObject(forKey: "mobile_no") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         state = aDecoder.decodeObject(forKey: "state") as? String
         tag = aDecoder.decodeObject(forKey: "tag") as? String
         zipcode = aDecoder.decodeObject(forKey: "zipcode") as? String
        is_default = aDecoder.decodeObject(forKey: "is_default") as? NSNumber
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if city != nil{
			aCoder.encode(city, forKey: "city")
		}
		if country != nil{
			aCoder.encode(country, forKey: "country")
		}
		if houseNumber != nil{
			aCoder.encode(houseNumber, forKey: "house_number")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if landmark != nil{
			aCoder.encode(landmark, forKey: "landmark")
		}
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}
		if mobileNo != nil{
			aCoder.encode(mobileNo, forKey: "mobile_no")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if state != nil{
			aCoder.encode(state, forKey: "state")
		}
		if tag != nil{
			aCoder.encode(tag, forKey: "tag")
		}
		if zipcode != nil{
			aCoder.encode(zipcode, forKey: "zipcode")
		}
        if is_default != nil{
            aCoder.encode(is_default, forKey: "is_default")
        }
        

	}

}
