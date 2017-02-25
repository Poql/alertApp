//
//  DictionaryCoding + UserDefaults.swift
//  Alert
//
//  Created by Gaétan Zanella on 19/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation


extension UserDefaults {
    func save<T: DictionaryCoding>(_ value: T?, forKey defaultName: String) {
        set(value?.dictionaryRepresentation(), forKey: defaultName)
    }

    func value<T: DictionaryCoding>(forKey defaultName: String) -> T? {
        guard let dictionary = dictionary(forKey: defaultName) else { return nil }
        return T(dict: dictionary)
    }
}
