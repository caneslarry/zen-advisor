//
//  CategoryHeaderCell.swift
//  CitiesDirectory
//
//  Created by Thet Paing Soe on 3/25/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
//import Alamofire

class CategoryHeaderCell : UITableViewCell {
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    
    func configure(_ data: CityModel) {
        // load image and set to header image view
        
        if data.backgroundImage != "" {
            let coverImageName = data.backgroundImage as String
            let coverImageURL = configs.imageUrl + coverImageName
            
            self.headerImageView.loadImage(urlString: coverImageURL) { (status, url, image, msg) in
                if(status == STATUS.success) {
                    print(url + " is loaded successfully.")
                }else {
                    print("Error in loading image" + msg)
                }
            }
            
         /*TOFIX   Alamofire.request(.GET, coverImageURL).validate(contentType: ["image/\*"]).responseImage() {
                response in
                
                if response.result.isSuccess {
                    self.headerImageView.image = response.result.value
                } else {
                    // Need to set default image
                }
            }*/
        }
        
    }
    
}
