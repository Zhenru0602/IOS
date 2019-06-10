//
//  AppDelegate.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.red
        UITabBar.appearance().tintColor = UIColor.red
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        GIDSignIn.sharedInstance()?.clientID = "157908405394-bhhk76sdlv4s9k6dl4tb9pjdvamg1vg2.apps.googleusercontent.com"
        
        return true
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

