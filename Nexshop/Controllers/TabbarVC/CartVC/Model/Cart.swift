//
//	Cart.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Cart : NSObject, NSCoding{

	var cartTotal : Int!
	var grandTotal : Int!
	var items : [Item]!
	var serviceCharge : String!
	var shippingCharge : String!
	var wallet : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		cartTotal = dictionary["cart_total"] as? Int
		grandTotal = dictionary["grand_total"] as? Int
		items = [Item]()
		if let itemsArray = dictionary["items"] as? [[String:Any]]{
			for dic in itemsArray{
				let value = Item(fromDictionary: dic)
				items.append(value)
			}
		}
		serviceCharge = dictionary["service_charge"] as? String
		shippingCharge = dictionary["shipping_charge"] as? String
		wallet = dictionary["wallet"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if cartTotal != nil{
			dictionary["cart_total"] = cartTotal
		}
		if grandTotal != nil{
			dictionary["grand_total"] = grandTotal
		}
		if items != nil{
			var dictionaryElements = [[String:Any]]()
			for itemsElement in items {
				dictionaryElements.append(itemsElement.toDictionary())
			}
			dictionary["items"] = dictionaryElements
		}
		if serviceCharge != nil{
			dictionary["service_charge"] = serviceCharge
		}
		if shippingCharge != nil{
			dictionary["shipping_charge"] = shippingCharge
		}
		if wallet != nil{
			dictionary["wallet"] = wallet
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cartTotal = aDecoder.decodeObject(forKey: "cart_total") as? Int
         grandTotal = aDecoder.decodeObject(forKey: "grand_total") as? Int
         items = aDecoder.decodeObject(forKey :"items") as? [Item]
         serviceCharge = aDecoder.decodeObject(forKey: "service_charge") as? String
         shippingCharge = aDecoder.decodeObject(forKey: "shipping_charge") as? String
         wallet = aDecoder.decodeObject(forKey: "wallet") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cartTotal != nil{
			aCoder.encode(cartTotal, forKey: "cart_total")
		}
		if grandTotal != nil{
			aCoder.encode(grandTotal, forKey: "grand_total")
		}
		if items != nil{
			aCoder.encode(items, forKey: "items")
		}
		if serviceCharge != nil{
			aCoder.encode(serviceCharge, forKey: "service_charge")
		}
		if shippingCharge != nil{
			aCoder.encode(shippingCharge, forKey: "shipping_charge")
		}
		if wallet != nil{
			aCoder.encode(wallet, forKey: "wallet")
		}

	}

}