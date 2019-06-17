//
//  AppDelegate.swift
//  LocalNotifications
//
//  Created by Bruno Omella Mainieri on 22/05/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    public var notificationsAllowed:Bool? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let repeatAction = UNNotificationAction(identifier: "repeat", title: "Repetir", options: UNNotificationActionOptions(rawValue: 0))
        let okAction = UNNotificationAction(identifier: "ok", title: "Ok", options: .foreground)
        let actionCategory = UNNotificationCategory(identifier: "acao", actions: [repeatAction,okAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        
        let customCategory = UNNotificationCategory(identifier: "custom", actions: [repeatAction,okAction], intentIdentifiers: [], options: UNNotificationCategoryOptions(rawValue: 0))
        notificationCenter.setNotificationCategories([actionCategory,customCategory])
        
        let options: UNAuthorizationOptions = [.alert,.sound,.badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "permissionDidChange"), object: self)
            self.notificationsAllowed = didAllow
            if !didAllow {
                print("Notifications not allowed by user")
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        notificationCenter.getNotificationSettings { (settings) in
            self.notificationsAllowed = settings.authorizationStatus == .authorized
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    

}

