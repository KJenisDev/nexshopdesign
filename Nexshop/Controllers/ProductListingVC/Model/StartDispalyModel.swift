//
//    Todaysdeal.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class StartDispalyModel : NSObject, NSCoding{

    var name : String!
    var isselected : Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        name = dictionary["name"] as? String
        isselected = dictionary["isselected"] as? Bool
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name
        }
        if isselected != nil{
            dictionary["isselected"] = isselected
        }
       
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         name = aDecoder.decodeObject(forKey: "name") as? String
         isselected = aDecoder.decodeObject(forKey: "isselected") as? Bool
         

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if isselected != nil{
            aCoder.encode(isselected, forKey: "isselected")
        }
        

    }

}

