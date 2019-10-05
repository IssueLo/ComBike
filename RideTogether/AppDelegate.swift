//
//  AppDelegate.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/8/27.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import FirebaseCore
import Crashlytics
import Fabric
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let userIndicatorSB = StoryboardCategory.userIndicator.getStoryboard()
    
    lazy var userIndicatorVC = userIndicatorSB.instantiateViewController(
        identifier: UserIndicatorController.identifier
    )
    
    let tabBarSB = StoryboardCategory.tabBar.getStoryboard()

    lazy var tabBarVC = tabBarSB.instantiateViewController(
        identifier: TabBarViewController.identifier
    )
        
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        Fabric.with([Crashlytics.self])
        
        Fabric.sharedSDK().debug = true
        
        IQKeyboardManager.shared().isEnabled = true
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        // 正式 release 要取消
        UserDefaults.standard.removeObject(forKey: "UserLogined")
        
        if UserDefaults.standard.value(forKey: "UserLogined") == nil {
            
            self.window?.rootViewController = userIndicatorVC
            
        } else {
            
            self.window?.rootViewController = tabBarVC
        }
                
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}
