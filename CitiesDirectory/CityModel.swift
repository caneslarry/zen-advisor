//
//  Inspiration.swift
//  RWDevCon
//
//  Created by Mic Pringle on 02/03/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

class CityModel {

    var id: String
    var name: String
    var categoryCount: Int
    var subCategoryCount: Int
    var description: String
    var backgroundImage: String
    var lat: String
    var lng: String
    
    var catAndSubCat: String {
        get {
            return String(categoryCount) + " ZenSpots" //language.categories + String(categoryCount) + language.subCategories + String(subCategoryCount)
        }
    }
    
    init(id: String, name: String, categoryCount: Int, subCategoryCount: Int, description: String, backgroundImage: String, lat: String, lng: String) {
        self.id = id
        self.name = name
        self.categoryCount = categoryCount
        self.subCategoryCount = subCategoryCount
        self.description = description
        self.backgroundImage = backgroundImage
        self.lat = lat
        self.lng = lng
        
    }
    
    convenience init(city: City) {
        let id = city.id!
        let name = city.name! as String
        
        let backgroundName = city.coverImageFile! as String
        let backgroundImage = backgroundName 
        
        let categoryCount = city.categoryCount!
        let subCategoryCount = city.subCategoryCount!
        let description = city.address! as String
        
        let lat = city.lat! as String
        let lng = city.lng! as String
        
        self.init(id: id, name: name,categoryCount : categoryCount,subCategoryCount: subCategoryCount, description: description,backgroundImage: backgroundImage, lat: lat, lng: lng)
    }

}
