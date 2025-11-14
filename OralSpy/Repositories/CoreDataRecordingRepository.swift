import Combine
import CoreData
import Foundation

final class CoreDataRecordingRepository: NSObject, RecordingRepositoryType {
  private let coreDataStack: CoreDataStack
  private let itemsSubject = CurrentValueSubject<[RecordingItem], Never>([])
  private var fetchedResultsController: NSFetchedResultsController<RecordingItemEntity>?

  var items: AnyPublisher<[RecordingItem], Never> {
    itemsSubject.eraseToAnyPublisher()
  }

  init(coreDataStack: CoreDataStack = .shared) {
    self.coreDataStack = coreDataStack
    super.init()
    setupFetchedResultsController()
    fetchItems()
  }

  private func setupFetchedResultsController() {
    let fetchRequest: NSFetchRequest<RecordingItemEntity> = RecordingItemEntity.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

    fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.viewContext,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    fetchedResultsController?.delegate = self

    do {
      try fetchedResultsController?.performFetch()
    } catch {
      print("Failed to fetch recordings: \(error)")
    }
  }

  private func fetchItems() {
    guard let entities = fetchedResultsController?.fetchedObjects else {
      itemsSubject.send([])
      return
    }

    let items = entities.map { entity in
      RecordingItem(
        id: entity.id ?? UUID(),
        timestamp: entity.timestamp ?? "",
        duration: entity.duration,
        fileSize: Int(entity.fileSize),
        fileURL: entity.fileURL ?? ""
      )
    }
    itemsSubject.send(items)
  }

  func add(_ item: RecordingItem) async {
    let context = coreDataStack.newBackgroundContext()
    await context.perform {
      let entity = RecordingItemEntity(context: context)
      entity.id = item.id
      entity.timestamp = item.timestamp
      entity.duration = item.duration
      entity.fileSize = Int64(item.fileSize)
      entity.fileURL = item.fileURL

      do {
        try context.save()
      } catch {
        print("Failed to save recording: \(error)")
      }
    }
  }

  func remove(id: UUID) async throws {
    let context = coreDataStack.newBackgroundContext()
    try await context.perform {
      let fetchRequest: NSFetchRequest<RecordingItemEntity> = RecordingItemEntity.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

      guard let entity = try context.fetch(fetchRequest).first else {
        return
      }

      let fileURL = URL(fileURLWithPath: entity.fileURL ?? "")
      if FileManager.default.fileExists(atPath: fileURL.path) {
        try FileManager.default.removeItem(at: fileURL)
      }

      context.delete(entity)
      try context.save()
    }
  }

  func getAll() async -> [RecordingItem] {
    return itemsSubject.value
  }
}

extension CoreDataRecordingRepository: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    fetchItems()
  }
}
