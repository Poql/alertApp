//
//  AuthenticationWorker.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol AuthenticationWorker {
    func preparesGoogleSignIn()
}

protocol AuthenticationViewContract: class {
    func authenticationDidSucceed()
    func authenticationDidFail(with error: ApplicationError)
}
