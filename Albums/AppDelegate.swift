//
//  AppDelegate.swift
//  Albums
//
//  Created by Alex Cuello on 25/12/2020.
//

import UIKit
import CoreData

// swiftlint:disable line_length
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let coordinator = AlbumsCoordinator(
            presenter: navigationController,
            albumsFactory: AlbumsFactory()
        )
        coordinator.start()
        return true
    }
}
