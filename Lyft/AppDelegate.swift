//
//  AppDelegate.swift
//  Lyft
//
//  Created by Diwakar Garg on 05/09/22.
//  Copyright © 2022 Diwakar Garg. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         if let languageStr = UserDefaults.standard.value(forKey: klanguage) as? String, let language = Language(rawValue: languageStr) {
             setLocalization(language: language)
         }else {
             UserDefaults.standard.set("en", forKey: klanguage)
             setLocalization(language: .english)
         }
        
        navigatetoParticularView()
        return true
    }
    
    func navigatetoParticularView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            
            if (UserDefaults.standard.string(forKey: kPassword)  != nil && UserDefaults.standard.string(forKey: kEmailAndMobile) != nil) {
            
                if  let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: mainHomeForMenuVCSID) as? MainViewController {
                navigationController = UINavigationController(rootViewController: vc)
                navigationController?.setNavigationBarHidden(true, animated: false)
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
                }
            }else{

                    if let vc = MainStoryboard.instantiateViewController(withIdentifier: loginVCSID) as? LoginVC {
                        navigationController = UINavigationController(rootViewController: vc)
                        navigationController?.setNavigationBarHidden(true, animated: true)
                        window.rootViewController = navigationController
                        window.makeKeyAndVisible()
                    }
            }
        }
    }
}

