//
//  AppDelegate.swift
//  MovieList
//
//  Created by coreylin on 8/18/18.
//  Copyright © 2018 coreylin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let homeViewController = HomeViewController(viewModel: HomeViewModel(movieService: DefaultMovieService()))
    let navigationController = UINavigationController(rootViewController: homeViewController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    return true
  }

}
