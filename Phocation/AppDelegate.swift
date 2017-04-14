//
//  AppDelegate.swift
//  Phocation
//
//  Created by David Durkin on 2/12/17.
//  Copyright © 2017 David Durkin. All rights reserved.
//

import UIKit
import Parse
import Bolts

let currentUser = UserInfo.sharedUserInfo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Set persistent variables
        
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "User") == nil {
            let defaultUser = ["User" : "Anon"]
            defaults.register(defaults: defaultUser)
        }

        if defaults.string(forKey: "Pass") == nil {
            let defaultPass = ["Pass" : "Test"]
            defaults.register(defaults: defaultPass)
        }
        
        currentUser.userName = defaults.string(forKey: "User")
        currentUser.password = defaults.string(forKey: "Pass")
        
        // Initialize Parse.
        let configuration = ParseClientConfiguration {
            $0.applicationId = "cQYSuT7IiZi6M028LB6JvS18cZY530G43ZWwPytb"
            $0.clientKey = "vueavoBmA7q4Ru0Qz387aLD9gMGwRH2o5j2fqKbf"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        Post.registerSubclass()
        
        PFUser.logInWithUsername(inBackground: currentUser.userName!, password: currentUser.password!)
        
        if let currUser = PFUser.current(){
            print("\(currUser.username!) logged in successfully")
        } else {
            print("No logged in user :(")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

