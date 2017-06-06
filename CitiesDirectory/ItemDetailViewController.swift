//
//  ItemDetailViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 11/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire
import Social
import MapKit

@objc protocol ItemDetailRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int, reviews: [AnyObject])
}

@objc protocol ItemDetailLoginUserIdDelegate: class {
    func updateLoginUserId(_ UserId: Int)
}

class ItemDetailViewController: UIViewController {
    
    var selectedItemId:Int = 0
    var selectedCityId:Int = 0
    var loginUserId:Int = 0
    weak var refreshLikeCountsDelegate : RefreshLikeCountsDelegate!
    weak var refreshReviewCountsDelegate : RefreshReviewCountsDelegate!
    var reviews = [ReviewModel]()
    var itemImages = [ImageModel]()
    weak var favRefreshLikeCountsDelegate : FavRefreshLikeCountsDelegate!
    weak var favRefreshReviewCountsDelegate : FavRefreshReviewCountsDelegate!
    weak var searchRefreshLikeCountsDelegate : SearchRefreshLikeCountsDelegate!
    weak var searchRefreshReviewCountsDelegate : SearchRefreshReviewCountsDelegate!
    var itemTitle: String = ""
    var itemSubTitle: String = ""
    var itemLat: String = ""
    var itemLng: String = ""
    
    @IBOutlet weak var likeCountImage: UIImageView!
    @IBOutlet weak var reviewCountImage: UIImageView!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemLikeCount: UILabel!
    @IBOutlet weak var itemReviewCount: UILabel!
    @IBOutlet weak var itemAddress: UILabel!
    @IBOutlet weak var itemPhone: UILabel!
    @IBOutlet weak var itemEmail: UILabel!
    @IBOutlet weak var viewOnMap: UIButton!
    @IBOutlet weak var shareOnFB: UIButton!
    @IBOutlet weak var tweetOnTW: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBAction func SubmitInquiry(_ sender: AnyObject) {
        let inquiryFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "InquiryViewController") as? InquiryEntryViewController
        inquiryFormViewController?.selectedItemId = selectedItemId
        inquiryFormViewController?.cityId = selectedCityId
        self.navigationController?.pushViewController(inquiryFormViewController!, animated: true)
        updateBackButton()
    }
    
    
    @IBAction func LoadMapView(_ sender: AnyObject) {
        if(itemLat != "" && itemLng != "") {
            /*
            weak var itemMapViewController = self.storyboard?.instantiateViewController(withIdentifier: "ItemMap") as? ItemMapViewController
            self.navigationController?.pushViewController(itemMapViewController!, animated: true)
            itemMapViewController?.itemTitle = itemTitle
            itemMapViewController?.itemAddress = itemSubTitle
            itemMapViewController?.itemLat = itemLat
            itemMapViewController?.itemLng = itemLng
 */
            openMapForPlace(itemTitle, subTitle: itemSubTitle, Latitude: itemLat, Longitude: itemLng)
            updateBackButton()
        } else {
            _ = SweetAlert().showAlert(language.itemMapTitle, subTitle: language.noLatLng, style: AlertStyle.warning)
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
    
    @IBAction func FacebookShare(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
           
            let itemURL : String = itemName.text!
            var itemURLCleaned = itemURL
            itemURLCleaned = String(itemURLCleaned.replacingOccurrences(of: " ", with: "-"))
            itemURLCleaned = String(itemURLCleaned.replacingOccurrences(of: "&", with: ""))
            
            
            
            //let fullShareUrl : String =
            let fullShareUrlCleaned = String(language.shareURL + itemURLCleaned)
            
            facebookSheet.setInitialText("Hello"+language.shareMessage)
            facebookSheet.add(URL(string: fullShareUrlCleaned!))
          
            self.present(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: language.accountLogin, message: language.fbLogin, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func TwitterShare(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(language.shareMessage)
            twitterSheet.add(URL(string: language.shareURL))
            self.present(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: language.accountLogin, message: language.twLogin, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: language.btnOK, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        loadItemData(selectedItemId,CityId:selectedCityId)
        ImageViewTapRegister()
        loadLoginUserId()
        isLikedChecking()
        isFavouritedChecking()
        addItemTouchCount()
        
        viewOnMap.setTitle(language.viewOnMap, for: UIControlState())
        viewOnMap.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
        
        shareOnFB.setTitle(language.shareOn, for: UIControlState())
        shareOnFB.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
        
        tweetOnTW.setTitle(language.tweetOn, for: UIControlState())
        tweetOnTW.backgroundColor = Common.instance.colorWithHexString(configs.barColorCode)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            var imageFrame = itemImage.frame
            imageFrame.size.height = 300
            itemImage.frame = imageFrame
            
            
            let aspectRatioTextViewConstraint = NSLayoutConstraint(
                item: self.itemImage,
                attribute: .height,
                relatedBy: .equal,
                toItem: self.itemImage,
                attribute: .width,
                multiplier: itemImage.bounds.height/itemImage.bounds.width, constant: 1)
            self.itemImage.addConstraint(aspectRatioTextViewConstraint)
            
        }
        
    }
    
    func PhoneNoTapped(_ sender:UITapGestureRecognizer) {
        print ("tap \(itemPhone.text)")
        let phoneNo : String = itemPhone.text!
        let phoneNoCleaned = String(phoneNo.characters.filter { "01234567890.".characters.contains($0) })
        


        if let url = URL(string: "tel://\(phoneNoCleaned)") {
            print(url)
            UIApplication.shared.openURL(url)
            //UIApplication.sharedApplication.openURL(url)
        }
    }
    
    func loadItemData(_ ItemId:Int, CityId:Int) {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
       /* PSApiHelper(request: APIRouters.ItemById(ItemId, CityId).Request, completionHandler: { (status, data, msg) -> (Void) in
            if status == STATUS.success {
                
                let item: Item = Item(itemData: data[0] as NSDictionary)
                    self.bindItemData(item)
                    
                    if(item.reviews.count > 0){
                        for review in item.reviews {
                            let oneReview = ReviewModel(review: review)
                            self.reviews.append(oneReview)
                        }
                    }
                    
                    if(item.images.count > 0) {
                        for image in item.images {
                            let oneImage = ImageModel(image: image)
                            self.itemImages.append(oneImage)
                            
                        }
                    }
                
                _ = EZLoadingActivity.hide()
                    
                
            }
        })*/
      /*TOFIX*/
        _ = Alamofire.request(APIRouters.ItemById(ItemId, CityId)).responseObject {
            (response: DataResponse<Item>) in
            _ = EZLoadingActivity.hide()
            if response.result.isSuccess {

                if let item: Item = response.result.value {
                    self.bindItemData(item)
                    
                    if(item.reviews.count > 0){
                        for review in item.reviews {
                            let oneReview = ReviewModel(review: review)
                            self.reviews.append(oneReview)
                        }
                    }
                    
                    if(item.images.count > 0) {
                        for image in item.images {
                            let oneImage = ImageModel(image: image)
                            self.itemImages.append(oneImage)
                            
                        }
                    }
                    
                }
                
            }
            
        }

    }
    
    func ImageViewTapRegister() {
        
        let reviewTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.ReviewCountImageTapped(_:)))
        reviewTap.numberOfTapsRequired = 1
        reviewTap.numberOfTouchesRequired = 1
        self.reviewCountImage.addGestureRecognizer(reviewTap)
        self.reviewCountImage.isUserInteractionEnabled = true
        
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.LikeCountImageTapped(_:)))
        likeTap.numberOfTapsRequired = 1
        likeTap.numberOfTouchesRequired = 1
        self.likeCountImage.addGestureRecognizer(likeTap)
        self.likeCountImage.isUserInteractionEnabled = true
        
        let favouriteTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.FavouriteImageTapped(_:)))
        favouriteTap.numberOfTapsRequired = 1
        favouriteTap.numberOfTouchesRequired = 1
        self.favouriteImage.addGestureRecognizer(favouriteTap)
        self.favouriteImage.isUserInteractionEnabled = true
        
        
     
        let itemImageTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.ItemImageTapped(_:)))
        itemImageTap.numberOfTapsRequired = 1
        itemImageTap.numberOfTouchesRequired = 1
        self.itemImage.addGestureRecognizer(itemImageTap)
        self.itemImage.isUserInteractionEnabled = true
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(ItemDetailViewController.PhoneNoTapped(_:)))
        phoneTap.numberOfTapsRequired = 1
        phoneTap.numberOfTouchesRequired = 1
        self.itemPhone.addGestureRecognizer(phoneTap)
        self.itemPhone.isUserInteractionEnabled = true
        
    }
    
    
    func ItemImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.ended){
            let imgSliderViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSlider") as? ImageSliderViewController
            self.navigationController?.pushViewController(imgSliderViewController!, animated: true)
            imgSliderViewController?.itemImages = self.itemImages
            updateBackButton()
        }
    }

    
    func ReviewCountImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.ended){
            let reviewsListViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewsListTableViewController") as? ReviewsListTableViewController
            self.navigationController?.pushViewController(reviewsListViewController!, animated: true)
            reviewsListViewController?.reviews = self.reviews
            reviewsListViewController?.selectedItemId = selectedItemId
            reviewsListViewController?.selectedCityId = selectedCityId
            reviewsListViewController?.itemDetailRefreshReviewCountsDelegate = self
            reviewsListViewController?.itemDetailLoginUserIdDelegate = self
            updateBackButton()
        }
    }
    
    func LikeCountImageTapped(_ recognizer: UITapGestureRecognizer) {
        
        if(loginUserId != 0) {
            if(recognizer.state == UIGestureRecognizerState.ended){
                
                _ = EZLoadingActivity.show("Loading...", disableUI: true)
                
                let params: [String: AnyObject] = [
                    "appuser_id": loginUserId as AnyObject,
                    "city_id"   : selectedCityId as AnyObject,
                    "platformName": "ios" as AnyObject
                ]
                
               _ = Alamofire.request(APIRouters.AddItemLike(selectedItemId, params)).responseObject{
                    (response: DataResponse<StdResponse>) in
                    
                        _ = EZLoadingActivity.hide()
                    
                        if response.result.isSuccess {
                            if let res = response.result.value {
                                
                                if(res.status == "like_success") {
                                    self.itemLikeCount.text = String(res.intData!)
                                    self.likeCountImage.image = UIImage(named: "Like-Lite-Red")
                                } else {
                                    self.itemLikeCount.text = String(res.intData!)
                                    self.likeCountImage.image = UIImage(named: "Like-Lite-Black")
                                }
                                
                                self.refreshLikeCountsDelegate?.updateLikeCounts(res.intData!)
                                
                                self.favRefreshLikeCountsDelegate?.updateLikeCounts(res.intData)
                                self.searchRefreshLikeCountsDelegate?.updateLikeCounts(res.intData)
                                
                            }
                        } else {
                            print(response)
                        }
                }
            }
        } else {
            _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.warning)
            weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
            UserLoginViewController?.title = "Login"
            UserLoginViewController?.itemDetailLoginUserIdDelegate = self
            UserLoginViewController?.fromWhere = "like"
            self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
            
            updateBackButton()
        }
        
    }
    
    func FavouriteImageTapped(_ recognizer: UITapGestureRecognizer) {
        
        if(loginUserId != 0) {
        
            if(recognizer.state == UIGestureRecognizerState.ended){
                
                _ = EZLoadingActivity.show("Loading...", disableUI: true)
                
                let params: [String: AnyObject] = [
                    "appuser_id": loginUserId as AnyObject,
                    "city_id"   : selectedCityId as AnyObject,
                    "platformName": "ios" as AnyObject
                ]
                
              
               _ = Alamofire.request(APIRouters.AddItemFavourite(selectedItemId, params)).responseObject{
                    (response: DataResponse<StdResponse>) in
                    
                    _ = EZLoadingActivity.hide()
                    
                    if response.result.isSuccess {
                        if let res = response.result.value {
                            if(res.status! == "favourite_success") {
                                
                                self.favouriteImage.image = UIImage(named: "Favourite-Lite-Red")
                            } else {
                              
                                self.favouriteImage.image = UIImage(named: "Favourite-Lite")
                            }
                            
                            
                        }
                    } else {
                        print(response)
                    }
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.loginRequireTitle, subTitle: language.loginRequireMesssage, style: AlertStyle.warning)
            weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
            UserLoginViewController?.title = "Login"
            UserLoginViewController?.itemDetailLoginUserIdDelegate = self
            UserLoginViewController?.fromWhere = "favourite"
            self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
            updateBackButton()
           
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.itemDetailPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    func bindItemData(_ itemData:Item) {
        itemName.text = itemData.name
        lblDescription.text = itemData.desc
        itemLikeCount.text = String(itemData.likeCount!)
        itemReviewCount.text = String(itemData.reviewCount!)
        
        //var wantedString = itemData.address?.replacingOccurrences(of: ",", with: "\n")
        let stringArray = itemData.address?.components(separatedBy: ",")
        
        var formattedAddress = (stringArray?[0])! 
        formattedAddress += "\n" + (stringArray?[1])!
        formattedAddress += ", " + (stringArray?[2])!
        
        itemAddress.text = formattedAddress
        itemPhone.text = itemData.phone
       // itemEmail.text = itemData.email

        itemTitle = itemData.name!
        itemSubTitle = itemData.address!
        itemLat = itemData.lat!
        itemLng = itemData.lng!
        
        
        
        if itemData.images[0].path != nil {
            let coverImageName =  itemData.images[0].path! as String
            let imageURL = configs.imageUrl + coverImageName
            itemImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
                if(status == STATUS.success) {
                    print(url + " is loaded successfully.")
                    
                }else {
                    print("Error in loading image" + msg)
                }
            }
            
            
        }
        
    }
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
            
            if(dict.object(forKey: "_login_user_id") as! String == "") {
                loginUserId = 0
            } else {
                loginUserId = Int(dict.object(forKey: "_login_user_id") as! String)!
            }
            
            
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func isLikedChecking() {
        let params: [String: AnyObject] = [
            "appuser_id": String(loginUserId) as AnyObject,
            "city_id"   : String(selectedCityId) as AnyObject,
            "platformName": "ios" as AnyObject
        ]
        
        _ = Alamofire.request(APIRouters.IsLikedItem(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in
            
            if response.result.isSuccess {
                if let res = response.result.value {
                 
                    if(res.data == "yes") {
                        self.likeCountImage.image = UIImage(named: "Like-Lite-Red")
                    } else {
                        self.likeCountImage.image = UIImage(named: "Like-Lite-Black")
                    }
                    
                }
            } else {
                //print(response)
            }
        }
    }
    
    func isFavouritedChecking() {
        let params: [String: AnyObject] = [
            "appuser_id": loginUserId as AnyObject,
            "city_id"   : selectedCityId as AnyObject
        ]
        
        
        _ = Alamofire.request(APIRouters.IsFavouritedItem(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in
            
            if response.result.isSuccess {
                if let res = response.result.value {
                    
                    if(res.data == "yes") {
                        self.favouriteImage.image = UIImage(named: "Favourite-Lite-Red")
                    } else {
                        self.favouriteImage.image = UIImage(named: "Favourite-Lite")
                    }
                    
                }
            } else {
                print(response)
            }
        }
    }
   
    func addItemTouchCount() {
        let params: [String: AnyObject] = [
            "appuser_id": loginUserId as AnyObject,
            "city_id"   : selectedCityId as AnyObject
        ]
        
        _ = Alamofire.request(APIRouters.AddItemTouch(selectedItemId, params)).responseObject{
            (response: DataResponse<StdResponse>) in
            
            if response.result.isSuccess {
                if let res = response.result.value {
                    
                    if(res.status == "success") {
                        //print("Successfully insert for touch count")
                    } else {
                        //print("Touch count insert got problem")
                    }
                    
                }
            } else {
                print(response)
            }
        }
    }

}

extension ItemDetailViewController : ItemDetailRefreshReviewCountsDelegate {
    func updateReviewCounts(_ reviewCount: Int, reviews: [AnyObject]){
        self.itemReviewCount.text = "\(reviewCount)"
        self.reviews = reviews as! [ReviewModel]
        refreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
        favRefreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
        searchRefreshReviewCountsDelegate?.updateReviewCounts(reviewCount)
    }
}

extension ItemDetailViewController: ItemDetailLoginUserIdDelegate {
    func updateLoginUserId(_ UserId: Int) {
        loginUserId = UserId
    }
}



