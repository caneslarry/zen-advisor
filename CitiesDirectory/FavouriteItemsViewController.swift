//
//  FavouriteItemsViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 24/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import UIKit
import AVFoundation
import Alamofire


@objc protocol FavRefreshLikeCountsDelegate: class {
    func updateLikeCounts(_ likeCount: Int)
}

@objc protocol FavRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

class FavouriteItemsViewController: UICollectionViewController {
    
    var populationItems = false
    var selectedSubCategoryId:Int = 0
    var selectedCityId:Int = 1
    var selectedCityLat: String!
    var selectedCityLng: String!
    var items = [ItemModel]()
    var currentPage = 0
    let imageCache = NSCache<AnyObject, AnyObject>()
    var loginUserId:Int = 0
    weak var selectedCell : AnnotatedPhotoCell!
 
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        
        collectionView!.register(AnnotatedPhotoCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "AnnotatedPhotoCell")
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        loadLoginUserId()
        loadFavouriteItems()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        loadFavouriteItems()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        weak var itemCell = sender as? AnnotatedPhotoCell
        weak var itemDetailPage = segue.destination as? ItemDetailViewController
        itemDetailPage!.selectedItemId = Int((itemCell!.item?.itemId)!)!
        itemDetailPage!.selectedCityId = Int((itemCell!.item?.itemCityId)!)!
        itemDetailPage!.favRefreshLikeCountsDelegate = self
        itemDetailPage!.favRefreshReviewCountsDelegate = self
        selectedCell = itemCell
        updateBackButton()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : AnnotatedPhotoCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        cell.item = items[(indexPath as NSIndexPath).item]
        
        let imageURL = configs.imageUrl + items[(indexPath as NSIndexPath).item].itemImage
        
        cell.imageView.loadImage(urlString: imageURL) { (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }       
        
        return cell
    }
    
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.favouritePageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
            loginUserId           = Int(dict.object(forKey: "_login_user_id") as! String)!
            
            print("Login User Id : " + String(loginUserId))
        } else {
            print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func loadFavouriteItems() {
        
        /*PSApiHelper(request: APIRouters.GetFavouriteItems( loginUserId, configs.pageSize, self.currentPage).Request, completionHandler: { (status, data, msg) -> (Void) in
            if status == STATUS.success {
                
                for  d in data {
                    
                    let item: Item = Item(itemData: d as NSDictionary)
                    
                    let oneItem = ItemModel(item: item)
                    self.items.append(oneItem)
                    self.currentPage+=1
                    
                    
                }
                
                 self.collectionView!.reloadData()
                
            } else {
                
                print("error : " + msg)
            }
        })
        */
        
       /*TOFIX */
        _ = Alamofire.request(APIRouters.GetFavouriteItems( loginUserId, configs.pageSize, self.currentPage)).responseCollection {
            (response: DataResponse<[Item]>) in
            if response.result.isSuccess {
                if let items: [Item] = response.result.value {
                    if(items.count > 0) {
                        for item in items {
                            let oneItem = ItemModel(item: item)
                            self.items.append(oneItem)
                            self.currentPage+=1
                            
                        }
                    }
                }
                
                self.collectionView!.reloadData()
                
            } else {
                print(response)
            }
        }
        
    }
    
    
}


extension FavouriteItemsViewController : PinterestLayoutDelegate {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        
        let item = items[(indexPath as NSIndexPath).item]
        
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        
        let size = CGSize(width: item.itemImageWidth, height: item.itemImageHeight)
        var rect : CGRect
        if item.itemImageBlob != nil {
            rect  = AVMakeRect(aspectRatio: item.itemImageBlob!.size, insideRect: boundingRect)
        }else{
            rect  = AVMakeRect(aspectRatio: size, insideRect: boundingRect)
            
        }
        
        return rect.size.height
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(17)
        let height = annotationPadding + annotationHeaderHeight + annotationPadding + 30
        return height
    }
}

extension FavouriteItemsViewController : FavRefreshLikeCountsDelegate, FavRefreshReviewCountsDelegate {
    func updateLikeCounts(_ likeCount: Int) {
        if selectedCell != nil {
            selectedCell.lblLikeCount.text = "\(likeCount)"
        }
    }
    
    func updateReviewCounts(_ reviewCount: Int) {
        if selectedCell != nil {
            selectedCell.lblReviewCount.text = "\(reviewCount)"
        }
    }
}

