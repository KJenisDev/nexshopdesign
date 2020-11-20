//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class OrderDetailModel : NSObject, NSCoding{

	var couponCode : String!
	var couponDiscount : Int!
	var date : String!
	var grandTotal : Int!
	var invoiceUrl : String!
	var itemTotal : Int!
	var items : [Item]!
	var orderId : Int!
	var orderNumber : String!
	var orderStatus : String!
	var paymentStatus : String!
	var paymentType : String!
	var serviceCharge : Int!
	var shippingAddress : ShippingAddres!
	var shippingCharge : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		couponCode = dictionary["coupon_code"] as? String
		couponDiscount = dictionary["coupon_discount"] as? Int
		date = dictionary["date"] as? String
		grandTotal = dictionary["grand_total"] as? Int
		invoiceUrl = dictionary["invoice_url"] as? String
		itemTotal = dictionary["item_total"] as? Int
		items = [Item]()
		if let itemsArray = dictionary["items"] as? [[String:Any]]{
			for dic in itemsArray{
				let value = Item(fromDictionary: dic)
				items.append(value)
			}
		}
		orderId = dictionary["order_id"] as? Int
		orderNumber = dictionary["order_number"] as? String
		orderStatus = dictionary["order_status"] as? String
		paymentStatus = dictionary["payment_status"] as? String
		paymentType = dictionary["payment_type"] as? String
		serviceCharge = dictionary["service_charge"] as? Int
		if let shippingAddressData = dictionary["shipping_address"] as? [String:Any]{
			shippingAddress = ShippingAddres(fromDictionary: shippingAddressData)
		}
		shippingCharge = dictionary["shipping_charge"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if couponCode != nil{
			dictionary["coupon_code"] = couponCode
		}
		if couponDiscount != nil{
			dictionary["coupon_discount"] = couponDiscount
		}
		if date != nil{
			dictionary["date"] = date
		}
		if grandTotal != nil{
			dictionary["grand_total"] = grandTotal
		}
		if invoiceUrl != nil{
			dictionary["invoice_url"] = invoiceUrl
		}
		if itemTotal != nil{
			dictionary["item_total"] = itemTotal
		}
		if items != nil{
			var dictionaryElements = [[String:Any]]()
			for itemsElement in items {
				dictionaryElements.append(itemsElement.toDictionary())
			}
			dictionary["items"] = dictionaryElements
		}
		if orderId != nil{
			dictionary["order_id"] = orderId
		}
		if orderNumber != nil{
			dictionary["order_number"] = orderNumber
		}
		if orderStatus != nil{
			dictionary["order_status"] = orderStatus
		}
		if paymentStatus != nil{
			dictionary["payment_status"] = paymentStatus
		}
		if paymentType != nil{
			dictionary["payment_type"] = paymentType
		}
		if serviceCharge != nil{
			dictionary["service_charge"] = serviceCharge
		}
		if shippingAddress != nil{
			dictionary["shipping_address"] = shippingAddress.toDictionary()
		}
		if shippingCharge != nil{
			dictionary["shipping_charge"] = shippingCharge
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         couponCode = aDecoder.decodeObject(forKey: "coupon_code") as? String
         couponDiscount = aDecoder.decodeObject(forKey: "coupon_discount") as? Int
         date = aDecoder.decodeObject(forKey: "date") as? String
         grandTotal = aDecoder.decodeObject(forKey: "grand_total") as? Int
         invoiceUrl = aDecoder.decodeObject(forKey: "invoice_url") as? String
         itemTotal = aDecoder.decodeObject(forKey: "item_total") as? Int
         items = aDecoder.decodeObject(forKey :"items") as? [Item]
         orderId = aDecoder.decodeObject(forKey: "order_id") as? Int
         orderNumber = aDecoder.decodeObject(forKey: "order_number") as? String
         orderStatus = aDecoder.decodeObject(forKey: "order_status") as? String
         paymentStatus = aDecoder.decodeObject(forKey: "payment_status") as? String
         paymentType = aDecoder.decodeObject(forKey: "payment_type") as? String
         serviceCharge = aDecoder.decodeObject(forKey: "service_charge") as? Int
         shippingAddress = aDecoder.decodeObject(forKey: "shipping_address") as? ShippingAddres
         shippingCharge = aDecoder.decodeObject(forKey: "shipping_charge") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if couponCode != nil{
			aCoder.encode(couponCode, forKey: "coupon_code")
		}
		if couponDiscount != nil{
			aCoder.encode(couponDiscount, forKey: "coupon_discount")
		}
		if date != nil{
			aCoder.encode(date, forKey: "date")
		}
		if grandTotal != nil{
			aCoder.encode(grandTotal, forKey: "grand_total")
		}
		if invoiceUrl != nil{
			aCoder.encode(invoiceUrl, forKey: "invoice_url")
		}
		if itemTotal != nil{
			aCoder.encode(itemTotal, forKey: "item_total")
		}
		if items != nil{
			aCoder.encode(items, forKey: "items")
		}
		if orderId != nil{
			aCoder.encode(orderId, forKey: "order_id")
		}
		if orderNumber != nil{
			aCoder.encode(orderNumber, forKey: "order_number")
		}
		if orderStatus != nil{
			aCoder.encode(orderStatus, forKey: "order_status")
		}
		if paymentStatus != nil{
			aCoder.encode(paymentStatus, forKey: "payment_status")
		}
		if paymentType != nil{
			aCoder.encode(paymentType, forKey: "payment_type")
		}
		if serviceCharge != nil{
			aCoder.encode(serviceCharge, forKey: "service_charge")
		}
		if shippingAddress != nil{
			aCoder.encode(shippingAddress, forKey: "shipping_address")
		}
		if shippingCharge != nil{
			aCoder.encode(shippingCharge, forKey: "shipping_charge")
		}

	}

}
