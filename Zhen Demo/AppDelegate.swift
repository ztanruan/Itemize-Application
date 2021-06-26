//
//  AppDelegate.swift
//  Zhen Demo
//
//  Created by Deepak Jain on 23/05/20.
//  Copyright © 2020 Deepak Jain. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isSocialMediaLogin = ""
    var int_TotalItem:Int = 0
    var dic_valueforAddCatInAdmin = [String: Any]()
    var dic_ValueforRegisterItem = [String: Any]()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        sleep(2)
        
        self.registerForPushNotifications()
        
        
        checkRedirect()
        self.setProgressHud()
        
        FirebaseApp.configure()
        
       // TWTRTwitter.sharedInstance().start(withConsumerKey: "OnbuuPR9Rl6fEZTbD3VwvWOvf", consumerSecret: "Ib9Zu1znzBVw0lUW4fAIJCUErvTGirFT00j9Xa4GSvqj2gCPVA")
        
        return true
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let app = UIApplication.shared
        
        //create new uiBackgroundTask
        var bgTask: UIBackgroundTaskIdentifier = app.beginBackgroundTask(expirationHandler: {
            app.endBackgroundTask(UIBackgroundTaskIdentifier.invalid)
        })
        
        //and create new timer with async call:
        DispatchQueue.global(qos: .default).async(execute: {
            //run function methodRunAfterBackground
            let t = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.methodRunAfterBackground), userInfo: nil, repeats: false)
            RunLoop.current.add(t, forMode: .default)
            RunLoop.current.run()
        })
    }
    
    @objc func methodRunAfterBackground() {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if self.isSocialMediaLogin == "Facebook" {
//            ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//        }
//        else if self.isSocialMediaLogin == "Twitter" {
//            return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
//        }
//        let handled = GIDSignIn.sharedInstance().handle(url)
//        return handled
//    }
    
    
    
    //MARK:- SETUP
    func setupLoader() {
        //Setups the progress hud settings
    }
    
    // MARK:- CUSTOM SETUP
    func setProgressHud(){
        //SVProgressHUD.setFont(UIFont.AppFontRegular(14))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    //MARK:- Set RootController
    func checkRedirect() {
        if let isIntroSlider = UserDefaults.appObjectForKey(AppMessage.intro_Slider) as? Bool {
            if isIntroSlider {
                if let isLogin = UserDefaults.appObjectForKey(AppMessage.login) as? Bool {
                    if isLogin {
                        self.app_Login_screen()
                        //self.app_setDashBoard()
                    }
                    else {
                        self.app_Login_screen()
                    }
                }
                else {
                    self.app_Login_screen()
                }
            }
        }
    }
    
    func app_setDashBoard() {
        //SET DASHBOARD VIEWCONTROLLER TO ROOT
        let dashboard = Story_Main.instantiateViewController(withIdentifier: "TabbarVC")
        let navi = UINavigationController.init(rootViewController: dashboard)
        navi.setNavigationBarHidden(true, animated: false)
        self.animatedAddtoRoot(toView: navi)
    }
    
    func app_Login_screen() {
        //SET LOGIN VIEWCONTROLLER TO ROOT
        let objLogin = Story_Main.instantiateViewController(withIdentifier: "LoginVC")
        let navi = UINavigationController.init(rootViewController: objLogin)
        navi.setNavigationBarHidden(true, animated: false)
        self.animatedAddtoRoot(toView: navi)
    }
    
    func app_PhoneVerification_Screen() {
        //SET LOGIN VIEWCONTROLLER TO ROOT
        let objLogin = Story_Main.instantiateViewController(withIdentifier: "EnterMobileVC")
        let navi = UINavigationController.init(rootViewController: objLogin)
        navi.setNavigationBarHidden(true, animated: false)
        self.animatedAddtoRoot(toView: navi)
    }


    func app_setLogin() {
        //SET LOGIN VIEWCONTROLLER TO ROOT
        let login = Story_Main.instantiateViewController(withIdentifier: "navMain")
        self.animatedAddtoRoot(toView: login)
    }
       
    func animatedAddtoRoot(toView:UIViewController) {
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = toView
        }, completion: { completed in
            // maybe do something here
            self.window?.makeKeyAndVisible()
        })
    }
    
    
}


//=============================Set Up For Push Notification==================================//
//MARK: - Notitfication Setup

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func setUpNotificationConfig(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            // 1. Check if permission granted
            guard granted else { return }
            // 2. Attempt registration for remote notifications on the main thread
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    func configNotifications() {
        let actin = UNNotificationAction.init(identifier: "id", title: "Show Notification", options: [.foreground, .destructive])
        let cat = UNNotificationCategory.init(identifier: "id.cat", actions: [actin], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([cat])
    }
    //******************************************************************************************//
    //******************************************************************************************//
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Device Token: \(token)")

        var device_token = deviceToken.hexString()
        if device_token.isEmpty {
            device_token = ""
        }
        
        //Messaging.messaging().apnsToken = deviceToken
        UserDefaults.standard.set(device_token, forKey: AppMessage.device_token)
        UserDefaults.standard.set(deviceToken, forKey: AppMessage.device_tokenData)
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    
    //MARK:-  Firebase Message Delegates
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//        var fcm_token = "IOS1234567890IOS"
//        if fcmToken != "" {
//            fcm_token = fcmToken
//        }
//        UserDefaults.standard.set(fcm_token, forKey: AppMessage.firebase_token)
//        UserDefaults.standard.synchronize()
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        var isActive = false
        if application.applicationState != .active {
            isActive = true
        }
        /*
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        */
        /*
        let firebaseAuth = Auth.auth()
        
        if (firebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
            return
        }
        */
        
        self.openNotificationViewController(userInfo, isActive, identifier: "")
        application.applicationIconBadgeNumber = 0
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        if let dictidata = notification.request.content.userInfo as NSDictionary? as! [String:Any]? {
            debugPrint(dictidata)
        UIApplication.shared.applicationIconBadgeNumber = 0
            completionHandler([.alert,.sound,.badge])
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.openNotificationViewController(response.notification.request.content.userInfo, true, identifier: response.notification.request.identifier)
    }
    
    func openNotificationViewController(_ dict: [AnyHashable: Any], _ is_Active: Bool, identifier: String) {
        var naviobj: UIViewController? = nil
        if naviobj != nil {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                    topController.dismiss(animated: true, completion: nil)
                }
                
                switch self.window?.rootViewController {
                case is UINavigationController:
                    (self.window?.rootViewController as? UINavigationController)?.pushViewController(naviobj!, animated: true)
                    
                case is UITabBarController:
                    (self.window?.rootViewController as? UITabBarController)?.selectedViewController?.navigationController?.pushViewController(naviobj!, animated: true)
                    
                default:
                    (self.window?.rootViewController)?.navigationController?.pushViewController(naviobj!, animated: true)
                }
            }
        }
    }
    
}

extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}













