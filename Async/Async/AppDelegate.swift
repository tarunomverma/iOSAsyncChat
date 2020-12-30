//
//  AppDelegate.swift
//  Async
//
//  Created by Tarun Verma on 24/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
        return true
    }

}

