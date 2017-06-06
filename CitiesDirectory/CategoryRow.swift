//
//  CategoryRow.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit
//import Alamofire

class CategoryRow : UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    //let imageCache = NSCache<AnyObject, AnyObject>()
    var selecedCategory:Categories? = nil {
        didSet {
            self.collectionView.reloadData()
        }
    }
}
    
extension CategoryRow : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selecedCategory!.subCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        cell.subCatName.text = selecedCategory!.subCategory[(indexPath as NSIndexPath).item].name
        
        let backgroundName =  selecedCategory!.subCategory[(indexPath as NSIndexPath).item].imageURL as String
        let imageURL = configs.imageUrl + backgroundName
        
        cell.imageView.loadImage(urlString: imageURL) { (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }
    
        //cell.request?.cancel()
        
        /* TOFIX 
        if let image = self.imageCache.object(forKey: imageURL) as? UIImage {
            cell.imageView.image = image
        } else {
            cell.imageView.image = nil
            
            cell.request = Alamofire.request(.GET, imageURL).validate(contentType: ["image/\*"]).responseImage() {
                response in
                
                if response.result.isSuccess {
                    self.imageCache.setObject(response.result.value!, forKey: (response.request?.URLString)!)
                    
                    cell.imageView.image = response.result.value
                } else {
                    
                }
            }
        }*/
        
        cell.subCategoryId = selecedCategory!.subCategory[(indexPath as NSIndexPath).item].id
        
        return cell

        
    }
}


