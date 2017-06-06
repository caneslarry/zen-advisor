//
//  ReviewCell.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 13/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import UIKit
//import Alamofire

class ReviewCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var reviewMessage: UILabel!
    @IBOutlet var userImage: UIImageView!
    //var request : Alamofire.Request?
    
    func configure(_ userNameText: String, reviewMessageText: String, reviewAdded: String, reviewUserImageURL: String, textColor: UIColor = UIColor.black) {
        
        userName.textColor = textColor
        reviewMessage.textColor = textColor
        userName.text = "- \(userNameText)" + "(" + reviewAdded + ")"
        userName.accessibilityLabel = userNameText
        
        reviewMessage.text = reviewMessageText
        reviewMessage.accessibilityLabel = reviewMessageText
        
        DispatchQueue.main.async {
        _ = Common.instance.circleImageView(self.userImage)
        }
        
//        let imageURL = configs.imageUrl +  reviewUserImageURL
//        print("User Image URL : " + imageURL)
//        userImage.loadImage(urlString: imageURL) {  (status, url, image, msg) in
//            if(status == STATUS.success) {
//                print(url + " is loaded successfully.")
//                
//            }else {
//                print("Error in loading image" + msg)
//            }
//        }
        
    }
    
    
}

