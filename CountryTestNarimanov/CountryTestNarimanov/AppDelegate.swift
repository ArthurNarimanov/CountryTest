//
//  AppDelegate.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 02/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let frame = UIScreen.main.bounds
		let view = ViewBuilder.createCountriesViewController()
		let navCon = UINavigationController(rootViewController: view)
		
		window = UIWindow(frame: frame)
		window?.rootViewController = navCon
		window?.makeKeyAndVisible()

		return true
	}
}

