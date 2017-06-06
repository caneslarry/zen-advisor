//
//  NewsFeedViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 22/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire

class NewsFeedTableViewController : UITableViewController {
    
    var selectedCityId: Int!
    var feeds = [NewsFeedModel]()
    var itemImages = [ImageModel]()
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad(){
        loadNewsFeed()
        self.refreshControl?.addTarget(self, action: #selector(NewsFeedTableViewController.onTableViewRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        let feed = feeds[(indexPath as NSIndexPath).row]
        cell.configure(feed.newsFeedTitle, desc: feed.newsFeedDesc, added: feed.newsFeedAdded, imageName: feed.newsFeedImage, feedImgs: feed.newsFeedImages)
        
        let imageURL = configs.imageUrl + feed.newsFeedImage
        
        cell.feedCoverImage?.loadImage(urlString: imageURL){  (status, url, image, msg) in
            if(status == STATUS.success) {
                print(url + " is loaded successfully.")
                
            }else {
                print("Error in loading image" + msg)
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FeedCell
        let feedDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetail") as? NewsFeedDetailViewController
        self.navigationController?.pushViewController(feedDetailViewController!, animated: true)
        feedDetailViewController?.feedTitle = cell.feedTitle.text
        feedDetailViewController?.feedDesc = cell.feedDesc.text
        feedDetailViewController?.feedImages = cell.feedImages
        updateBackButton()
    }
    
    func onTableViewRefresh(_ sender:AnyObject)
    {
        self.feeds.removeAll()
        loadNewsFeed()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func loadNewsFeed() {
    
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
       
        Alamofire.request(APIRouters.GetNewsFeedByCityId(selectedCityId!)).responseCollection { (response: DataResponse<[NewsFeed]>) in
            if response.result.isSuccess {
                if let newsFeeds: [NewsFeed] = response.result.value {
                    
                    for newsFeed in newsFeeds {
                        let oneFeed = NewsFeedModel(newsFeed: newsFeed)
                        self.feeds.append(oneFeed)
                    }
                    self.tableView.reloadData()
                    _ = EZLoadingActivity.hide()
                    
                } else {
                    _ = EZLoadingActivity.hide()

                    print(response)
                }
            }
            
            
        }
        
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.feedListPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
}
