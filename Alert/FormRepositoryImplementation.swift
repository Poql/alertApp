//
//  FormRepositoryImplementation.swift
//  Alert
//
//  Created by Gaétan Zanella on 18/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FormRepositoryImplementation {
    fileprivate lazy var databaseReference = FIRDatabase.database().reference()
    fileprivate let formMapper = FormMapper()
    fileprivate var formReference: FIRDatabaseReference {
        return databaseReference.child("forms")
    }
}

// MARK: - FormRepository

extension FormRepositoryImplementation: FormRepository {
    func fetchForms(completionBlock block: @escaping ([Form]) -> Void) {
        formReference.observeSingleEvent(of: .value, with: { snapshot in
            let children = snapshot.children.flatMap { $0 as? FIRDataSnapshot }
            let forms = children.flatMap { self.formMapper.form(from: $0) }
            block(forms)
        })
    }
}
