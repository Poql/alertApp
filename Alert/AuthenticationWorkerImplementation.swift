//
//  AuthenticationWorkerImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import GoogleSignIn


class AuthenticationWorkerImplementation: NSObject {

    fileprivate let repository: AuthenticationRepository

    weak var viewContract: AuthenticationViewContract?

    init(repository: AuthenticationRepository) {
        self.repository = repository
    }

    // MARK: - Private

    fileprivate func signIn(with tokenId: String, and accessToken: String) {
        repository.signIn(with: tokenId, and: accessToken) { result in
            switch result {
            case let .error(error):
                let applicationError = ErrorMapper.applicationError(from: error)
                self.viewContract?.authenticationDidFail(with: applicationError)
            case .value:
                self.viewContract?.authenticationDidSucceed()
            }
        }
    }
}

// MARK: - AuthenticationWorker

extension AuthenticationWorkerImplementation: AuthenticationWorker {
    func preparesGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
    }
}

// MARK: - GIDSignInDelegate

extension AuthenticationWorkerImplementation: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
        if let user = user {
            let idToken = user.authentication?.idToken ?? ""
            let tokenAccess = user.authentication?.accessToken ?? ""
            self.signIn(with: idToken, and: tokenAccess)
            return
        }
        viewContract?.authenticationDidFail(with: .generic)
    }
}
