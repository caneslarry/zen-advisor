//
//  SelectedCityViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 3/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import UIKit
import Alamofire
import AVFoundation

class SelectedCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories: [AnyObject] = []
    var selectedCityId: Int!
    var subCategoriesSelected: [SubCategory] = []
    var cityModel: CityModel? = nil
    var cats = [Categories]()
    var cityInfo : CityModel? = nil
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var cityName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShopData()
        addNavigationMenuItem()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        categoryTableView = nil
        cityName = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        weak var categoryCell = sender as? CategoryCell
        weak var itemsGridPage = segue.destination as? ItemsGridViewController
                let selectedSubCategoryID = categoryCell!.subCategoryId
                itemsGridPage!.selectedSubCategoryId = Int(selectedSubCategoryID)!
                itemsGridPage!.selectedCityId = Int(cityModel!.id)!
                itemsGridPage!.selectedCityLat = cityModel!.lat
                itemsGridPage!.selectedCityLng = cityModel!.lng
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cats[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if((indexPath as NSIndexPath).section == 0 ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CategoryHeaderCell
            cell.configure(cityModel!)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
            cell.selecedCategory = cats[(indexPath as NSIndexPath).section]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0 ){
            return 1.0;
        }
        return 32.0;
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.font = UIFont(name: customFont.normalFontName, size: CGFloat(customFont.tableHeaderFontSize))
            
            if(section == 0 ){
                view.textLabel!.text = ""
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((indexPath as NSIndexPath).section == 0){
            return 200.0
        }
        
        return 122
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.selectedCityPageTitle + (cityModel?.name)!
        self.navigationController?.navigationBar.tintColor =  UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }

    
    func loadShopData() {
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        _ = Alamofire.request(APIRouters.GetCityByID(Int(cityModel!.id)!)).responseObject { (response: DataResponse<City>) in
            
            if response.result.isSuccess {
                if let onecity: City = response.result.value {
                    
                    var subCategoryArray = [SubCategories]()
                    var categoryArray = [Categories]()
                    
                    // set city name
                    self.navigationController?.navigationBar.topItem?.title = onecity.name
                    
                    // For Header Cell
                    // Table is working based on the Cateogries.
                    // That why need to create the dummy cell for city header
                    subCategoryArray.removeAll()
                    let tempCat = Categories(id: onecity.id!, name: onecity.name!, subCategory: subCategoryArray)
                    categoryArray.append(tempCat)
                    print(" Cover Image Height : \(onecity.coverImageHeight)")
                    self.cityModel?.id = onecity.id!
                    self.cityModel?.backgroundImage = onecity.coverImageFile!
                    self.cityModel?.name = onecity.name!
                    
                    // set categories
                    for cat in onecity.categories {
                        
                        subCategoryArray.removeAll()
                        
                        for subCat in cat.subCategories {
                            let tempSubCat = SubCategories(id: subCat.id!,name: subCat.name!, imageURL: subCat.coverImageFile!)
                            subCategoryArray.append(tempSubCat)
                            
                        }
                        
                        let tempCat = Categories(id: cat.id!, name: cat.name!, subCategory: subCategoryArray)
                        categoryArray.append(tempCat)
                        
                        
                    }
                    
                    self.cats = categoryArray
                    self.categoryTableView.reloadData()
                    _ = EZLoadingActivity.hide()
                    
                } else {
                    print(response)
                }
            }
 
            
        }
    }
    
    func addNavigationMenuItem() {
        let btnNewsFeed = UIButton()
        btnNewsFeed.setImage(UIImage(named: "Rss-Lite-White"), for: UIControlState())
        btnNewsFeed.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnNewsFeed.addTarget(self, action: #selector(SelectedCityViewController.loadNewsViewController(_:)), for: .touchUpInside)
        let itemNavi = UIBarButtonItem()
        itemNavi.customView = btnNewsFeed
        self.navigationItem.rightBarButtonItems = [itemNavi]
    }
    
    
    
    func loadNewsViewController(_ sender: UIBarButtonItem) {
        weak var feedViewController = self.storyboard?.instantiateViewController(withIdentifier: "FeedList") as? NewsFeedTableViewController
        self.navigationController?.pushViewController(feedViewController!, animated: true)
        feedViewController?.selectedCityId = Int(cityModel!.id)!
    }
    
   
   
}

