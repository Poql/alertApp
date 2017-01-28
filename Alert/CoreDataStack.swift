//
//  CoreDataStack.swift
//  Alert
//
//  Created by Gaétan Zanella on 23/01/2017.
//  Copyright © 2017 Gaétan Zanella. All rights reserved.
//

import CoreData

class CoreDataStack {

    static let shared = {
        return CoreDataStack()
    }()

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private let persistentContainer = NSPersistentContainer(name: "Model")

    private init() {
        persistentContainer.loadPersistentStores { _, error in
            // TODO: (gz) 23/01/17 We should do something better
            print("CoreData error : \(error)")
        }
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
