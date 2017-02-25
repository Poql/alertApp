//
//  User.swift
//  Alert
//
//  Created by Gaétan Zanella on 12/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let email: String
    let name: String
    var formId: String?
}

extension User: DictionaryCoding {
    func dictionaryRepresentation() -> [String : Any] {
        var dict = [
            "id": id,
            "email": email,
            "name": name
        ]
        if let id = formId {
            dict["formId"] = id
        }
        return dict
    }

    init(dict: [String : Any]) {
        self.id = dict["id"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.formId = dict["formId"] as? String
    }
}
