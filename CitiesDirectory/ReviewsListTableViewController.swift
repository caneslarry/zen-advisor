//
//  ReviewsListTableViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 13/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
//import Alamofire

@objc protocol ReviewListRefreshReviewCountsDelegate: class {
    func updateReviewCounts(_ reviews: [AnyObject])
}

class ReviewsListTableViewController: UITableViewController {
    
    var reviews = [ReviewModel]()
    var selectedItemId:Int = 0
    var selectedCityId:Int = 0
    weak var itemDetailRefreshReviewCountsDelegate : ItemDetailRefreshReviewCountsDelegate!
    weak var itemDetailLoginUserIdDelegate: ItemDetailLoginUserIdDelegate!
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 101
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ReviewsListTableViewController.onAddReview(_:)))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableView = nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        
        let review = reviews[(indexPath as NSIndexPath).row]
        cell.configure(review.reviewUserName,
            reviewMessageText:review.reviewMessage,
            reviewAdded: review.reviewAdded,
            reviewUserImageURL: review.reviewUserImageURL
        )
        
        var imageURL = ""
        if review.reviewUserImageURL == "" {
            imageURL = configs.imageUrl + "default_user_profile.png"
        } else {
            imageURL = configs.imageUrl + review.reviewUserImageURL
        }
        
        print("User Image URL : " + imageURL)
        cell.userImage?.loadImage(urlString: imageURL) {  (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                cell.userImage?.image = image
                
            }else {
                print("Error in loading image" + msg)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func onAddReview(_ sender: AnyObject) {
        if(Common.instance.isUserLogin()) {
            weak var reviewFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewEntryViewController") as? ReviewEntryViewController
            reviewFormViewController?.selectedItemId = selectedItemId
            reviewFormViewController?.reviewListRefreshReviewCountsDelegate = self
            reviewFormViewController?.selectedCityId = selectedCityId
            self.navigationController?.pushViewController(reviewFormViewController!, animated: true)
        } else {
            weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
            UserLoginViewController?.title = "Login"
            UserLoginViewController?.reviewListRefreshReviewCountsDelegate = self
            //UserLoginViewController?.itemDetailLoginUserIdDelegate = self
            UserLoginViewController?.itemDetailLoginUserIdDelegate = self.itemDetailLoginUserIdDelegate
            UserLoginViewController?.selectedCityId = selectedCityId
            UserLoginViewController?.selectedItemId = selectedItemId
            UserLoginViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
        }
        updateBackButton()
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.reviewListPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
    
}

extension ReviewsListTableViewController : ReviewListRefreshReviewCountsDelegate {
    func updateReviewCounts(_ reviews: [AnyObject]){
        
        if reviews.count > 0 {
            
            
            self.reviews = [ReviewModel]()
            self.tableView.reloadData()
            for review in reviews as! [ReviewModel] {
                self.reviews.append(review)
            }
            self.tableView.reloadData()
            self.itemDetailRefreshReviewCountsDelegate.updateReviewCounts(self.reviews.count, reviews: self.reviews)
            
        }
        
    }
}

