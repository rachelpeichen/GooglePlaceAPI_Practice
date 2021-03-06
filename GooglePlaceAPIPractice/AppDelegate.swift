//
//  AppDelegate.swift
//  GooglePlaceAPIPractice
//
//  Created by Pei Pei on 2021/7/30.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

// let googleApiKey = "ENTER_KEY_HERE"
let googleApiKey = "AIzaSyDFnUKfr_il6ACVyBNki_E0zCDeZgLERdc"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    GMSServices.provideAPIKey(googleApiKey)
    GMSPlacesClient.provideAPIKey(googleApiKey)
    
    FirebaseApp.configure()
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

