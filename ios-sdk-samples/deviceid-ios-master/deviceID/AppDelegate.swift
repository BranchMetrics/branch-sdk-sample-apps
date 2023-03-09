//
//  AppDelegate.swift
//  deviceID
//
//  Created by Bharath Natarajan on 22/07/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let branch = Branch.getInstance()
        
        // Enable this to track Apple Search Ad attribution
        branch.delayInitToCheckForSearchAds()
        
        // Increase the amount of time the SDK waits for Apple Search Ads to respond
        branch.useLongerWaitForAppleSearchAds()
        
        // Override point for customization after application launch.
        branch.initSession(launchOptions: launchOptions) { (params, error) in
            guard let data = params as? [String: AnyObject] else { return }
            guard let deepLinkMessage = data["deep_link_message"] as? String else { return }
            let alert = UIAlertController(title: "Deep Link Message", message: deepLinkMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        Branch.getInstance().continue(userActivity)
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // handler for Push Notifications
        Branch.getInstance().handlePushNotification(userInfo)
    }

}

