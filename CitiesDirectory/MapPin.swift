//
//  MapPin.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 20/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import MapKit

class MapPin: NSObject, MKAnnotation {
    let id: String?
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(id: String, title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    convenience init(item: Item) {
        let id = item.id
        let name = item.name
        let address = item.address
        let lat = item.lat
        let lng = item.lng
        let coordinate = CLLocationCoordinate2D(latitude: Double(lat!)!, longitude: Double(lng!)!)
        self.init(id: id!, title: name!, locationName: address!, coordinate: coordinate)
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func pinColor() -> UIColor  {
        return .red
    }
}

