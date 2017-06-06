//
//  RegisterViewController.swift
// Jupitertechs.com
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire
import UIKit

class RegisterViewController: UIViewController , UITextFieldDelegate{
    
    var fromWhere:String = ""
    weak var sendMessageDelegate : SendMessageDelegate?
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
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
    
    @IBAction func loadForgotPassword(_ sender: AnyObject) {
        if(self.fromWhere == "review") {
            weak var passworForgotViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentForgot") as? ForgotPasswordViewController
            passworForgotViewController!.fromWhere = "review"
            self.navigationController?.pushViewController(passworForgotViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("forgot")
        }
    }
    
    @IBAction func submitUser(_ : AnyObject) {
        
        if(userName.text != "" && userPassword.text != "" && userEmail.text != "") {
            _ = EZLoadingActivity.show("Loading...", disableUI: true)
            
            let params: [String: AnyObject] = [
                "username"  :  userName.text! as AnyObject,
                "email"     :  userEmail.text! as AnyObject,
                "password"  :  userPassword.text! as AnyObject,
                "about_me"  :  "" as AnyObject
            ]
            
            
            _ = Alamofire.request(APIRouters.AddAppUser(params)).responseObject {
                (response: DataResponse<StdResponse>) in
                
                if response.result.isSuccess {
                    if let res = response.result.value {
                        
                        if res.status == "success" {
                            print(res.intData)
                            
                            // Update menu
                            (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                            
                            // Add the user info to local
                            let plistPath = Common.instance.getLoginUserInfoPlist()
                            let dict: NSMutableDictionary = [:]
                            
                            let userID : Int = Int(res.intData)
                            print("User ID \(userID)")
                            dict.setObject("\(userID)" , forKey: "_login_user_id" as NSString)
                            dict.setObject(self.userName.text ?? "", forKey: "_login_user_username" as NSString)
                            dict.setObject(self.userEmail.text ?? "", forKey: "_login_user_email" as NSString)
                            dict.setObject("", forKey: "_login_user_about_me" as NSString)
                            dict.setObject("default_user_profile.png", forKey: "_login_user_profile_photo" as NSString)
                            
                            dict.write(toFile: plistPath, atomically: false)
                            
                            
                            _ = SweetAlert().showAlert(language.registerTitle, subTitle: language.registerSuccess, style: AlertStyle.success)
                            self.sendMessageDelegate?.returnmsg("profile")
                            _ = self.navigationController?.popViewController(animated: true)
                            let cityListController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentCityList") as? CityListControllerViewController
                            self.navigationController?.pushViewController(cityListController!, animated: true)
                            _ = EZLoadingActivity.hide()
                        }else{
                            _ = SweetAlert().showAlert(language.registerTitle, subTitle: res.data, style: AlertStyle.warning)
                        }
                    }
                } else {
                    print(response)
                }
                
                _ = EZLoadingActivity.hide()
                
            }
        } else {
            _ = SweetAlert().showAlert(language.registerTitle, subTitle: language.userInputEmpty, style: AlertStyle.warning)
            _ = EZLoadingActivity.hide()
            
            
        }
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavigationItemFont()
    }
    
    func setNavigationItemFont() {
        self.navigationController?.navigationBar.topItem?.title = language.registerTitle
        //self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func showAlert(title: String, msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        //self.present(alert, animated: true){}
        
        
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
   
    
}
