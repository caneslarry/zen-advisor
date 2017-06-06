//
//  ForgotPasswordViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 14/1/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire

class ForgotPasswordViewController : UIViewController, UITextFieldDelegate {
    var fromWhere: String = ""
    weak var sendMessageDelegate : SendMessageDelegate?
    @IBOutlet weak var userEmail: UITextField!
    
    @IBAction func loadLogin(_ sender: AnyObject) {
        
        if(self.fromWhere == "review") {
            weak var UserLoginViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentLogin") as? LoginViewController
            UserLoginViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserLoginViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("login")
        }
    }
    
    @IBAction func loadRegister(_ sender: AnyObject) {
        
        if(self.fromWhere == "review") {
            weak var UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as? RegisterViewController
            UserRegViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserRegViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("register")
        }
    }
    
    
    @IBAction func submitPassword(_ sender: AnyObject) {
        if(userEmail.text != "") {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            let params: [String: AnyObject] = [
                "email"  :  userEmail.text! as AnyObject
            ]
            
            _ = Alamofire.request(APIRouters.ResetPassword(params)).responseObject {
                (response: DataResponse<StdResponse>) in
                
                if response.result.isSuccess {
                    if let res = response.result.value {
                        print(res.data)
                        _ = SweetAlert().showAlert(language.resetTitle, subTitle: language.resetSuccess, style: AlertStyle.success)
                        self.sendMessageDelegate?.returnmsg("login")
                        
                        self.dismissKeyboard()
                    }
                } else {
                    print(response)
                }
                
                _ = EZLoadingActivity.hide()
                
            }
        } else {
            _ = SweetAlert().showAlert(language.resetTitle, subTitle: language.userEmailEmpty, style: AlertStyle.warning)
        }
        
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationItemFont()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userEmail = nil
    }
    
    func setNavigationItemFont() {
        self.navigationController?.navigationBar.topItem?.title = language.forgotTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}

