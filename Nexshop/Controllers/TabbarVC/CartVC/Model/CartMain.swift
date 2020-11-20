//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CartMain : NSObject, NSCoding{

	var cart : Cart!
	var recentlyViewItems : [RecentlyViewItem]!
	var saveForLaterItems : [AnyObject]!
	var topPicks : [TodaysDeal]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let cartData = dictionary["cart"] as? [String:Any]{
			cart = Cart(fromDictionary: cartData)
		}
		recentlyViewItems = [RecentlyViewItem]()
		if let recentlyViewItemsArray = dictionary["recently_view_items"] as? [[String:Any]]{
			for dic in recentlyViewItemsArray{
				let value = RecentlyViewItem(fromDictionary: dic)
				recentlyViewItems.append(value)
			}
		}
		saveForLaterItems = dictionary["save_for_later_items"] as? [AnyObject]
		topPicks = [TodaysDeal]()
		if let topPicksArray = dictionary["top_picks"] as? [[String:Any]]{
			for dic in topPicksArray{
				let value = TodaysDeal(fromDictionary: dic)
				topPicks.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if cart != nil{
			dictionary["cart"] = cart.toDictionary()
		}
		if recentlyViewItems != nil{
			var dictionaryElements = [[String:Any]]()
			for recentlyViewItemsElement in recentlyViewItems {
				dictionaryElements.append(recentlyViewItemsElement.toDictionary())
			}
			dictionary["recently_view_items"] = dictionaryElements
		}
		if saveForLaterItems != nil{
			dictionary["save_for_later_items"] = saveForLaterItems
		}
		if topPicks != nil{
			var dictionaryElements = [[String:Any]]()
			for topPicksElement in topPicks {
				dictionaryElements.append(topPicksElement.toDictionary())
			}
			dictionary["top_picks"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cart = aDecoder.decodeObject(forKey: "cart") as? Cart
         recentlyViewItems = aDecoder.decodeObject(forKey :"recently_view_items") as? [RecentlyViewItem]
         saveForLaterItems = aDecoder.decodeObject(forKey: "save_for_later_items") as? [AnyObject]
         topPicks = aDecoder.decodeObject(forKey :"top_picks") as? [TodaysDeal]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cart != nil{
			aCoder.encode(cart, forKey: "cart")
		}
		if recentlyViewItems != nil{
			aCoder.encode(recentlyViewItems, forKey: "recently_view_items")
		}
		if saveForLaterItems != nil{
			aCoder.encode(saveForLaterItems, forKey: "save_for_later_items")
		}
		if topPicks != nil{
			aCoder.encode(topPicks, forKey: "top_picks")
		}

	}

}
