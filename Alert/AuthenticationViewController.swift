//
//  AuthenticationViewController.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//


import UIKit
import FirebaseAuth
import GoogleSignIn

class AuthenticationViewController: BaseViewController {

    fileprivate let signInButton = GIDSignInButton()

    private lazy var worker: AuthenticationWorker = {
        return self.workerFactory.newAuthenticationWorker(with: self)
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        worker.preparesGoogleSignIn()
    }

    // MARK: - Private

    private func setupButton() {
        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - AuthenticationViewContract

extension AuthenticationViewController: AuthenticationViewContract {
    func authenticationDidSucceed() {
        signInButton.isHidden = true
    }

    func authenticationDidFail(with error: ApplicationError) {
        showAlertView(title: error.title, message: error.message)
    }
}

// MARK: - GIDSignInUIDelegate

extension AuthenticationViewController: GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
}

