//
//  AppDelegate.swift
//  TripPlanner
//
//  Created by Hamster on 1/27/20.
//  Copyright © 2020 Hamster. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    public var currentUser = User()
    
    func loadProfile() {
        // Load current user profile to currentUser variable
        //      for the all VCs to access
        //
        // This function should be called each time when user
        //      profile is updated
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        db.collection("users").whereField("userID", isEqualTo: currentUser?.uid)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.currentUser.documentID = querySnapshot!.documents[0].documentID
                let resultData = querySnapshot!.documents[0].data()
                self.currentUser.firstname = resultData["first"] as! String
                self.currentUser.lastname = resultData["last"] as! String
                self.currentUser.username = resultData["username"] as! String
                self.currentUser.userID = resultData["userID"] as! String
                self.currentUser.contactList = resultData["contactList"] as! [String]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLoaded"), object: nil)

            }
        }
    }

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if (Auth.auth().currentUser != nil){
            loadProfile()
        }
        
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
//        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: UIControl.State.highlighted)
        
        return true
    }

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

