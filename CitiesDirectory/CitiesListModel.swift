//
//  CitiesListModel.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 25/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

class CitiesListModel {
    internal var cities  = [CityModel]()
    class var sharedManager: CitiesListModel {
        struct Static {
            static let instance = CitiesListModel()
        }
        return Static.instance
    }
}
