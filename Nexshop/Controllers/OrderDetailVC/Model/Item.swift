//
//	Item.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Item : NSObject, NSCoding{

	var isReviewAdded : Int!
	var name : String!
	var price : Int!
	var productId : Int!
	var qty : Int!
	var subtotal : Int!
	var thumbnailImg : String!
	var variation : [AnyObject]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		isReviewAdded = dictionary["is_review_added"] as? Int
		name = dictionary["name"] as? String
		price = dictionary["price"] as? Int
		productId = dictionary["product_id"] as? Int
		qty = dictionary["qty"] as? Int
		subtotal = dictionary["subtotal"] as? Int
		thumbnailImg = dictionary["thumbnail_img"] as? String
		variation = dictionary["variation"] as? [AnyObject]
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if isReviewAdded != nil{
			dictionary["is_review_added"] = isReviewAdded
		}
		if name != nil{
			dictionary["name"] = name
		}
		if price != nil{
			dictionary["price"] = price
		}
		if productId != nil{
			dictionary["product_id"] = productId
		}
		if qty != nil{
			dictionary["qty"] = qty
		}
		if subtotal != nil{
			dictionary["subtotal"] = subtotal
		}
		if thumbnailImg != nil{
			dictionary["thumbnail_img"] = thumbnailImg
		}
		if variation != nil{
			dictionary["variation"] = variation
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         isReviewAdded = aDecoder.decodeObject(forKey: "is_review_added") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         price = aDecoder.decodeObject(forKey: "price") as? Int
         productId = aDecoder.decodeObject(forKey: "product_id") as? Int
         qty = aDecoder.decodeObject(forKey: "qty") as? Int
         subtotal = aDecoder.decodeObject(forKey: "subtotal") as? Int
         thumbnailImg = aDecoder.decodeObject(forKey: "thumbnail_img") as? String
         variation = aDecoder.decodeObject(forKey: "variation") as? [AnyObject]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if isReviewAdded != nil{
			aCoder.encode(isReviewAdded, forKey: "is_review_added")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if productId != nil{
			aCoder.encode(productId, forKey: "product_id")
		}
		if qty != nil{
			aCoder.encode(qty, forKey: "qty")
		}
		if subtotal != nil{
			aCoder.encode(subtotal, forKey: "subtotal")
		}
		if thumbnailImg != nil{
			aCoder.encode(thumbnailImg, forKey: "thumbnail_img")
		}
		if variation != nil{
			aCoder.encode(variation, forKey: "variation")
		}

	}

}