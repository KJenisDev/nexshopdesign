//
//	Todaysdeal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TodaysDeal : NSObject, NSCoding{

    var id : Int!
    var price : NSNumber!
    var thumbnailImg : String!
    var discountType : String!
    var review : NSNumber!
    var cat_name : String!
    var cat_id : String!
    var is_wishlisted : Int!
    var discount : NSNumber!
    var totalReviews : Int!
    var wishlist_item_id : Int!
    var unitPrice : NSNumber!
	var brand : String!
	var name : String!
    var variations : [VariationsModel]!
	
	
	
	
	


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		brand = dictionary["brand"] as? String
		discount = dictionary["discount"] as? NSNumber
		discountType = dictionary["discount_type"] as? String
		id = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		price = dictionary["price"] as? NSNumber
		review = dictionary["review"] as? NSNumber
		thumbnailImg = dictionary["thumbnail_img"] as? String
        cat_name = dictionary["cat_name"] as? String
        cat_id = dictionary["cat_id"] as? String
		totalReviews = dictionary["total_reviews"] as? Int
		unitPrice = dictionary["unit_price"] as? NSNumber
        is_wishlisted = dictionary["is_wishlisted"] as? Int
        wishlist_item_id = dictionary["wishlist_item_id"] as? Int
        variations = [VariationsModel]()
        if let variationsArray = dictionary["variations"] as? [[String:Any]]{
            for dic in variationsArray{
                let value = VariationsModel(fromDictionary: dic)
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
        if cat_name != nil{
            dictionary["cat_name"] = cat_name
        }
        if cat_id != nil{
            dictionary["cat_id"] = cat_id
        }
        if is_wishlisted != nil{
            dictionary["is_wishlisted"] = is_wishlisted
        }
        if wishlist_item_id != nil{
            dictionary["wishlist_item_id"] = wishlist_item_id
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
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         price = aDecoder.decodeObject(forKey: "price") as? NSNumber
         review = aDecoder.decodeObject(forKey: "review") as? NSNumber
         thumbnailImg = aDecoder.decodeObject(forKey: "thumbnail_img") as? String
        cat_name = aDecoder.decodeObject(forKey: "cat_name") as? String
         totalReviews = aDecoder.decodeObject(forKey: "total_reviews") as? Int
         unitPrice = aDecoder.decodeObject(forKey: "unit_price") as? NSNumber
        cat_id = aDecoder.decodeObject(forKey: "cat_id") as? String
        is_wishlisted = aDecoder.decodeObject(forKey: "is_wishlisted") as? Int
        wishlist_item_id = aDecoder.decodeObject(forKey: "wishlist_item_id") as? Int
        variations = aDecoder.decodeObject(forKey :"variations") as? [VariationsModel]
        

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
        if cat_name != nil{
            aCoder.encode(cat_name, forKey: "cat_name")
        }
        if cat_id != nil{
            aCoder.encode(cat_id, forKey: "cat_id")
        }
        if is_wishlisted != nil{
            aCoder.encode(is_wishlisted, forKey: "is_wishlisted")
        }
        if wishlist_item_id != nil{
            aCoder.encode(wishlist_item_id, forKey: "wishlist_item_id")
        }
        if variations != nil{
            aCoder.encode(variations, forKey: "variations")
        }
        
	}

}
