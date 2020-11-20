//
//	RecentlyViewItem.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class RecentlyViewItem : NSObject, NSCoding{

	var brand : String!
	var discount : Int!
	var discountType : String!
	var id : Int!
	var name : String!
	var price : Int!
	var review : Int!
	var thumbnailImg : String!
	var totalReviews : Int!
	var unitPrice : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		brand = dictionary["brand"] as? String
		discount = dictionary["discount"] as? Int
		discountType = dictionary["discount_type"] as? String
		id = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		price = dictionary["price"] as? Int
		review = dictionary["review"] as? Int
		thumbnailImg = dictionary["thumbnail_img"] as? String
		totalReviews = dictionary["total_reviews"] as? Int
		unitPrice = dictionary["unit_price"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if brand != nil{
			dictionary["brand"] = brand
		}
		if discount != nil{
			dictionary["discount"] = discount
		}
		if discountType != nil{
			dictionary["discount_type"] = discountType
		}
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if price != nil{
			dictionary["price"] = price
		}
		if review != nil{
			dictionary["review"] = review
		}
		if thumbnailImg != nil{
			dictionary["thumbnail_img"] = thumbnailImg
		}
		if totalReviews != nil{
			dictionary["total_reviews"] = totalReviews
		}
		if unitPrice != nil{
			dictionary["unit_price"] = unitPrice
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         brand = aDecoder.decodeObject(forKey: "brand") as? String
         discount = aDecoder.decodeObject(forKey: "discount") as? Int
         discountType = aDecoder.decodeObject(forKey: "discount_type") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         price = aDecoder.decodeObject(forKey: "price") as? Int
         review = aDecoder.decodeObject(forKey: "review") as? Int
         thumbnailImg = aDecoder.decodeObject(forKey: "thumbnail_img") as? String
         totalReviews = aDecoder.decodeObject(forKey: "total_reviews") as? Int
         unitPrice = aDecoder.decodeObject(forKey: "unit_price") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if brand != nil{
			aCoder.encode(brand, forKey: "brand")
		}
		if discount != nil{
			aCoder.encode(discount, forKey: "discount")
		}
		if discountType != nil{
			aCoder.encode(discountType, forKey: "discount_type")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if review != nil{
			aCoder.encode(review, forKey: "review")
		}
		if thumbnailImg != nil{
			aCoder.encode(thumbnailImg, forKey: "thumbnail_img")
		}
		if totalReviews != nil{
			aCoder.encode(totalReviews, forKey: "total_reviews")
		}
		if unitPrice != nil{
			aCoder.encode(unitPrice, forKey: "unit_price")
		}

	}

}