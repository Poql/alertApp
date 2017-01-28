//
//  AppDelegate.swift
//  Alert
//
//  Created by Gaétan Zanella on 22/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    let workerFactory: WorkerFactory = WorkerFactoryImplementation()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        FIRApp.configure()
        return true
    }
}
