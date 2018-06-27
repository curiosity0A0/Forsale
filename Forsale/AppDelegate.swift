//
//  AppDelegate.swift
//  Forsale
//
//  Created by 洪森達 on 2018/6/11.
//  Copyright © 2018年 sen. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    let APP_IDForBackendless = "FEB64DB3-B2AB-3B64-FF03-4F56892E9B00"
    let APP_KEYForBackendless = "4D4E08CA-5F63-7D58-FF68-FD422736BA00"
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
       FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        backendless?.initApp(APP_IDForBackendless, apiKey: APP_KEYForBackendless)
      
        OneSignal.initWithLaunchOptions(launchOptions, appId: oneSignalAPPID,handleNotificationReceived: nil, handleNotificationAction: nil, settings: nil)


        //the firebase will send the notificationCode when user log in the app
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                if UserDefaults.standard.object(forKey: KcurrentUser) != nil {
                    DispatchQueue.main.async {
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId":Fuser.currentId()])
                    }
                }
            }
            
            
            
        }
        
        
        func onUserDidLogin(userId:String){

                startOneSignal()
        }
        
        //we gonna receive the code from firebase
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, queue: nil) { (note) in
            
            let userId = note.userInfo!["userId"] as! String
            
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.synchronize()
            onUserDidLogin(userId: userId)
        }
        
             //one signal
        
        func startOneSignal(){
            
            let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
            let userid = status.subscriptionStatus.userId
            let pushToken = status.subscriptionStatus.pushToken
            
            if pushToken != nil {
                if let playerID = userid {
                    
                    UserDefaults.standard.set(playerID, forKey: KoneSignalID)
                }else{
                    
                    UserDefaults.standard.removeObject(forKey: KoneSignalID)
                }
            }
            
            //SAVE TO USER OBJECT
            updateOneSignalId()
            
        }
        
        
        
        
        
        
        //phone register
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge,.alert,.sound]) { (grented, error) in
            }
             application.registerForRemoteNotifications()
        }
        
 
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Auth.auth().setAPNSToken(deviceToken, type: .prod)
        // .sandbox
        // . production
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo){
            completionHandler(.noData)
            return
            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Failed to register for user notifications")
    }
    
    
    

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let fBHandle: Bool = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication ] as! String, annotation: options[.annotation])
        
        return fBHandle
        
    }
    


}

