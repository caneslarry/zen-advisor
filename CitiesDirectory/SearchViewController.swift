//
//  SearchViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 11/23/15.
//  Copyright © 2015 Panacea-soft. All rights reserved.
//

import UIKit
//import iAd


class SearchViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchKeyword: UITextField!
    
    @IBAction func doSearch(_ sender: AnyObject) {
        let selectedValue = CitiesListModel.sharedManager.cities[pickerView.selectedRow(inComponent: 0)].id
        let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResult") as? SearchResultViewController
        self.navigationController?.pushViewController(resultViewController!, animated: true)
        resultViewController?.selectedCityId = Int(selectedValue)!
        resultViewController?.searchKeyword = searchKeyword.text
        updateBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
       if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
       
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CitiesListModel.sharedManager.cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return CitiesListModel.sharedManager.cities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = CitiesListModel.sharedManager.cities[row].name
        pickerLabel.font = UIFont(name: customFont.normalFontName , size: CGFloat(customFont.pickerFontSize)) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.searchPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
   
}
