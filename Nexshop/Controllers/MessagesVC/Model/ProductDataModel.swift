//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ProductDataModel : Mappable{
    
    var addedBy : String?
    var brandId : String?
    var breadth : AnyObject?
    var categoryId : String?
    var choiceOptions : String?
    var colors : String?
    var createdAt : String?
    var currentStock : String?
    var deletedAt : AnyObject?
    var descriptionField : String?
    var discount : String?
    var discountType : String?
    var featured : String?
    var featuredImg : String?
    var featuresDetails : String?
    var flashDealImg : String?
    var height : AnyObject?
    var id : Int?
    var isSponsored : String?
    var isVerifiedByCellula : String?
    var length : AnyObject?
    var metaDescription : String?
    var metaImg : String?
    var metaTitle : AnyObject?
    var name : String?
    var numOfSale : String?
    var origin : String?
    var pdf : AnyObject?
    var photos : String?
    var published : String?
    var purchasePrice : String?
    var qty : AnyObject?
    var rating : String?
    var shippingCost : String?
    var shippingType : String?
    var sku : AnyObject?
    var slug : String?
    var sponsoredExpiry : AnyObject?
    var subOfSubCategory : AnyObject?
    var subcategoryId : String?
    var subsubcategoryId : String?
    var tags : String?
    var tax : String?
    var taxType : String?
    var thumbnailImg : String?
    var todaysDeal : String?
    var unit : String?
    var unitPrice : String?
    var updatedAt : String?
    var userId : String?
    var variations : String?
    var videoLink : AnyObject?
    var videoProvider : String?
    var weight : AnyObject?
    
    required init?(map: Map) {
        
    }
    
    
    
    func mapping(map: Map)
    {
        addedBy <- map["added_by"]
        brandId <- map["brand_id"]
        breadth <- map["breadth"]
        categoryId <- map["category_id"]
        choiceOptions <- map["choice_options"]
        colors <- map["colors"]
        createdAt <- map["created_at"]
        currentStock <- map["current_stock"]
        deletedAt <- map["deleted_at"]
        descriptionField <- map["description"]
        discount <- map["discount"]
        discountType <- map["discount_type"]
        featured <- map["featured"]
        featuredImg <- map["featured_img"]
        featuresDetails <- map["features_details"]
        flashDealImg <- map["flash_deal_img"]
        height <- map["height"]
        id <- map["id"]
        isSponsored <- map["is_sponsored"]
        isVerifiedByCellula <- map["is_verified_by_cellula"]
        length <- map["length"]
        metaDescription <- map["meta_description"]
        metaImg <- map["meta_img"]
        metaTitle <- map["meta_title"]
        name <- map["name"]
        numOfSale <- map["num_of_sale"]
        origin <- map["origin"]
        pdf <- map["pdf"]
        photos <- map["photos"]
        published <- map["published"]
        purchasePrice <- map["purchase_price"]
        qty <- map["qty"]
        rating <- map["rating"]
        shippingCost <- map["shipping_cost"]
        shippingType <- map["shipping_type"]
        sku <- map["sku"]
        slug <- map["slug"]
        sponsoredExpiry <- map["sponsored_expiry"]
        subOfSubCategory <- map["sub_of_sub_category"]
        subcategoryId <- map["subcategory_id"]
        subsubcategoryId <- map["subsubcategory_id"]
        tags <- map["tags"]
        tax <- map["tax"]
        taxType <- map["tax_type"]
        thumbnailImg <- map["thumbnail_img"]
        todaysDeal <- map["todays_deal"]
        unit <- map["unit"]
        unitPrice <- map["unit_price"]
        updatedAt <- map["updated_at"]
        userId <- map["user_id"]
        variations <- map["variations"]
        videoLink <- map["video_link"]
        videoProvider <- map["video_provider"]
        weight <- map["weight"]
        
    }
    
    
    
}
