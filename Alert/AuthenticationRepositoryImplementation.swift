//
//  AuthenticationRepositoryImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationRepositoryImplementation {}

// MARK: - AuthenticationRepository

extension AuthenticationRepositoryImplementation: AuthenticationRepository {
    var currentUser: User? {
        return FIRAuth.auth()?.currentUser.flatMap { UserMapper.mapUser(from: $0) }
    }

    func signIn(with tokenId: String, and accessToken: String, completion: @escaping (Result<User, ServerError>) -> Void) {
        let credential = FIRGoogleAuthProvider.credential(withIDToken: tokenId, accessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credential) { user, error in
            if let user = user, let mappedUser = UserMapper.mapUser(from: user) {
                completion(.value(mappedUser))
                return
            }
            completion(.error(.generic))
        }
    }
}
