//
//  RestApiManager.swift
//  sample1
//
//  Created by BST Icode on 10/9/15.
//  Copyright © 2015 BST Icode. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD


typealias ServiceResponse = (JSON, NSError?) -> Void



//var baseURL = "http://app.pstforex.com/appservices.pstforex.com/AppService.svc/json/"

var baseURL = "http://pstforex.com/forexapp/AppService.svc/json/"


class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    
    
    
    
    func getRandomUser(onCompletion: @escaping (JSON) -> Void) {
        
        
          let url:String =  UserDefaults.standard.object(forKey: "url") as! String
        
     
        let route = baseURL + url

    
        
        
        print(route);
        makeHTTPGetRequest(path: route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    

    
    
    
    
    
    
    func makeHTTPGetRequest(path: String, onCompletion: @escaping ServiceResponse) {
        
        
        let encodedString = path.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let request = NSURLRequest(url:  NSURL(string: encodedString!)! as URL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in

            DispatchQueue.main.async(execute: {
            
                if (error != nil) {
                    
                    SVProgressHUD .dismiss()
                    let alert1 = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
                    alert1.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert1, animated: true, completion: nil)
                
                }
                    
                    else {
                    
                    let json:JSON = JSON(data: data!)
                    onCompletion(json, error as NSError?)
                    
                }
            })
            
        })
        task.resume()
        
        
        
    }
    
    
    
    
}

