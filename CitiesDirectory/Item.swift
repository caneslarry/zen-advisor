//
//  Item.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 16/1/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

final class Item: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var catId: String?
    var subCatId: String?
    var cityId: String?
    var name: String?
    var desc: String?
    var address: String?
    var phone: String?
    var email: String?
    var lat: String?
    var lng: String?
    var search_tag: String?
    var isPublished: String?
    var added: String?
    var updated: String?
    var likeCount: Int?
    var reviewCount: Int?
    var inquiryCount: Int?
    var touchCount: Int?
    
    var images: [Image] = []
    var reviews: [Review] = []
    
    init(itemData: NSDictionary) {
        super.init()
        self.setData(itemData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let itemData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(itemData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Item] {
        var items = [Item]()
        if var _ = (representation as AnyObject).value(forKey: "data") as? [NSDictionary]{
            
            for item in ((representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary]) {
                items.append(Item(itemData: item))
                
            }
        }
        return items
    }
    
    func setData(_ itemData: NSDictionary) {
        self.id = itemData["id"] as? String
        self.catId = itemData["cat_id"] as? String
        self.subCatId = itemData["sub_cat_id"] as? String
        self.cityId = itemData["city_id"] as? String
        self.name = itemData["name"] as? String
        self.desc = itemData["description"] as? String
        self.address = itemData["address"] as? String
        self.phone = itemData["phone"] as? String
        self.email = itemData["email"] as? String
        self.lat = itemData["lat"] as? String
        self.lng = itemData["lng"] as? String
        self.search_tag = itemData["search_tag"] as? String
        self.isPublished = itemData["is_published"] as? String
        self.added = itemData["added"] as? String
        self.updated = itemData["updated"] as? String
        self.likeCount = itemData["like_count"] as? Int
        self.reviewCount = itemData["review_count"] as? Int
        self.inquiryCount = itemData["inquiries_count"] as? Int
        self.touchCount = itemData["touches_count"] as? Int
        
        if itemData["images"] != nil {
            for image in itemData["images"] as! [NSDictionary] {
                self.images.append(Image(imageData: image))
            }
        }
        
        if itemData["reviews"] != nil {
            for review in itemData["reviews"] as! [NSDictionary] {
                self.reviews.append(Review(reviewData: review))
            }
        }
        
    }
    
    
}
