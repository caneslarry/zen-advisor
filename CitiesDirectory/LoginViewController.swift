//
//  LoginViewController.swift
// Jupitertechs.com
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire

class LoginViewController : UIViewController, UITextFieldDelegate {
    
    var fromWhere:String = ""
    var selectedItemId:Int = 0
    var selectedCityId:Int = 0
    weak var reviewListRefreshReviewCountsDelegate : ReviewListRefreshReviewCountsDelegate!
    weak var itemDetailLoginUserIdDelegate : ItemDetailLoginUserIdDelegate!
    
    weak var sendMessageDelegate : SendMessageDelegate?
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    

     @IBAction func loadRegister(_ sender: AnyObject) {
        if(self.fromWhere == "review" || self.fromWhere == "favourite" || self.fromWhere == "like") {
            weak var UserRegViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentRegister") as? RegisterViewController

            UserRegViewController?.fromWhere = "review"
            self.navigationController?.pushViewController(UserRegViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("register")
        }
    }
    

    @IBAction func loadForgotPassword(_ sender: AnyObject) {
        if(self.fromWhere == "review" || self.fromWhere == "favourite" || self.fromWhere == "like") {
            weak var passworForgotViewController =  self.storyboard?.instantiateViewController(withIdentifier: "ComponentForgot") as? ForgotPasswordViewController


            passworForgotViewController!.fromWhere = "review"
            self.navigationController?.pushViewController(passworForgotViewController!, animated: true)
            updateBackButton()
        } else {
            sendMessageDelegate?.returnmsg("forgot")
        }
    }
    
    @IBAction func submitLogin(_ sender: AnyObject) {
        self.dismissKeyboard()
        
        if txtEmail.text == "" || txtPassword.text == "" {
            _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.blankInputLogin, style: AlertStyle.warning)
        } else if txtEmail.text != ""{
            
            if(Common.instance.isValidEmail(txtEmail.text!)) {
                
                _ = EZLoadingActivity.show("Loading...", disableUI: true)
                
                let param: [String: AnyObject] = ["email": txtEmail.text! as AnyObject, "password": txtPassword.text! as AnyObject]
                _ = Alamofire.request(APIRouters.UserLogin(param)).responseObject() {
                    (response: DataResponse<User>) in
                    if response.result.isSuccess {
                        
                        if let user = response.result.value {
                            
                            // Normal ( From Profile Login)
                            if self.fromWhere == "" {
                            
                                let imageURL = configs.imageUrl + user.profilePhoto!
                                
                                print(" user profile + image url \(imageURL)")
                                //Alamofire.request(.GET, imageURL).validate(contentType: ["image/"]).responseImage()
                                //  response in
                                let img : UIImageView = UIImageView()
                                
                                img.loadImage(urlString: imageURL) { (status, url, image, msg) in
                                    if status == STATUS.success {
                                        self.saveImage(image)
                                        
                                        // Update menu
                                        (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                                        
                                        // Add the user info to local
                                        self.addToPlist(user)
                                        
                                        // Open profile Page
                                        self.sendMessageDelegate?.returnmsg("profile")
                                        
                                        _ = EZLoadingActivity.hide()
                                        
                                        _ = self.navigationController?.popViewController(animated: true)
                                        
                                    } else {
                                        _ = EZLoadingActivity.hide()
                                        
                                        _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.warning)
                                        
                                        //print(response)
                                    } // end of image loading status
                                }
                                
                            }else{ // For others
                                
                                // Add the user info to local
                                self.addToPlist(user)
                                
                                let imageURL = configs.imageUrl + user.profilePhoto!
                                
                                let img : UIImageView = UIImageView()
                                
                                img.loadImage(urlString: imageURL) { (status, url, image, msg) in
                                    if status == STATUS.success {
                                        self.saveImage(image)
                                        
                                    }
                                }
                                
                                // Update menu
                                (self.revealViewController().rearViewController as? MenuListController)?.userLoggedIn = true
                                
                                if(self.fromWhere == "review") {
                                    if(self.selectedItemId==0){
                                        self.selectedItemId = 9
                                        self.selectedCityId = 49
                                        
                                    }
                                    _ = self.navigationController?.popViewController(animated: true)
                                    let cityListController = self.storyboard?.instantiateViewController(withIdentifier: "ComponentCityList") as? CityListControllerViewController
                                    self.navigationController?.pushViewController(cityListController!, animated: true)
                                    _ = EZLoadingActivity.hide()
                                    
                                    
                                } else if (self.fromWhere == "favourite") {
                                    self.itemDetailLoginUserIdDelegate.updateLoginUserId(Int(user.id!)!)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    _ = EZLoadingActivity.hide()
                                } else if (self.fromWhere == "like") {
                                    self.itemDetailLoginUserIdDelegate.updateLoginUserId(Int(user.id!)!)
                                    _ = self.navigationController?.popViewController(animated: true)
                                    _ = EZLoadingActivity.hide()
                                }
                                
                            }
                           
                            
                        }else{
                            _ = EZLoadingActivity.hide()
                            _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.warning)
                            print(response)
                        }
                        
                    } else {
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.loginNotSuccessMessage, style: AlertStyle.warning)
                        print(response)
                    }
                }
                
            } else {
                _ = SweetAlert().showAlert(language.LoginTitle, subTitle: language.emailValidation, style: AlertStyle.warning)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateNavigationStuff()
    }
    
    override func viewDidLoad() {
       self.hideKeyboardWhenTappedAround()
    }
    
    func saveImage(_ image: UIImage?){
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        
        if image != nil {
            // Save it to our Documents folder
            let result = Common.instance.saveImage(image!, path: imagePath)
            print("Image saved? Result: \(result)")
            
        }
    }
    func addToPlist(_ user: User) {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let dict: NSMutableDictionary = [:]
        
        let userID : Int = Int(user.id!)!
        dict.setObject("\(userID)" , forKey: "_login_user_id" as NSString)
        dict.setObject(user.username ?? "", forKey: "_login_user_username" as NSString)
        dict.setObject(user.email ?? "", forKey: "_login_user_email" as NSString)
        dict.setObject(user.aboutMe ?? "", forKey: "_login_user_about_me" as NSString)
        dict.setObject(user.profilePhoto ?? "default_user_profile.png", forKey: "_login_user_profile_photo" as NSString)
        
        dict.write(toFile: plistPath, atomically: false)
    }
    
    func updateNavigationStuff() {
        self.navigationController?.navigationBar.topItem?.title = language.LoginTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
    }
    
    func updateBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}

