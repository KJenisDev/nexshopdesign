//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ShopModel : NSObject, NSCoding, Mappable{

	var address : String?
	var city : AnyObject?
	var createdAt : String?
	var descriptionField : AnyObject?
	var facebook : AnyObject?
	var google : AnyObject?
	var id : Int?
	var logo : AnyObject?
	var metaDescription : String?
	var metaTitle : String?
	var name : String?
	var pickupAddress : String?
	var pickupAddress2 : String?
	var pickupCity : String?
	var pickupCountry : String?
	var pickupLandmark : String?
	var pickupLocation : String?
	var pickupPostalCode : String?
	var pickupState : String?
	var shiprocketAddressId : String?
	var shopType : String?
	var sliders : AnyObject?
	var slug : String?
	var twitter : AnyObject?
	var updatedAt : String?
	var userId : String?
	var youtube : AnyObject?
    


	
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		address <- map["address"]
		city <- map["city"]
		createdAt <- map["created_at"]
		descriptionField <- map["description"]
		facebook <- map["facebook"]
		google <- map["google"]
		id <- map["id"]
		logo <- map["logo"]
		metaDescription <- map["meta_description"]
		metaTitle <- map["meta_title"]
		name <- map["name"]
		pickupAddress <- map["pickup_address"]
		pickupAddress2 <- map["pickup_address_2"]
		pickupCity <- map["pickup_city"]
		pickupCountry <- map["pickup_country"]
		pickupLandmark <- map["pickup_landmark"]
		pickupLocation <- map["pickup_location"]
		pickupPostalCode <- map["pickup_postal_code"]
		pickupState <- map["pickup_state"]
		shiprocketAddressId <- map["shiprocket_address_id"]
		shopType <- map["shop_type"]
		sliders <- map["sliders"]
		slug <- map["slug"]
		twitter <- map["twitter"]
		updatedAt <- map["updated_at"]
		userId <- map["user_id"]
		youtube <- map["youtube"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         address = aDecoder.decodeObject(forKey: "address") as? String
         city = aDecoder.decodeObject(forKey: "city") as? AnyObject
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? AnyObject
         facebook = aDecoder.decodeObject(forKey: "facebook") as? AnyObject
         google = aDecoder.decodeObject(forKey: "google") as? AnyObject
         id = aDecoder.decodeObject(forKey: "id") as? Int
         logo = aDecoder.decodeObject(forKey: "logo") as? AnyObject
         metaDescription = aDecoder.decodeObject(forKey: "meta_description") as? String
         metaTitle = aDecoder.decodeObject(forKey: "meta_title") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         pickupAddress = aDecoder.decodeObject(forKey: "pickup_address") as? String
         pickupAddress2 = aDecoder.decodeObject(forKey: "pickup_address_2") as? String
         pickupCity = aDecoder.decodeObject(forKey: "pickup_city") as? String
         pickupCountry = aDecoder.decodeObject(forKey: "pickup_country") as? String
         pickupLandmark = aDecoder.decodeObject(forKey: "pickup_landmark") as? String
         pickupLocation = aDecoder.decodeObject(forKey: "pickup_location") as? String
         pickupPostalCode = aDecoder.decodeObject(forKey: "pickup_postal_code") as? String
         pickupState = aDecoder.decodeObject(forKey: "pickup_state") as? String
         shiprocketAddressId = aDecoder.decodeObject(forKey: "shiprocket_address_id") as? String
         shopType = aDecoder.decodeObject(forKey: "shop_type") as? String
         sliders = aDecoder.decodeObject(forKey: "sliders") as? AnyObject
         slug = aDecoder.decodeObject(forKey: "slug") as? String
         twitter = aDecoder.decodeObject(forKey: "twitter") as? AnyObject
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? String
         youtube = aDecoder.decodeObject(forKey: "youtube") as? AnyObject

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if address != nil{
			aCoder.encode(address, forKey: "address")
		}
		if city != nil{
			aCoder.encode(city, forKey: "city")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if facebook != nil{
			aCoder.encode(facebook, forKey: "facebook")
		}
		if google != nil{
			aCoder.encode(google, forKey: "google")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if logo != nil{
			aCoder.encode(logo, forKey: "logo")
		}
		if metaDescription != nil{
			aCoder.encode(metaDescription, forKey: "meta_description")
		}
		if metaTitle != nil{
			aCoder.encode(metaTitle, forKey: "meta_title")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if pickupAddress != nil{
			aCoder.encode(pickupAddress, forKey: "pickup_address")
		}
		if pickupAddress2 != nil{
			aCoder.encode(pickupAddress2, forKey: "pickup_address_2")
		}
		if pickupCity != nil{
			aCoder.encode(pickupCity, forKey: "pickup_city")
		}
		if pickupCountry != nil{
			aCoder.encode(pickupCountry, forKey: "pickup_country")
		}
		if pickupLandmark != nil{
			aCoder.encode(pickupLandmark, forKey: "pickup_landmark")
		}
		if pickupLocation != nil{
			aCoder.encode(pickupLocation, forKey: "pickup_location")
		}
		if pickupPostalCode != nil{
			aCoder.encode(pickupPostalCode, forKey: "pickup_postal_code")
		}
		if pickupState != nil{
			aCoder.encode(pickupState, forKey: "pickup_state")
		}
		if shiprocketAddressId != nil{
			aCoder.encode(shiprocketAddressId, forKey: "shiprocket_address_id")
		}
		if shopType != nil{
			aCoder.encode(shopType, forKey: "shop_type")
		}
		if sliders != nil{
			aCoder.encode(sliders, forKey: "sliders")
		}
		if slug != nil{
			aCoder.encode(slug, forKey: "slug")
		}
		if twitter != nil{
			aCoder.encode(twitter, forKey: "twitter")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}
		if youtube != nil{
			aCoder.encode(youtube, forKey: "youtube")
		}

	}

}
