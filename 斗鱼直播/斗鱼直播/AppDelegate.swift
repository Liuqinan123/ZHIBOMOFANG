//
//  AppDelegate.swift
//  斗鱼直播
//
//  Created by Apple on 2016/10/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.orange
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = UIColor.orange
        return true
    }

   
}

