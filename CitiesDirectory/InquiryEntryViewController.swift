//
//  InquiryEntryViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 18/2/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire

class InquiryEntryViewController: UIViewController, UITextViewDelegate {
    
    var placeholderLabel : UILabel!
    var selectedItemId:Int = 0
    var cityId:Int = 0
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var inquiryMessage: UITextView!
    
    @IBOutlet weak var submit: UIButton!
    @IBAction func SubmitInquiry(_ sender: AnyObject) {
        
        if(userName.text != "" || userEmail.text != "" || inquiryMessage.text != "") {
            
            let params: [String : AnyObject] = [
                "name"   : userName.text! as AnyObject,
                "email"  : userEmail.text! as AnyObject,
                "message": inquiryMessage.text! as AnyObject,
                "city_id": cityId as AnyObject
            ]
            
           
            _ = Alamofire.request(APIRouters.AddItemInquiry(selectedItemId, params)).responseObject{
                (response: DataResponse<StdResponse>) in
                
                if response.result.isSuccess {
                    if let resp = response.result.value {
                        if(resp.status == "success") {
                            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.inquirySentSuccess, style: AlertStyle.success)
                            self.cleanTextInput()
                        } else {
                            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.somethingWrong, style: AlertStyle.warning)
                        }
                    }
                } else {
                    print(response)
                }
            }
            
        } else {
            _ = SweetAlert().showAlert(language.inquiryTitle, subTitle: language.inquiryEmpty, style: AlertStyle.warning)
            
        }
        
        
    }
    
    override func viewDidLoad() {
        addPlaceHolder()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
        submit.setTitle(language.submit, for: UIControlState())
    }
    
    func addPlaceHolder() {
        inquiryMessage.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = language.typeInquiryMessage
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: inquiryMessage.font!.pointSize)
        placeholderLabel.sizeToFit()
        inquiryMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: inquiryMessage.font!.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.isHidden = !inquiryMessage.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func cleanTextInput() {
        userName.text = ""
        userEmail.text = ""
        inquiryMessage.text = ""
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.inquiryPageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
}
