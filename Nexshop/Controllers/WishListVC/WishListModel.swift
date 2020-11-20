//
//	WishListModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class WishListModel : NSObject, NSCoding{

	var brand : String!
	var discount : NSNumber!
	var discountType : String!
	var itemId : Int!
	var name : String!
	var price : NSNumber!
	var productId : Int!
	var review : NSNumber!
	var thumbnailImg : String!
	var totalReviews : Int!
	var unitPrice : NSNumber!
	var variations : [Variation]!
    var qty : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		brand = dictionary["brand"] as? String
		discount = dictionary["discount"] as? NSNumber
		discountType = dictionary["discount_type"] as? String
		itemId = dictionary["item_id"] as? Int
		name = dictionary["name"] as? String
		price = dictionary["price"] as? NSNumber
		productId = dictionary["product_id"] as? Int
		review = dictionary["review"] as? NSNumber
		thumbnailImg = dictionary["thumbnail_img"] as? String
		totalReviews = dictionary["total_reviews"] as? Int
		unitPrice = dictionary["unit_price"] as? NSNumber
        qty = dictionary["qty"] as? String
		variations = [Variation]()
		if let variationsArray = dictionary["variations"] as? [[String:Any]]{
			for dic in variationsArray{
				let value = Variation(fromDictionary: dic)
				variations.append(value)
			}
		}
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
		if itemId != nil{
			dictionary["item_id"] = itemId
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
        if qty != nil{
            dictionary["qty"] = qty
        }
		if variations != nil{
			var dictionaryElements = [[String:Any]]()
			for variationsElement in variations {
				dictionaryElements.append(variationsElement.toDictionary())
			}
			dictionary["variations"] = dictionaryElements
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
         discount = aDecoder.decodeObject(forKey: "discount") as? NSNumber
         discountType = aDecoder.decodeObject(forKey: "discount_type") as? String
         itemId = aDecoder.decodeObject(forKey: "item_id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         price = aDecoder.decodeObject(forKey: "price") as? NSNumber
         productId = aDecoder.decodeObject(forKey: "product_id") as? Int
         review = aDecoder.decodeObject(forKey: "review") as? NSNumber
         thumbnailImg = aDecoder.decodeObject(forKey: "thumbnail_img") as? String
         totalReviews = aDecoder.decodeObject(forKey: "total_reviews") as? Int
         unitPrice = aDecoder.decodeObject(forKey: "unit_price") as? NSNumber
        qty = aDecoder.decodeObject(forKey: "qty") as? String
         variations = aDecoder.decodeObject(forKey :"variations") as? [Variation]

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
		if itemId != nil{
			aCoder.encode(itemId, forKey: "item_id")
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
		if variations != nil{
			aCoder.encode(variations, forKey: "variations")
		}
        if qty != nil{
            aCoder.encode(qty, forKey: "qty")
        }

	}

}
