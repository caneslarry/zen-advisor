//
//  FeedCell.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 23/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
//import Alamofire

class FeedCell: UITableViewCell {
    
    
    @IBOutlet weak var feedCoverImage: UIImageView!
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedDesc: UILabel!
    @IBOutlet weak var feedAdded: UILabel!
    
    var feedImages = [Image]()
    
    
    func configure(_ title: String, desc: String, added: String, imageName: String, feedImgs: [Image]) {
        
        feedTitle.text = title
        feedDesc.text = desc
        feedAdded.text = added
        feedImages = feedImgs
    }
}
