//
//  AnnotatedPhotoCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
//import Alamofire

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    
    var itemImage : String = ""
    //var request: Alamofire.Request?
    var item: ItemModel? {
        didSet {
            if let item = item {
                itemImage = item.itemImage
                captionLabel.text = item.itemName
                lblLikeCount.text = String(item.itemLikeCount)
                lblReviewCount.text = String(item.itemReviewCount)
            }
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        DispatchQueue.main.async {

        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            self.imageViewHeightLayoutConstraint.constant = attributes.photoHeight

        }
        }
    }
}
