import UIKit
import CoreData

protocol EventServiceProtocol {
    func perform(_ action: EventService.EventAction, _ data: EventService.EventInputData)
    func getEvent(_ id: NSManagedObjectID) -> Event?
    func getEvents() -> [Event]
}

final class EventService: EventServiceProtocol {
    struct EventInputData {
        let name: String
        let data: Date
        let image: UIImage
    }
    
    enum EventAction {
        case add
        case update(Event)
    }
    
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }
    
    func perform(_ action: EventAction, _ data: EventInputData) {
        var event: Event
        switch action {
        case .add:
            event = Event(context: coreDataManager.context)
        case .update(let eventToUpdate):
            event = eventToUpdate
        }
        
        event.setValue(data.name, forKey: "name")
        let resizedImage = data.image.sameAspectRatio(newHeight: 250)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        event.setValue(imageData, forKey: "image")
        event.setValue(data.data, forKey: "date")
        
        coreDataManager.save()
    }
    
    func getEvent(_ id: NSManagedObjectID) -> Event? {
        return coreDataManager.get(id)
    }
    
    func getEvents() -> [Event] {
        return coreDataManager.getAll()
    }
}
