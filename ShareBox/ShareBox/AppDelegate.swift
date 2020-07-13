//
//  AppDelegate.swift
//  ShareBox
//
//  Created by 廖逸澤 on 2020/5/15.
//  Copyright © 2020 廖逸澤. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
 

import FBSDKCoreKit
//@UIApplicationMain
//class AppDelegate:UIResponder, UIApplicationDelegate {
//    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
//        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
//        return true }
//
//    func application( _ app:UIApplication, open url:URL, options: [UIApplication.OpenURLOptionsKey :Any] = [:] ) -> Bool {
//
//        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
//
//    }
//
//}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, MessagingDelegate, UNUserNotificationCenterDelegate      {
      var window: UIWindow?
     let gcmMessageIDKey = "gcm.Message_id"
  
  var user : Any?
    
  
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
           
          
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
         ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
                return (GIDSignIn.sharedInstance()?.handle(url))!
            }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("離開背景")
    }
 
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("進入背景")
    }
 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        print(NSHomeDirectory())
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
          Messaging.messaging().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
       
//
//        DispatchQueue.global().async {
//
//            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (granted, error) in
//                DispatchQueue.main.async {
//                             application.registerForRemoteNotifications()
//
//                     }
//        }
//
//        }
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)


          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
         UNUserNotificationCenter.current().delegate = self

      
        return true
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey]{
            print("MessageID: \(messageID)")
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("註冊失敗")
        
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        InstanceID.instanceID().instanceID { (result, error) in
                 if let error = error {
                   print("Error fetching remote instance ID: \(error)")
                 } else if let result = result {
                   print("Remote instance ID token: \(result.token)")

                 }
               }
    }
    
   
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken\(fcmToken)")
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }
        }
        
       let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
     

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ShareBox")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

 
