//
//  ItemModel.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 9/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

class ItemModel {
    
    var itemId: String
    var itemCityId : String
    var itemName: String
    var itemImage: String
    var itemLikeCount: Int
    var itemReviewCount: Int
    var itemImageBlob : UIImage?
    var itemImageHeight : CGFloat
    var itemImageWidth : CGFloat
    
    init(itemId: String, itemCityId: String,itemName: String,itemImage: String, itemLikeCount: Int, itemReviewCount: Int, itemImageHeight : CGFloat, itemImageWidth : CGFloat) {
        self.itemId = itemId
        self.itemCityId = itemCityId
        self.itemName = itemName
        self.itemImage = itemImage
        self.itemLikeCount = itemLikeCount
        self.itemReviewCount = itemReviewCount
        self.itemImageHeight = itemImageHeight
        self.itemImageWidth = itemImageWidth
    }
    
    convenience init(item: Item) {
        let id = item.id
        let name = item.name
        let cityId = item.cityId
        var imageName : String = ""
        var imageHeight : CGFloat = 0
        var imageWidth : CGFloat = 0
        if item.images.count > 0 {
            imageName = item.images[0].path! as String
            
            if let n = NumberFormatter().number(from: item.images[0].height!) {
                imageHeight = CGFloat(n)
            }
            
            if let n2 = NumberFormatter().number(from: item.images[0].width!) {
                imageWidth = CGFloat(n2)
            }
            
        }else{
            //TODO: Need to add default image
        }
       
        let likeCount = item.likeCount
        let reviewCount = item.reviewCount
        
        self.init(itemId:id!, itemCityId: cityId!, itemName: name!, itemImage: imageName, itemLikeCount: likeCount!, itemReviewCount: reviewCount!, itemImageHeight : imageHeight, itemImageWidth: imageWidth)
        
    }
    
}
