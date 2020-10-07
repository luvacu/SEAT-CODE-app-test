//
//  AppDelegate.swift
//  SEATCode
//
//  Created by Luis Valdés on 07/10/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let container = DependencyContainer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppFlowController(container: container)
        window?.makeKeyAndVisible()
        return true
    }
}
