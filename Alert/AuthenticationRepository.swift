//
//  AuthenticationRepository.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation


protocol AuthenticationRepository {
    var currentUser: User? { get }
    func signIn(with tokenId: String, and accessToken: String, completion: @escaping (Result<User, ServerError>) -> Void)
}
