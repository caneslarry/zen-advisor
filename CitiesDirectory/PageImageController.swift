//
//  PageItemController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 19/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import UIKit

class PageImageController: UIViewController {
 
    var itemIndex: Int = 0
    var imageDesc: String = ""
    var imageName: String = ""
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var imageDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url : String = "\(configs.imageUrl)\(imageName)"
        itemImageView.loadImage(urlString: url) { (status, url, image, msg) in
            if status == STATUS.success {
                print("loaded : \(url)")
                
            }
        }
        imageDescription.text = imageDesc
    }
    
    
}
