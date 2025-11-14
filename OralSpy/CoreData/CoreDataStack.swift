import CoreData
import Foundation

final class CoreDataStack {
  static let shared = CoreDataStack()

  let persistentContainer: NSPersistentContainer

  private init() {
    persistentContainer = NSPersistentContainer(name: "OralSpy")
    persistentContainer.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Failed to load Core Data stack: \(error)")
      }
    }
    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
  }

  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  func newBackgroundContext() -> NSManagedObjectContext {
    persistentContainer.newBackgroundContext()
  }

  func save(context: NSManagedObjectContext) throws {
    if context.hasChanges {
      try context.save()
    }
  }
}
