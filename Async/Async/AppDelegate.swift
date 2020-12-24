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
        window.rootViewController = MainViewController() // Your initial view controller.
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

}

