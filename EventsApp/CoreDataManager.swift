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
    
    func getEvent(_ id: NSManagedObjectID) -> Event? {
        do {
            return try try context.existingObject(with: id) as! Event
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func saveEvent(name: String, data: Date, image: UIImage) {
        let event = Event(context: context)
        event.setValue(name, forKey: "name")
        
        let resizedImage = image.sameAspectRatio(newHeight: 250)
        
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        event.setValue(imageData, forKey: "image")
        event.setValue(data, forKey: "date")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func fetchEvents() -> [Event] {
        do {
            let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
            let events = try context.fetch(fetchRequest)
            return events
        } catch {
            print(error)
            return []
        }
    }
}
