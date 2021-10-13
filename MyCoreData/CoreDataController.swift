//
//  CoreDataController.swift
//  MyCoreData
//
//  Created by Ramazan Abdullayev on 12.10.21.
//

import CoreData

class CoreDataController: NSObject {
    
    private override init() {}
    static let sharedInstance = CoreDataController()

    lazy var context: NSManagedObjectContext = {
        var moc = self.persistencyContainer.viewContext
        moc.automaticallyMergesChangesFromParent = true
        
        return moc
    }()
    
    lazy var persistencyContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyCoreData")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        self.context.perform {
            do {
                try self.context.save()
            } catch let error as NSError {
                fatalError("Unresolved main context save error: \(error), \(error.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(entity: T.Type, completionHandler: @escaping (Result<[T], Error>) -> Void) {
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let result = result as? [T] {
                completionHandler(.success(result))
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
}
