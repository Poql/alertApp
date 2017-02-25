//
//  DictionaryCoding.swift
//  Alert
//
//  Created by Gaétan Zanella on 19/02/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol DictionaryCoding {
    init(dict: [String : Any])
    func dictionaryRepresentation() -> [String : Any]
}
