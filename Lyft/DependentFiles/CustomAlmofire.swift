//
//  CustomAlmofire.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.
//

import UIKit
import Alamofire
//import SVProgressHUD
import Foundation
import Network


enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class CustomAlmofire: NSObject {
    
    class func dataTask_GET(_ path: URL, method: HTTPMethod, param: Dictionary<String, Any>, compilationBlock:@escaping (_ result: Result<Any, NSError> ) -> Void){
        
        var headers: HTTPHeaders = [ "Content-Type": "application/json"]
        if let authToken = UserDefaults.standard.string(forKey: kSessionAccessToken) {
            headers["Authorization"] = "Bearer" + " " + authToken
        }else{
            headers ["Authorization"] = "Bearer token_key"
        }
//        let headers: HTTPHeaders = ["Authorization": "Bearer \(String(describing: UserDefaults.standard.value(forKey: kSessionAccessToken) as? String))"]
        print("URL before Api Calling:- ",path)
        //        let headers: HTTPHeaders = [
        ////            "Content-Type": "application/json",
        ////            "X-Requested-With": "XMLHttpRequest",
        ////            "Cache-Control": "no-cache",
        //            "Authorization": "Bearer " + kAppDelegate.getLoginToken()]
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForResource = 5 // seconds
//
        //let alamofireManager = Alamofire.SessionManager(configuration: configuration)
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(path, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(let JSON):
                compilationBlock(.success(JSON))
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    let customError = NSError(domain: "Timeout", code: 67, userInfo: [NSLocalizedDescriptionKey : Constants.timeOutMessage.localize()]);
                    compilationBlock(.failure(customError))
                }else{
                    let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : Constants.somethingWentWrong.localize()]);
                    compilationBlock(.failure(customError))
                }
                
                break
            }
        }
    }
    
    class func dataTask_PUT(_ path: URL, method: HTTPMethod, param: Dictionary<String, Any>, compilationBlock:@escaping (_ result: Result<Any, NSError> ) -> Void){
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Cache-Control": "no-cache"]
        if let authToken = UserDefaults.standard.string(forKey: kSessionAccessToken) {
            headers["Authorization"] = "Bearer" + " " + authToken
        }else{
            headers ["Authorization"] = "Bearer token_key"
        }
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(path, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(let JSON):
                compilationBlock(.success(JSON))
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    let customError = NSError(domain: "Timeout", code: 67, userInfo: [NSLocalizedDescriptionKey : Constants.timeOutMessage.localize()]);
                    compilationBlock(.failure(customError))
                }else{
                    let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : Constants.somethingWentWrong.localize()]);
                    compilationBlock(.failure(customError))
                }
                
                break
            }
        }
    }
    
    class func dataTask_POST(_ path: URL, method: HTTPMethod, param: Dictionary<String, Any>, compilationBlock:@escaping (_ result: Result<Any, NSError> ) -> Void){
                
        var headers: HTTPHeaders = [
                   "Content-Type": "application/json",
                   "Accept": "application/json"
               ]

               if let authToken = UserDefaults.standard.string(forKey: kSessionAccessToken) {
                   headers["Authorization"] = "Bearer" + " " + authToken
               }
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(path, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(let JSON):
                compilationBlock(.success(JSON))
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    let customError = NSError(domain: "Timeout", code: 67, userInfo: [NSLocalizedDescriptionKey : Constants.timeOutMessage.localize()]);
                    compilationBlock(.failure(customError))
                }else{
                    let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : Constants.somethingWentWrong.localize()]);
                    compilationBlock(.failure(customError))
                }
                break
            }
        }
    }
    
   
    
    class func dataTask_DELETE(_ path: URL, method: HTTPMethod, param: Dictionary<String, Any>, compilationBlock:@escaping (_ result: Result<Any, NSError> ) -> Void){
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "Cache-Control": "no-cache",
            "Authorization": "bearer token"]
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.request(path, method: .delete, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(let JSON):
                compilationBlock(.success(JSON))
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    let customError = NSError(domain: "Timeout", code: 67, userInfo: [NSLocalizedDescriptionKey : Constants.timeOutMessage.localize()]);
                    compilationBlock(.failure(customError))
                }else{
                    let customError = NSError(domain: "Network", code: 67, userInfo: [NSLocalizedDescriptionKey : Constants.somethingWentWrong.localize()]);
                    compilationBlock(.failure(customError))
                }
                
                break
            }
        }
    }
    
    
}
