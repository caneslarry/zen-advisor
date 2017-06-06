//
//  UserProfileEditViewController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 25/1/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import UIKit
import Alamofire

class UserProfileEditViewController: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var loginUserId: Int = 0
    var loginUserName: String = ""
    var loginUserProfilePhoto: String = ""
    var loginUserEmail: String = ""
    var loginUserAboutMe: String = ""
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAbout: UITextView!
    @IBOutlet weak var ProfilePhoto: UIImageView!
    @IBOutlet weak var btnChoose: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBAction func doProfileUpdate(_ sender: AnyObject) {
        
        _ = EZLoadingActivity.show("Loading...", disableUI: true)
        
        if(txtNewPassword.text == "" && txtConfirmPassword.text == "") {
            let params: [String: AnyObject] = [
                "email"   : txtEmail.text! as AnyObject ,
                "username": txtName.text! as AnyObject ,
                "about_me": txtAbout.text! as AnyObject,
                "platformName": "ios" as AnyObject
            ]
            
            _ = Alamofire.request(APIRouters.UpdateAppUser(loginUserId, params)).responseObject {
                (response: DataResponse<StdResponse>) in
                
                if response.result.isSuccess {
                    if let res = response.result.value {
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.success)
                        self.updateLocalProfile()
                    }
                } else {
                    if let res = response.result.value {
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.warning)
                    } else {
                        _ = EZLoadingActivity.hide()
                        _ = SweetAlert().showAlert(language.profileUpdate,subTitle: language.tryAgainToConnect ,style:AlertStyle.error)
                    }
                }
            }
            
            
        } else if(txtNewPassword.text != "" || txtConfirmPassword.text != "") {
            if(txtNewPassword.text != txtConfirmPassword.text) {
                _ = EZLoadingActivity.hide()
                _ = SweetAlert().showAlert(language.profileUpdate,subTitle:language.doNotMatch ,style:AlertStyle.warning)
            } else {
                let params: [String: AnyObject] = [
                    "email"   : txtEmail.text! as AnyObject,
                    "username": txtName.text! as AnyObject,
                    "about_me": txtAbout.text! as AnyObject,
                    "password": txtConfirmPassword.text! as AnyObject,
                    "platformName": "ios" as AnyObject
                ]
                print(params)
                
               
                _ = Alamofire.request(APIRouters.UpdateAppUser(loginUserId , params)).responseObject {
                    (response: DataResponse<StdResponse>) in
                    
                    if response.result.isSuccess {
                        if let res = response.result.value {
                            _ = EZLoadingActivity.hide()
                            
                            _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.success)
                            self.updateLocalProfile()
                        }
                    } else {
                        if let res = response.result.value {
                            _ = EZLoadingActivity.hide()
                            _ = SweetAlert().showAlert(language.profileUpdate,subTitle:res.data ,style:AlertStyle.warning)
                        } else {
                            _ = EZLoadingActivity.hide()
                            _ = SweetAlert().showAlert(language.profileUpdate,subTitle: language.tryAgainToConnect ,style:AlertStyle.error)
                        }
                    }
                }
                
            }
            
        }
        
        
        
    }
    
    
    @IBAction func loadImageFromLibrary(_ : AnyObject) {
        
        //DispatchQueue.main.async {
        //self.picker!.allowsEditing = false
        //self.picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //self.present(self.picker!, animated: true, completion: nil)
        //self.btnUpload.isEnabled = true
       // }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            self.btnUpload.isEnabled = true
        }
    }
    
    
    @IBAction func btnUpload(_ sender: AnyObject) {
        
        _ = EZLoadingActivity.show("Uploading...", disableUI: true)
        
        // set imagePath
        let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
        var image2 = ProfilePhoto.image
        print("image width and height \(image2?.size.width) \(image2?.size.height)")
        
        let size:CGSize = Common.instance.getImageSize(image2!.size)
        image2 = Common.instance.scaleUIImageToSize(image2!, size: size)
        print("Converted size : \(image2?.size.width) \(image2?.size.height)")
        ProfilePhoto.image = image2
        
        UploadImage(url: APIRouters.profilePhotoUpload,userID : loginUserId, image: ProfilePhoto) { (status, data, msg) in
            
            if status == STATUS.success {
                self.loginUserProfilePhoto = data
                print("Profile : " + self.loginUserProfilePhoto)
                self.updateLocalProfile()
                
                if image2 != nil {
                    // Save it to our Documents folder
                    let result = Common.instance.saveImage(image2!, path: imagePath)
                    print("Image saved? Result: \(result)")
                    
                    // Load image from our Documents folder
                    let loadedImage = Common.instance.loadImageFromPath(imagePath)
                    if loadedImage != nil {
                        print("Image loaded: \(loadedImage!)")
                        self.ProfilePhoto.image = loadedImage
                    }
                }
                
                _ = EZLoadingActivity.hide()
               
                _ = SweetAlert().showAlert(language.profileUpdate,subTitle: language.profilePhotoUploaded ,style:AlertStyle.success)
                
                
            } else {
                    _ = EZLoadingActivity.hide()
                _ = SweetAlert().showAlert(language.profileUpdate,subTitle: language.tryAgainToConnect ,style:AlertStyle.error)
                    //print("error : " + msg)
                }
            }
        
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //_ = Common.instance.circleImageView(ProfilePhoto)
        _ = Common.instance.setTextViewBorderColor(txtAbout)
        bindUserInfo()
        picker?.delegate=self
        btnUpload.isEnabled = false
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _ = Common.instance.circleImageView(ProfilePhoto)
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
            
            txtName.text = loginUserName
            txtEmail.text = loginUserEmail
            txtAbout.text = loginUserAboutMe
            
            let imageURL = configs.imageUrl + loginUserProfilePhoto
            
            self.ProfilePhoto.loadImage(urlString: imageURL){ (status, url, image, msg) in
                if(status == STATUS.success) {
                    print(url + " is loaded successfully.")
                    
                }else {
                    print("Error in loading image" + msg)
                }
            }
            
            // set imagePath
            let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
            let loadedImage = Common.instance.loadImageFromPath(imagePath)
            if loadedImage != nil {
                print("Image loaded: \(loadedImage!)")
                self.ProfilePhoto.image = loadedImage
            }

            
            
        } else {
            print("WARNING: Couldn't create dictionary from LoginUserInfo.plist! Default values will be used!")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ProfilePhoto.contentMode = .scaleAspectFit
            ProfilePhoto.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func updateLocalProfile() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let dict: NSMutableDictionary = [:]
        
        dict.setObject("\(loginUserId)", forKey: "_login_user_id" as NSString)
        dict.setObject(txtName.text ?? "", forKey: "_login_user_username" as NSString)
        dict.setObject(txtEmail.text ?? "", forKey: "_login_user_email" as NSString)
        dict.setObject(txtAbout.text ?? "", forKey: "_login_user_about_me" as NSString)
        dict.setObject(loginUserProfilePhoto, forKey: "_login_user_profile_photo" as NSString)
        
        dict.write(toFile: plistPath, atomically: false)
    }
    
    
}

