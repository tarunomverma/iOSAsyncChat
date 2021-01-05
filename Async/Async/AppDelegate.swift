//
//  AppDelegate.swift
//  Async
//
//  Created by Tarun Verma on 24/12/2020.
//

import UIKit
import Amplify
import AmplifyPlugins
import AWSPinpoint
import AWSPluginsCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var awsPinpoint :AWSPinpoint?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AmplifyManager().configure()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let signInVC = SignInViewController()
        signInVC.tabBarItem = UITabBarItem(title: "SignIn", image: UIImage(named: "signInIcon"), tag: 0)
        
        let registerVC = RegisterViewController()
        registerVC.tabBarItem = UITabBarItem(title: "Register", image: UIImage(named: "registerIcon"), tag: 1)
        
        let chatVC = StartChatViewController()
        chatVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "chatIcon"), tag: 2)
        let chatNav = UINavigationController(rootViewController: chatVC)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [signInVC, registerVC, chatNav]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
        getEscapeHatch()
        registerForPushNotifications()
        return true
    }

    func registerForPushNotifications() {
         UNUserNotificationCenter.current().delegate = self
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
             (granted, error) in
             print("Permission granted: \(granted)")
            
             guard granted else { return }
             DispatchQueue.main.async {
                 UIApplication.shared.registerForRemoteNotifications()
             }
         }
     }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         awsPinpoint?.notificationManager.interceptDidRegisterForRemoteNotifications(
             withDeviceToken: deviceToken)
        
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print("Received token data! \(tokenString)")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn't register: \(error)")
      }
    
    func getEscapeHatch() {
        do {
            let plugin = try Amplify.Analytics.getPlugin(for: "awsPinpointAnalyticsPlugin") as! AWSPinpointAnalyticsPlugin
            awsPinpoint = plugin.getEscapeHatch()
        } catch {
            print("Get escape hatch failed with error - \(error)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

