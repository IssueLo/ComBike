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
    
    let userIndicaterSB = UIStoryboard(name: "UserIndicaterStoryboard", bundle: nil)
    
    lazy var userIndicaterVC = userIndicaterSB.instantiateViewController(identifier: "UserIndicaterController")
    
    let tabBarSB = UIStoryboard(name: "TabBarStoryboard", bundle: nil)
    
    lazy var tabBarVC = tabBarSB.instantiateViewController(identifier: "TabBarViewController")
        
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
            
            self.window?.rootViewController = userIndicaterVC
            
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
