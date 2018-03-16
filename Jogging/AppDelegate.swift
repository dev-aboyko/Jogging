//
//  AppDelegate.swift
//  Jogging
//
//  Created by Alexey Boyko on 05/03/2018.
//  Copyright © 2018 Alexey Boyko. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        chooseMainViewController()
        return true
    }
    
    func chooseMainViewController() {
        guard self.window == nil else {
            Log.error("Main Interface setting is not empty")
            return
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let sbName = UserData.token == nil ? "Login" : "Jogging"
        let storyboard = UIStoryboard(name: sbName, bundle: nil)
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
    }

}

