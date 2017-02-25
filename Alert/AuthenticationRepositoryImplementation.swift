//
//  AuthenticationRepositoryImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

private struct Constant {
    static let currentUserUserDefaultKey = "CurrentUserUserDefaultKey"
}

class AuthenticationRepositoryImplementation {
    private var authenticationHandle: FIRAuthStateDidChangeListenerHandle?
    private var userInfoAddedHandle: UInt?
    private var userInfoChangedHandle: UInt?
    private var isObservingUserInfoChange: Bool {
        return userInfoChangedHandle != nil && userInfoAddedHandle != nil
    }

    fileprivate lazy var databaseReference = FIRDatabase.database().reference()
    fileprivate var usersReference: FIRDatabaseReference {
        return databaseReference.child("users")
    }

    fileprivate let userMapper = UserMapper()
    private var currentAuth: FIRAuth? { return FIRAuth.auth() }
    private var userDefaults: UserDefaults { return UserDefaults.standard }
    fileprivate var persistentedUser: User? { return userDefaults.value(forKey: Constant.currentUserUserDefaultKey) }

    // MARK: - Life Cycle

    init() {
        observeAuthenticationStateChange()
    }

    deinit {
        removeUserInfoChangeObserver()
        removeAuthenticationStateChangeObserver()
    }

    // MARK: - Private

    private func observeAuthenticationStateChange() {
        authenticationHandle = currentAuth?.addStateDidChangeListener() { (auth, user) in
            let previousUserId = self.currentUser?.id
            self.cacheCurrentUser(user.flatMap { self.userMapper.mapUser(from: $0) })
            self.observeUserInfoChange(currentUserId: self.currentUser?.id, previousUserId: previousUserId)
        }
    }

    private func observeUserInfoChange(currentUserId: String?, previousUserId: String?) {
        if let currentUserId = currentUserId,
            let previousUserId = previousUserId, previousUserId != currentUserId  {
            removeUserInfoChangeObserver()
        }
        if currentUserId == nil {
            removeUserInfoChangeObserver()
        }
        observeUserInfoChange()
    }

    private func observeUserInfoChange() {
        guard let id = persistentedUser?.id, !isObservingUserInfoChange else { return }
        userInfoAddedHandle = usersReference.child(id).observe(.value, with: { snapshot in
            self.cacheUserChange(snapshot: snapshot)
        })
    }

    private func removeUserInfoChangeObserver() {
        guard let userInfoChangedHandle = userInfoChangedHandle, let userInfoAddedHandle = userInfoAddedHandle else { return }
        usersReference.removeObserver(withHandle: userInfoChangedHandle)
        usersReference.removeObserver(withHandle: userInfoAddedHandle)
        self.userInfoChangedHandle = nil
        self.userInfoAddedHandle = nil
    }

    private func removeAuthenticationStateChangeObserver() {
        guard let handle = authenticationHandle else { return }
        currentAuth?.removeStateDidChangeListener(handle)
        authenticationHandle = nil
    }

    private func cacheCurrentUser(_ user: User?) {
        userDefaults.save(user, forKey: Constant.currentUserUserDefaultKey)
    }

    private func cacheUserChange(snapshot: Snapshot) {
        var user = self.persistentedUser
        let id = self.userMapper.userFormId(from: snapshot)
        user?.formId = id
        cacheCurrentUser(user)
    }
}

// MARK: - AuthenticationRepository

extension AuthenticationRepositoryImplementation: AuthenticationRepository {
    var currentUser: User? {
        return persistentedUser
    }

    func signIn(with tokenId: String, and accessToken: String, completion: @escaping (Result<User, ServerError>) -> Void) {
        let credential = FIRGoogleAuthProvider.credential(withIDToken: tokenId, accessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credential) { user, error in
            if let user = user, let mappedUser = self.userMapper.mapUser(from: user) {
                completion(.value(mappedUser))
                return
            }
            completion(.error(.generic))
        }
    }

    func setUserForm(formId id: String) {
        guard let userId = currentUser?.id else { return }
        let snapshot = userMapper.userSnapshotForUserFormIdChange(formId: id, userId: userId)
        usersReference.child(userId).setValue(snapshot.dictionary)
    }
}
