//
//  CityListControllerViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 11/19/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire


class CityListControllerViewController: UICollectionViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    
    var lat = Float(0)
    var long = Float(0)
    var populationPhotos = false
    var currentPage = 1
    var allCities = [CityModel]()
    let imageCache = NSCache<AnyObject, AnyObject>()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager = CLLocationManager()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.distanceFilter = 100.0;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            self.locationManager.requestLocation()
            
        }
        //lat = Float((locationManager.location?.coordinate.latitude)!)
        //let longitude = locationManager.location.coordinate.longitude
        //long = Float((locationManager.location?.coordinate.longitude)!)
                if #available(iOS 10.0, *) {
            collectionView!.isPrefetchingEnabled = false
        }
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //lat = Float((locationManager.location?.coordinate.latitude)!)
        //let longitude = locationManager.location.coordinate.longitude
        //long = Float((locationManager.location?.coordinate.longitude)!)
        loadAllCities()
        _ = Common.instance.loadBackgroundImage(view)
        
        
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView!.register(CityCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CityCell")
    
        //var locValue = locationManager.location.coordinate
        
        
        /**/

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        lat = Float((locationManager.location?.coordinate.latitude)!)
        //let longitude = locationManager.location.coordinate.longitude
        long = Float((locationManager.location?.coordinate.longitude)!)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //let userLocation:CLLocation = locations[0] as! CLLocation
        //long = userLocation.coordinate.longitude;
        // lat = userLocation.coordinate.latitude;
        //Do What ever you want with it
    }
    /**/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        /*
        var newLocation  = locations.last;
        
        var locationAge = -[newLocation.timestamp ,timeIntervalSinceNow];
        if (locationAge > 5.0) {return}
 
        */
        
        
        //var location = locations.last! as CLLocation
        //lat = Float((locationManager.location?.coordinate.latitude)!)
        //long = Float((locationManager.location?.coordinate.longitude)!)
        
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //self.map.setRegion(region, animated: true)
        /*
        weak var cityController = self.storyboard?.instantiateViewController(withIdentifier: "ViewCurrentCity") as? SelectedCityViewController
        cityController?.selectedCityId = Int(10)
        self.navigationController?.pushViewController(cityController!, animated: true)
        */
    }
    /**/
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateLabelFrame(_ text:NSString!, font:UIFont!) -> CGFloat {
        let maxSize = CGSize(width: 320, height: CGFloat(MAXFLOAT)) as CGSize
        let expectedSize = NSString(string: text!).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:  [NSFontAttributeName: font], context: nil).size as CGSize
        return expectedSize.height;
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.homePageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
    
    func showNotiIfExists(){
        let prefs = UserDefaults.standard
        
        let keyValue = prefs.string(forKey: notiKey.notiMessageKey)
        if keyValue != nil {
            
            let alert = UIAlertController(title: "", message:keyValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
            self.present(alert, animated: true){}
            
            prefs.removeObject(forKey: notiKey.notiMessageKey)
        }
    }
    
    func loadAllCities() {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        //self.lat,self.long  --- GetCitiesByGeo(26.9342,80.0942)
        Alamofire.request(APIRouters.GetCitiesByGeo(self.lat,self.long)).responseCollection { (response: DataResponse<[City]>) in
            
            if response.result.isSuccess {
                if let cities: [City] = response.result.value {
                    
                    if cities.count > 0 {
                        
                        for city in cities {
                            if(city.name==""){
                            }else{
                                
                                let oneCity = CityModel(city: city)
                                self.allCities.append(oneCity)

                            }
                            
                        }
                        
                        self.collectionView?.reloadData()
                        _ = EZLoadingActivity.hide()
                        CitiesListModel.sharedManager.cities = self.allCities
                        
                    } else {
                        self.menuButton.isEnabled = false
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.noCities, style: AlertStyle.warning)
                    }
                    
                }
                
                //Show noti message, if there is new noti message
                self.showNotiIfExists();
                
                
                
            } else {
                print("Response is fail.")
                _ = EZLoadingActivity.hide()
                _ = SweetAlert().showAlert(language.homePageTitle, subTitle: language.tryAgainToConnect, style: AlertStyle.warning)
            }
        }
        
    }
    
}

extension CityListControllerViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedCity" {
            weak var cityCell = sender as? CityCell
            weak var selectedCityController = segue.destination as? SelectedCityViewController
            weak var cityModel = cityCell!.citymodel
            selectedCityController!.cityModel = cityModel
            updateBackButton()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allCities.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCell", for: indexPath) as! CityCell
        cell.citymodel = self.allCities[(indexPath as NSIndexPath).item]
        cell.layer.shouldRasterize = true;
        
        let imageURL = configs.imageUrl + allCities[(indexPath as NSIndexPath).item].backgroundImage
        
        cell.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }
        
       
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = collectionViewLayout as! PallaxLayout
        let offset = layout.dragOffset * CGFloat((indexPath as NSIndexPath).item)
        
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CityCell
        performSegue(withIdentifier: "selectedCity", sender: cell)
        
    }
    
    
}







