//
//  Extensions.swift
//  CitiesDirectory
//
//  Created by Thet Paing Soe on 10/3/16.
//  Copyright © 2017 JupiterTechs.com All rights reserved.//

import Foundation
import Alamofire

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // For image loading from server with url
    func loadImage(urlString : String, completionHandler: @escaping (String, String, UIImage, String) -> Void) {
        
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
            self.image = imageFromCache
            completionHandler(STATUS.success, urlString, imageFromCache, "success")
            return
        }
 
        print("URL : " + urlString)
        Alamofire.request(urlString).responseData { response in
            guard let data = response.result.value else {
                let errmsg : String = "error in loading image."
                let img = UIImage()
                
                completionHandler(STATUS.fail, urlString, img, errmsg)
                
                return
            }
            self.image = UIImage(data: data)
            
            if self.image != nil {
            
                imageCache.setObject(self.image!, forKey: urlString as AnyObject)
                completionHandler(STATUS.success, urlString, self.image!, "success")
            }else {
                completionHandler(STATUS.fail, urlString, UIImage(), "success")
            }
            
            
        }

        /*
            //-------------------
            // URL Session Code
            //-------------------
        DispatchQueue.main.async {
            // Check image in cache
            if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage
            {
                self.image = imageFromCache
                completionHandler(STATUS.success, urlString, imageFromCache, "success")
                return
            }
            
            let request = URLRequest(url: URL(string: urlString)!)
            
            
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    let errmsg : String = "error=\(error)"
                    let img = UIImage()
                    completionHandler(STATUS.fail, urlString, img, errmsg)
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    let errmsg : String = "statusCode should be 200, but is \(httpStatus.statusCode)";
                    print("response = \(response)")
                    let img = UIImage()
                    completionHandler(STATUS.fail, urlString, img, errmsg)
                    return
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                
                let image = UIImage(data: data)
                
                if (image != nil)
                {
                    
                    
                    self.image = image
                    imageCache.setObject(image!, forKey: urlString as AnyObject)
                    
                    completionHandler(STATUS.success, urlString, image!, "success")
                    
                    
                    /* func set_image()
                     {
                     
                     self.image = image
                     imageCache.setObject(image!, forKey: urlString as AnyObject)
                     }
                     
                     let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
                     queue.sync(execute: set_image)*/
                    //DispatchQueue.main.asynchronously(execute: set_image)
                    
                }
            }
            task.resume()
            
        }*/
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
