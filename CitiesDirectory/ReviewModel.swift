//
//  ReviewModel.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 14/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

class ReviewModel {
    
    var reviewUserName: String
    var reviewMessage: String
    var reviewAdded:String
    var reviewUserImageURL: String
    
    
    init(reviewUserName: String, reviewMessage: String,reviewAdded: String, reviewUserImageURL: String) {
        self.reviewUserName = reviewUserName
        self.reviewMessage = reviewMessage
        self.reviewAdded = reviewAdded
        self.reviewUserImageURL = reviewUserImageURL
    }
    
    convenience init(review: Review) {
        let reviewUserName = review.appuserName
        let reviewMessage = review.review
        let reviewAdded = review.added
        let reviewUserImageURL = review.profilePhoto
        self.init(reviewUserName: reviewUserName!, reviewMessage: reviewMessage!, reviewAdded: reviewAdded!, reviewUserImageURL: reviewUserImageURL!)
        
    }
    
}
