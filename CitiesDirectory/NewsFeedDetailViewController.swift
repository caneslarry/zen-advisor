//
//  NewsFeedDetailViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 23/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
//import Alamofire

class NewsFeedDetailViewController: UIViewController {
    
    var feedTitle: String!
    var feedDesc: String!
    var feedImages = [Image]()
    var itemImages = [ImageModel]()
    
    @IBOutlet weak var feedCoverImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UITextView!
    
    override func viewDidLoad() {
        newsTitle.text = feedTitle
        newsDescription.text = feedDesc
        
        let imageURL = configs.imageUrl + feedImages[0].path!
        
        feedCoverImage.loadImage(urlString: imageURL) { (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }
        
        
        if(feedImages.count > 0) {
            for image in feedImages {
                let oneImage = ImageModel(image: image)
                self.itemImages.append(oneImage)
                
            }
            ImageViewTapRegister()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func ImageViewTapRegister() {
        let feedImageTap = UITapGestureRecognizer(target: self, action: #selector(NewsFeedDetailViewController.feedImageTapped(_:)))
        feedImageTap.numberOfTapsRequired = 1
        feedImageTap.numberOfTouchesRequired = 1
        self.feedCoverImage.addGestureRecognizer(feedImageTap)
        self.feedCoverImage.isUserInteractionEnabled = true
    }
    
    func feedImageTapped(_ recognizer: UITapGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.ended){
            let imgSliderViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSlider") as? ImageSliderViewController
            self.navigationController?.pushViewController(imgSliderViewController!, animated: true)
            imgSliderViewController?.itemImages = self.itemImages
            updateBackButton()
        }
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.feedDetailPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
    
}
