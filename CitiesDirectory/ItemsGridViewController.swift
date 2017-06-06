//
//  CategoriesViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

@objc protocol RefreshLikeCountsDelegate: class {
    func updateLikeCounts(_ likeCount: Int)
}

@objc protocol RefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviewCount: Int)
}

class ItemsGridViewController: UICollectionViewController {
    
    var populationItems = false
    var selectedSubCategoryId:Int = 0
    var selectedCityId:Int = 0
    var selectedCityLat: String!
    var selectedCityLng: String!
    var items = [ItemModel]()
    var currentPage = 0
    let imageCache = NSCache<AnyObject, AnyObject>()
    fileprivate weak var selectedCell : AnnotatedPhotoCell!
    
    @IBOutlet weak var cellBackgroundView: RoundedCornersView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(AnnotatedPhotoCell.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "AnnotatedPhotoCell")
        
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        loadItemsBySubCategory()
        addNavigationMenuItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("View Disappear")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell : AnnotatedPhotoCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedPhotoCell", for: indexPath) as! AnnotatedPhotoCell
        cell.item = items[(indexPath as NSIndexPath).item]
        
        let imageURL = configs.imageUrl + items[(indexPath as NSIndexPath).item].itemImage
        
        cell.imageView.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }
                
        return cell
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        loadItemsBySubCategory()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        weak var itemCell = sender as? AnnotatedPhotoCell
        weak var itemDetailPage = segue.destination as? ItemDetailViewController
        itemDetailPage!.selectedItemId = Int((itemCell!.item?.itemId)!)!
        itemDetailPage!.selectedCityId = selectedCityId
        itemDetailPage!.refreshLikeCountsDelegate = self
        itemDetailPage!.refreshReviewCountsDelegate = self
        selectedCell = itemCell
        updateBackButton()
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func addNavigationMenuItem() {
        let btnNavi = UIButton()
        btnNavi.setImage(UIImage(named: "Map-Lite-White"), for: UIControlState())
        btnNavi.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnNavi.addTarget(self, action: #selector(ItemsGridViewController.loadMapViewController(_:)), for: .touchUpInside)
        let itemNavi = UIBarButtonItem()
        itemNavi.customView = btnNavi
        
        self.navigationItem.rightBarButtonItems = [itemNavi]
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.itemsPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    func loadMapViewController(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
        weak var mapViewController = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? ItemsMapViewController
        self.navigationController?.pushViewController(mapViewController!, animated: true)
        mapViewController?.selectedCityLat = selectedCityLat
        mapViewController?.selectedCityLng = selectedCityLng
        mapViewController?.selectedCityId = selectedCityId
        mapViewController?.selectedSubCategoryId = selectedSubCategoryId
        updateBackButton()
        
    }
    
    func loadItemsBySubCategory() {
        
       
        _ = Alamofire.request(APIRouters.ItemsBySubCategory(selectedCityId, selectedSubCategoryId, configs.pageSize, self.currentPage)).responseCollection {
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

extension ItemsGridViewController : PinterestLayoutDelegate {
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



extension ItemsGridViewController : RefreshLikeCountsDelegate, RefreshReviewCountsDelegate {
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




