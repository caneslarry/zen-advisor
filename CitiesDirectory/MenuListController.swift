//
//  MenuListController.swift
//  CitiesDirectory
//
//  Created by Panacea-soft on 2/9/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import UIKit

class MenuListController: UITableViewController {
    
    var userLoggedIn : Bool = false {
        didSet {
            updateMenu()
        }
    }
    
    @IBOutlet weak var homeCell: UITableViewCell!
    @IBOutlet weak var searchCell: UITableViewCell!
    @IBOutlet weak var pushNotiCell: UITableViewCell!
    @IBOutlet weak var profileCell: UITableViewCell!
    @IBOutlet weak var myFavCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var search: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var favourite: UILabel!
    @IBOutlet weak var logout: UILabel!
    
    override func viewDidLoad() {
        if(Common.instance.isUserLogin()) {
            self.userLoggedIn = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        home.text = language.homeMenu
        search.text = language.searchMenu
        profile.text = language.ProfileMenu
        favourite.text = language.favouriteMenu
        logout.text = language.logoutMenu
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Logout
        if((indexPath as NSIndexPath).row == 4){
            self.revealViewController().revealToggle(nil)
            let rowToSelect:IndexPath = IndexPath(row: 0, section: 0);
            self.tableView.selectRow(at: rowToSelect, animated: true, scrollPosition: UITableViewScrollPosition.none);
            self.userLoggedIn = false
            performSegue(withIdentifier: "CitiesListHome", sender: self)
            updatePlist()
            
            // Delete the profile image from local
            let imagePath = Common.instance.fileInDocumentsDirectory("profile_.png")
            Common.instance.deleteImageFromPath(imagePath)
        }
    }
    
    func updateMenu(){
        if userLoggedIn {
            myFavCell?.isHidden = false
            logoutCell?.isHidden = false

        }else{
            myFavCell?.isHidden = true
            logoutCell?.isHidden = true

        }

    }
    
    func updatePlist() {
        let plistPath = Common.instance.getLoginUserInfoPlist()
        let dict: NSMutableDictionary = [:]
        
        dict.setObject("", forKey: "_login_user_id" as NSCopying)
        dict.setObject("", forKey: "_login_user_username" as NSCopying)
        dict.setObject("", forKey: "_login_user_email" as NSCopying)
        dict.setObject("", forKey: "_login_user_about_me" as NSCopying)
        dict.setObject("", forKey: "_login_user_profile_photo" as NSCopying)
        
        dict.write(toFile: plistPath, atomically: false)
        
    }
}
