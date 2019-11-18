//
//  AppDelegate.swift
//  HelloWorld
//
//  Created by Angelo De Laurentis on 10/3/19.
//  Copyright © 2019 Angelo De Laurentis. All rights reserved.
//

import UIKit
import AWSCore
import AWSMobileClient
import AWSDynamoDB

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Create AWSMobileClient to connect with AWS
        return AWSMobileClient.sharedInstance().interceptApplication(
            application,
            didFinishLaunchingWithOptions: launchOptions)

    }
    func postToDB(){
        let deviceid:String = (UIDevice.current.identifierForVendor?.uuidString)!
        let message:Set = ["mess"]
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        let itemToCreate:TestGardenBuddyV1 = TestGardenBuddyV1()
        itemToCreate._userId = deviceid
        itemToCreate._message = message
        
        objectMapper.save(itemToCreate, completionHandler:{(error : Error?) -> Void in
            if let error = error{
                print("Amazon DynamoDB save error: \(error)")
                return
            }
            print("User information updated")
        })
    }

//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        return true
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

