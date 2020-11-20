//
//  AppDelegate.swift
//  Nexshop
//
//  Created by Catlina-Ravi on 17/09/20.
//  Copyright © 2020 Catlina-Khuss. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import SKActivityIndicatorView
import Loaf
import FBSDKCoreKit
import FBSDKLoginKit
import CoreLocation
import IQKeyboardManagerSwift
import CoreLocation
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import UserNotifications
import FirebaseDynamicLinks
import Firebase
import Stripe

//https://preview.page.link/cellulashopping.page.link/NzR8DRaYRK4MWz9r5
//https://preview.page.link/nexshop.page.link/jXx3PXW4H2KiLrAv5



let appDelegate = UIApplication.shared.delegate as! AppDelegate


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window:UIWindow?
    var DeviceToken = String()
    var DeviceId = String()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentlatitude =  Double()
    var currentlogitude =  Double()
    var currentLC = CLLocationCoordinate2D()
    var latitude = String()
    var logitude = String()
    var Primarylang = String()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        DeviceId = UIDevice.current.identifierForVendor!.uuidString
        
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        registerForRemoteNotification()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIStackView.self)
        IQKeyboardManager.shared.toolbarPreviousNextAllowedClasses.append(UIView.self)
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        
        
        let key = "pk_test_51HjeGwC4HfNYIRND6dauzSXwUsnLTtMbixTZiXeb8bmQB0xNBV1LsSjz6BWoBXAYKsUzdTol9zBbrtbniVHdgpGD00PLKyAi4b"
        Stripe.setDefaultPublishableKey(key)
        
        
        SKActivityIndicator.spinnerColor(CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD"))
        SKActivityIndicator.statusTextColor(CommonClass.sharedInstance.getColorIntoHex(Hex: "2C52AD"))
        let myFont = UIFont(name: "Metropolis-Bold", size: 18)
        SKActivityIndicator.statusLabelFont(myFont!)
        
        application.registerForRemoteNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        DeviceId = UIDevice.current.identifierForVendor!.uuidString
        
        let id1 = appDelegate.get_user_Data(Key: "id")
        
        print(id1)
        
        
        if id1.isEmpty == true
        {
            self.SetLoginRoot()
            
        }
        else
        {
            let mobile_verified = appDelegate.get_user_Data(Key: "mobile_verified")
            
            if mobile_verified == "1"
            {
                self.SetHomeRoot()
                
            }
            else
            {
                self.SetLoginRoot()
                
            }
            
            
        }
        
        DynamicLinks.performDiagnostics(completion: nil)
        
        
        return true
    }
    
    func SetHomeRoot()
    {
        let Push = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabVC") as! TabVC
        Push.Selected_index = 0
        
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            let nav:UINavigationController = UINavigationController(rootViewController: Push)
            nav.isNavigationBarHidden = true
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            
        }, completion: { completed in
            // maybe do something here
        })
        
    }
    
    func SetCartRoot()
    {
        let Push = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabVC") as! TabVC
        Push.Selected_index = 2
        
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            let nav:UINavigationController = UINavigationController(rootViewController: Push)
            nav.isNavigationBarHidden = true
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            
        }, completion: { completed in
            // maybe do something here
        })
        
    }
    
    
    
    func ErrorMessage(Message:String,ContorllerName:UIViewController)
    {
        Loaf(Message, state: .error, sender: ContorllerName).show()
        self.HideProgress()
        return
    }
    
    func SuccessMessage(Message:String,ContorllerName:UIViewController)
    {
        Loaf(Message, state: .success, sender: ContorllerName).show()
        self.HideProgress()
        return
    }
    
    func LoginAgainMessage(Message:String,ContorllerName:UIViewController)
    {
        Loaf(Message, state: .error, sender: ContorllerName).show()
        SetLoginRoot()
        
    }
    
    func SetLoginRoot()
    {
        let Push = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        UIView.transition(with: self.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            
            let nav:UINavigationController = UINavigationController(rootViewController: Push)
            nav.isNavigationBarHidden = true
            self.window?.rootViewController = nav
            self.window?.makeKeyAndVisible()
            
        }, completion: { completed in
            // maybe do something here
        })
        
    }
    
    func get_user_Data(Key:String) -> String {
        
        var value = String()
        if UserDefaults.standard.object(forKey: "User_data") != nil
        {
            let user_dic = UserDefaults.standard.dictionary(forKey: "User_data")! as NSDictionary
            
            if Key == "id"
            {
                value = "\(user_dic.value(forKey: Key) as! String)"
                
            }
            else if Key == "mobile_verified"
            {
                value = "\(user_dic.value(forKey: Key) as! String)"
            }
            else
            {
                
                value = user_dic.value(forKey: Key) as! String
                
            }
            
        }
        else
        {
            value = ""
        }
        return value
    }
    
    func settingPushNotification() {
        
        let app = UIApplication.shared
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            app.registerUserNotificationSettings(settings)
        }
        
        app.registerForRemoteNotifications()
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!)
        { (dynamiclink, error) in
            
            guard error == nil else{
                print("Error:\(String(describing: error))")
                return
            }
            guard let inCommingURL = dynamiclink?.url else { return }
            print("Incomming Web Page URL: \(inCommingURL)")
            self.HandleIncomingURL(dynamicURL: inCommingURL)
            
        }
        return handled
    }
    
    
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        if !token.isEmpty {
            
            let userDefaults = UserDefaults.standard
            //  userDefaults.set(token, forKey: Strings.DeviceToken.rawValue)
            
        }
        
        
        print("Device Token: \(token)")
    }
    
    
    func HandleIncomingURL(dynamicURL:URL)
    {
        let strURL = dynamicURL.absoluteString
        let urlComponent = URLComponents(url: dynamicURL, resolvingAgainstBaseURL: false)
        
        guard strURL.contains("post_details") == false else
        {
            if let query = urlComponent?.query {
                let ID = query.components(separatedBy: "=")[1]
                print(ID)
                let MessagesVC = mainStoryboard.instantiateViewController(withIdentifier: "PostFullScreenVC") as! PostFullScreenVC
                MessagesVC.Post_Detail = "\(ID)"
                UIApplication.topViewController()?.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.tabBarController?.tabBar.isHidden = true
                UIApplication.topViewController()?.navigationController?.pushViewController(MessagesVC, animated: true)
                
            }
            return
        }
        
        guard strURL.contains("product") == false else
        {
            if let query = urlComponent?.query {
                let ID = query.components(separatedBy: "=")[1]
                if let detailVc = mainStoryboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC {
                    detailVc.product_id = ID
                    detailVc.type = "shopping"
                    detailVc.isFromShare = "1"
                    UIApplication.topViewController()?.hidesBottomBarWhenPushed = true
                    UIApplication.topViewController()?.tabBarController?.tabBar.isHidden = true
                    UIApplication.topViewController()?.navigationController?.pushViewController(detailVc, animated: true)
                }
                
            }
            return
        }
        
        
        
        
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            return true
        }
        
        return false
    }
    
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            return application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
        }
        return false
    }
    
    
    
    
    
    func ShowProgess()
    {
        SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
        SKActivityIndicator.show("Loading...", userInteractionStatus: false)
        
    }
    
    func HideProgress()
    {
        SKActivityIndicator.dismiss()
    }
    
}


extension AppDelegate:CLLocationManagerDelegate
{
    
    //MARK:- LOCATION METHODS
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.locManager.startUpdatingLocation()
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        latitude = String(location.coordinate.latitude)
        logitude = String(location.coordinate.longitude)
        currentlatitude = Double(latitude)!
        currentlogitude = Double(logitude)!
        self.currentLC = CLLocationCoordinate2DMake(self.currentlatitude,self.currentlogitude)
        
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate,MessagingDelegate
{
    //MARK: - Register Remote Notification Methods // <= iOS 9.x
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    //MARK: - Remote Notification Methods // <= iOS 9.x
    
    
    
    // MARK: - UNUserNotificationCenter Delegate // >= iOS 10
    @objc(applicationReceivedRemoteMessage:) func application(received remoteMessage: MessagingRemoteMessage)
    {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        
        
        // Change this to your preferred presentation option
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        // Print full message.
        print(userInfo)
        
        let data_item = userInfo as NSDictionary
        print(data_item)
        
        
        let push_type = data_item.value(forKey: "push_type") as! String
        
        
        if push_type == "1"
        {
            
           
            let Push = mainStoryboard.instantiateViewController(withIdentifier: "ChatDetailVC") as! ChatDetailVC
            Push.ToUserID = Int(data_item.value(forKey: "from_user_id") as! String)!
            Push.OtherUserName = data_item.value(forKey: "push_from") as! String
            // Push.RecieverImageUrl = data.created_user_data!.avatar!
            Push.Product_id = "\(data_item.value(forKey: "object_id") as! String)"
            Push.isFrom = true
            Push.RecieverImageUrl = data_item.value(forKey: "sender_avatar") as! String
            let nav:UINavigationController = UINavigationController(rootViewController: Push)
            nav.isNavigationBarHidden = true
            self.window?.rootViewController = nav
        }
        else if push_type == "2"
        {
            let Push = mainStoryboard.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
                   Push.isOrderid = "\(data_item.value(forKey: "object_id") as! String)"
            Push.isFrom = true
                   let nav:UINavigationController = UINavigationController(rootViewController: Push)
                   nav.isNavigationBarHidden = true
                   self.window?.rootViewController = nav
        }
        
        else if push_type == "5"
               {
                   let Push = mainStoryboard.instantiateViewController(withIdentifier: "PostFullScreenVC") as! PostFullScreenVC
                   let nav = UIApplication.topViewController()
                   nav?.tabBarController?.tabBar.isHidden = true
                   nav?.hidesBottomBarWhenPushed = true
                         
                   Push.postID = Int(data_item.value(forKey: "object_id") as! String)!
                   if nav?.navigationController == nil {
                       Utility.delay(0.5) {
                                   nav?.navigationController?.pushViewController(Push, animated: true)
                       }
                       } else {
                                   nav?.navigationController?.pushViewController(Push, animated: true)
                                   }
                     
                                 
               }
        
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        self.DeviceToken = fcmToken
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        
        // Print full message.
        
        let data_item = userInfo as NSDictionary
        
        
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        
        
        // Print full message.
        print(userInfo)
        
        let data_item = userInfo as NSDictionary
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
}

