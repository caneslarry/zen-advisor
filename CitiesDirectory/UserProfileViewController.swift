//
//  UserProfileViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 17/1/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import UIKit
//import Alamofire

class UserProfileViewController: UIViewController {
    
    weak var sendMessageDelegate : SendMessageDelegate?
    var loginUserId: Int = 0
    var loginUserName: String = ""
    var loginUserProfilePhoto: String = ""
    var loginUserEmail: String = ""
    var loginUserAboutMe: String = ""
    var downloadedPhotoURLs: [URL]?
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtAboutMe: UITextView!
    @IBOutlet weak var imgUserProfileBG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUserInfo()
        
        //txtAboutMe.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _ = Common.instance.circleImageView(imgUserProfile)
        setNavigationItemFont()
    }
    
    func setNavigationItemFont() {
        self.navigationController?.navigationBar.topItem?.title = language.profilePageTitle
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: customFont.boldFontName, size: CGFloat(customFont.boldFontSize))!,  NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.barTintColor = Common.instance.colorWithHexString(configs.barColorCode)
    }
    
    func saveImage(_ image: UIImage?){
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        
        if image != nil {
            // Save it to our Documents folder
            let result = Common.instance.saveImage(image!, path: imagePath)
            print("Image saved? Result: \(result)")
            
        }
    }
    
    func bindUserInfo() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        
        let fileManager = FileManager.default
        
        if(!fileManager.fileExists(atPath: plistPath)) {
            if let bundlePath = Bundle.main.path(forResource: "LoginUserInfo", ofType: "plist") {
                
                do{
                    try fileManager.copyItem(atPath: bundlePath, toPath: plistPath)
                } catch{
                
                }
                
                
            } else {
                //print("LoginUserInfo.plist not found. Please, make sure it is part of the bundle.")
            }
            
            
        } else {
            //print("LoginUserInfo.plist already exits at path.")
        }
        
        let myDict = NSDictionary(contentsOfFile: plistPath)
        
        if let dict = myDict {
            loginUserId           = Int(dict.object(forKey: "_login_user_id") as! String)!
            loginUserName         = dict.object(forKey: "_login_user_username") as! String
            loginUserProfilePhoto = dict.object(forKey: "_login_user_profile_photo") as! String
            loginUserEmail        = dict.object(forKey: "_login_user_email") as! String
            loginUserAboutMe      = dict.object(forKey: "_login_user_about_me") as! String
            
            lblName.text = loginUserName
            lblEmail.text = loginUserEmail
            txtAboutMe.text = loginUserAboutMe
            txtAboutMe.isEditable = false
            
            
                let imageURL = configs.imageUrl + self.loginUserProfilePhoto

                print("Image Url : \(imageURL)")
                self.imgUserProfile.loadImage(urlString: imageURL){ (status, url, image, msg) in
                    if(status == STATUS.success) {
                        print(url + " is loaded successfully.")

                        self.saveImage(image)
                    }else {
                        print("Error in loading image" + msg)
                    }
                }
            

            
            // set imagePath
            
            let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
            let loadedImage = Common.instance.loadImageFromPath(imagePath)
            if loadedImage != nil {
                print("Image loaded: \(loadedImage!)")
                self.imgUserProfile.image = loadedImage
                self.imgUserProfileBG.image = loadedImage
            }
            
            
        } else {
            //print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    
}
