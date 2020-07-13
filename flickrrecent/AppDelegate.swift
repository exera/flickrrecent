//
//  AppDelegate.swift
//  flickrrecent
//
//  Created by Ahmet Sancar on 12.07.2020.
//  Copyright © 2020 Ahmet Sancar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow()
    window?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil)
        .instantiateInitialViewController()
    window?.backgroundColor = .white
    window?.frame = UIScreen.main.bounds
    window?.makeKeyAndVisible()
    
    return true
  }

}

