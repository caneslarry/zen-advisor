//
//  DataModels.swift
//  cdapi
//
//  Created by Panacea-soft on 6/1/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire
final class City: NSObject , ResponseCollectionSerializable, ResponseObjectSerializable {
    

    var id: String?
    var name: String?
    var desc: String?
    var address: String?
    var lat: String?
    var lng: String?
    var adminId: String?
    var isApproved: String?
    var paypalTransId: String?
    var added: String?
    var status: String?
    var itemCount: Int?
    var categoryCount: Int?
    var subCategoryCount: Int?
    var followCount: Int?
    var coverImageFile: String?
    var coverImageWidth: String?
    var coverImageHeight: String?
    var coverImageDescription: String?
    
    var categories: [Category] = []
    
    init(cityData: NSDictionary) {
        super.init()
        self.setData(cityData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let cityData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(cityData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [City] {
        var cities = [City]()
        
        if var _ = (representation as AnyObject).value(forKeyPath: "data") as? [NSDictionary]{
            for city in (representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary] {
                cities.append(City(cityData: city))
            }
        }
        return cities
        
    }
    
    func setData(_ cityData: NSDictionary) {
        self.id = cityData["id"] as? String
        self.name = cityData["name"] as? String
        self.desc = cityData["description"] as? String
        self.address = cityData["address"] as? String
        self.lat = cityData["lat"] as? String
        self.lng = cityData["lng"] as? String
        self.adminId = cityData["admin_id"] as? String
        self.isApproved = cityData["is_approved"] as? String
        self.paypalTransId = cityData["paypal_trans_id"] as? String
        self.added = cityData["added"] as? String
        self.status = cityData["status"] as? String
        self.itemCount = cityData["item_count"] as? Int
        self.categoryCount = cityData["category_count"] as? Int
        self.subCategoryCount = cityData["sub_category_count"] as? Int
        self.followCount = cityData["follow_count"] as? Int
        self.coverImageFile = cityData["cover_image_file"] as? String
        self.coverImageWidth = cityData["cover_image_width"] as? String
        self.coverImageHeight = cityData["cover_image_height"] as? String
        self.coverImageDescription = cityData["cover_image_description"] as? String
        
        for category in cityData["categories"] as! [NSDictionary] {
            self.categories.append(Category(categoryData: category))
        }
        
    }
}
