//
//  ItemMapViewController.swift
//  CitiesDirectory
//
//  Created by PPH-MacMini on 5/3/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import MapKit

class ItemMapViewController : UIViewController {
    
    var itemLat: String = ""
    var itemLng: String = ""
    var itemTitle: String = ""
    var itemAddress: String = ""
    @IBOutlet weak var MapView: MKMapView!
    var anotation : MKPointAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        openMapForPlace(itemTitle, subTitle: itemAddress, Latitude: itemLat, Longitude: itemLng)
        
        //loadMapView(itemTitle, subTitle: itemAddress, Latitude: itemLat, Longitude: itemLng)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.applyMapViewMemoryFix()
    }
    
    func loadMapView(_ title: String, subTitle: String, Latitude: String, Longitude: String) {
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(Latitude)!, longitude: Double(Longitude)!)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        MapView.setRegion(theRegion, animated: true)
        MapView.isUserInteractionEnabled = true
        
        //anotation = MKPointAnnotation()
        self.anotation.coordinate = location
        self.anotation.title = title
        self.anotation.subtitle = subTitle
        
        MapView.addAnnotation(anotation)
        
       
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.itemMapPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
    
    override func didReceiveMemoryWarning() {
        //applyMapViewMemoryFix()
    }
    
    func applyMapViewMemoryFix(){
        
        if self.MapView != nil {
            self.MapView.removeAnnotations(self.MapView.annotations)
            
            switch (self.MapView.mapType) {
            case MKMapType.hybrid:
                self.MapView.mapType = MKMapType.standard
                break;
            case MKMapType.standard:
                self.MapView.mapType = MKMapType.hybrid
                break;
            default:
                break;
            }
            
            self.MapView.showsUserLocation = false
            self.MapView.delegate = nil
            self.MapView.removeFromSuperview()
            self.MapView = nil
        }
    }
    
    
    func openMapForPlace(_ title: String, subTitle: String, Latitude: String, Longitude: String) {
        
        let latitude: CLLocationDegrees = Double(Latitude)!
        let longitude: CLLocationDegrees = Double(Longitude)!
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title + subTitle
        mapItem.openInMaps(launchOptions: options)
    }

    
}
