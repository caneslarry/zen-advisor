//
//  CategoryModel.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 5/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

struct CategoryModel {
    static let sharedInstance = CategoryModel()
    var categories: [Categories]? = nil
}

struct SubCategories {
    let id: String
    let name: String
    let imageURL: String
}

struct Categories {
    let id: String
    let name: String
    let subCategory: [SubCategories]
}
