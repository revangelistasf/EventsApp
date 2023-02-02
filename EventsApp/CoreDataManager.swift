import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private static var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "EventsApp")
        persistentContainer.loadPersistentStores { _, error in
            print(error?.localizedDescription ?? "An unexpected error ocurred")
        }
        return persistentContainer
    }()
    
    var context: NSManagedObjectContext {
        Self.persistentContainer.viewContext
    }
    
    func get<T: NSManagedObject>(_ id: NSManagedObjectID) -> T? {
        do {
            return try context.existingObject(with: id) as? T
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func getAll<T: NSManagedObject>() -> [T] {
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: "\(T.self)")
            return try context.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
