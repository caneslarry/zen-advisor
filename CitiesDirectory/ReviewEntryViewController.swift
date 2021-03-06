//
//  ReviewEntryViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 15/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire

class ReviewEntryViewController: UIViewController, UITextViewDelegate {
    
    var placeholderLabel : UILabel!
    var selectedItemId:Int = 0
    var loginUserId:Int = 0
    var selectedCityId:Int = 0
    var reviews = [ReviewModel]()
    weak var reviewListRefreshReviewCountsDelegate : ReviewListRefreshReviewCountsDelegate!
    
    @IBOutlet weak var loginUserName: UILabel!
    @IBOutlet weak var loginUserEmail: UILabel!
    
    @IBOutlet weak var userReview: UITextView!
    @IBOutlet weak var submit: UIButton!
    @IBAction func reviewSubmit(_ sender: AnyObject) {
        
        if(userReview.text != "") {
            
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            let params = [
                "appuser_id": loginUserId,
                "review"    : userReview!.text,
                "city_id"   : selectedCityId
            ] as [String : Any]
            
            
            _ = Alamofire.request(APIRouters.AddItemReview(selectedItemId, params as [String : AnyObject])).responseObject{
                (response: DataResponse<Item>) in
                
                _ = EZLoadingActivity.hide()
                
                if response.result.isSuccess {
                    if let item = response.result.value {
                        if(item.reviews.count > 0){
                            for review in item.reviews {
                                let oneReview = ReviewModel(review: review)
                                self.reviews.append(oneReview)
                            }
                            self.reviewListRefreshReviewCountsDelegate.updateReviewCounts(self.reviews)
                            self.navigationController!.popViewController(animated: true)
                        }
                        
                    }
                } else {
                    print(response)
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.reviewTitle, subTitle: language.reviewEmpty, style: AlertStyle.warning)
        }
        
        
    }
    
    override func viewDidLoad() {
        addPlaceHolder()
        loadLoginUserId()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        submit.setTitle(language.submit, for: UIControlState())
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userReview = nil
        loginUserName = nil
        loginUserEmail = nil
        submit = nil
    }
    
    func loadLoginUserId() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        if let dict = myDict {
            loginUserId = Int(dict.object(forKey: "_login_user_id") as! String)!
            loginUserName.text = dict.object(forKey: "_login_user_username") as! String!
            loginUserEmail.text = dict.object(forKey: "_login_user_email") as! String!
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func addPlaceHolder() {
        userReview.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = language.typeReviewMessage
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: userReview.font!.pointSize)
        placeholderLabel.sizeToFit()
        userReview.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: userReview.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !userReview.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.reviewEntryPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
        
    }
    
}
