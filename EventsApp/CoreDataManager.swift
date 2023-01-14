import CoreData
import UIKit

final class CoreDataManager {
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
    
    func saveEvent(name: String, data: Date, image: UIImage) {
        let event = Event(context: context)
        event.setValue(name, forKey: "name")
        let imageData = image.jpegData(compressionQuality: 1)
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
