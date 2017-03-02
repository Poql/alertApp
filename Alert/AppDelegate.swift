//
//  AppDelegate.swift
//  Alert
//
//  Created by Gaétan Zanella on 22/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    let workerFactory: WorkerFactory = WorkerFactoryImplementation()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        configureFirebase()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApp = options[.sourceApplication] as? String
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApp, annotation: [:])
    }

    func applicationWillTerminate(_ application: UIApplication) {
        FIRDatabase.database().purgeOutstandingWrites()
    }

    // MARK: - Private

    private func configureFirebase() {
        FIRApp.configure()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
    }
}
