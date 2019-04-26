//
//  AppDelegate.swift
//  Flashcard
//
//  Created by Shaun Jacobsen on 3/30/19.
//  Copyright © 2019 Shaun Jacobsen. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    do {
      var config = Realm.Configuration()
      config.deleteRealmIfMigrationNeeded = true
      let _ = try Realm(configuration: config)
    } catch {
      print("Realm error: \(error)")
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

