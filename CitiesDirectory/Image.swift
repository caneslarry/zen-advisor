//
//  Image.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 16/1/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//


class Image: NSObject {
    var id: String?
    var parentId: String?
    var cityId: String?
    var type: String?
    var path: String?
    var width: String?
    var height: String?
    var desc: String?
    
    init(imageData: NSDictionary){
        super.init()
        self.setData(imageData)
    }
    
    func setData(_ imageData: NSDictionary) {
        self.id = imageData["id"] as? String
        self.parentId = imageData["parent_id"] as? String
        self.cityId = imageData["city_id"] as? String
        self.type = imageData["type"] as? String
        self.path = imageData["path"] as? String
        self.width = imageData["width"] as? String
        self.height = imageData["height"] as? String
        self.desc = imageData["description"] as? String
    }
}
