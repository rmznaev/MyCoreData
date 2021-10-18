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

    lazy var mainContext: NSManagedObjectContext = {
        var moc = self.persistencyContainer.viewContext
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        moc.automaticallyMergesChangesFromParent = true
        
        return moc
    }()
    
    public func getChildContext() -> NSManagedObjectContext {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = mainContext
        
        return moc
    }
    
    lazy var persistencyContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyCoreData")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveMainContext() {
        self.mainContext.perform {
            do {
                try self.mainContext.save()
            } catch let error as NSError {
                fatalError("Unresolved main context save error: \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveChildContext(_ childContext: NSManagedObjectContext) {
        do {
            try childContext.save()
            self.mainContext.perform {
                do {
                    try self.mainContext.save()
                } catch let error as NSError {
                    fatalError("unresolved child context save error: \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            fatalError("unresolved child context save error: \(error), \(error.userInfo)")
        }
    }
    
    func fetch<T: NSManagedObject>(entity: T.Type, completionHandler: @escaping (Result<[T], Error>) -> Void) {
        let entityName = String(describing: entity)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let result = try mainContext.fetch(fetchRequest)
            
            if let result = result as? [T] {
                completionHandler(.success(result))
            }
        } catch let error {
            completionHandler(.failure(error))
        }
    }
}
