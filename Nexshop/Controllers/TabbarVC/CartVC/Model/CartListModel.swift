//
//	CartListModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CartListModel : NSObject, NSCoding{

	var itemId : Int!
	var price : String!
	var productId : Int!
	var productName : String!
	var qty : String!
	var subtotal : Int!
	var thumbnailImg : String!
	var variation : [AnyObject]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		itemId = dictionary["item_id"] as? Int
		price = dictionary["price"] as? String
		productId = dictionary["product_id"] as? Int
		productName = dictionary["product_name"] as? String
		qty = dictionary["qty"] as? String
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
		if itemId != nil{
			dictionary["item_id"] = itemId
		}
		if price != nil{
			dictionary["price"] = price
		}
		if productId != nil{
			dictionary["product_id"] = productId
		}
		if productName != nil{
			dictionary["product_name"] = productName
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
         itemId = aDecoder.decodeObject(forKey: "item_id") as? Int
         price = aDecoder.decodeObject(forKey: "price") as? String
         productId = aDecoder.decodeObject(forKey: "product_id") as? Int
         productName = aDecoder.decodeObject(forKey: "product_name") as? String
         qty = aDecoder.decodeObject(forKey: "qty") as? String
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
		if itemId != nil{
			aCoder.encode(itemId, forKey: "item_id")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if productId != nil{
			aCoder.encode(productId, forKey: "product_id")
		}
		if productName != nil{
			aCoder.encode(productName, forKey: "product_name")
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
