//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SubcategoryMainModel : NSObject, NSCoding{

	var icon : String!
	var id : Int!
	var name : String!
	var subcategories : [Subcategory]!
    var isSelected : Bool
    

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		icon = dictionary["icon"] as? String
		id = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		subcategories = [Subcategory]()
		if let subcategoriesArray = dictionary["subcategories"] as? [[String:Any]]{
			for dic in subcategoriesArray{
				let value = Subcategory(fromDictionary: dic)
				subcategories.append(value)
			}
		}
        isSelected = false
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if icon != nil{
			dictionary["icon"] = icon
		}
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if subcategories != nil{
			var dictionaryElements = [[String:Any]]()
			for subcategoriesElement in subcategories {
				dictionaryElements.append(subcategoriesElement.toDictionary())
			}
			dictionary["subcategories"] = dictionaryElements
		}
        isSelected = false
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         icon = aDecoder.decodeObject(forKey: "icon") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         subcategories = aDecoder.decodeObject(forKey :"subcategories") as? [Subcategory]
        isSelected = false

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if icon != nil{
			aCoder.encode(icon, forKey: "icon")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if subcategories != nil{
			aCoder.encode(subcategories, forKey: "subcategories")
		}
        isSelected = false

	}

}
