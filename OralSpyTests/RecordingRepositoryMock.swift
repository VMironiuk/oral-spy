import Combine
import Foundation

@testable import OralSpy

final class RecordingRepositoryMock: RecordingRepositoryType {
  private let itemsSubject = CurrentValueSubject<[RecordingItem], Never>([])
  var items: AnyPublisher<[RecordingItem], Never> {
    itemsSubject.eraseToAnyPublisher()
  }

  var addedItems: [RecordingItem] = []
  var removedIds: [UUID] = []

  func add(_ item: RecordingItem) async {
    addedItems.append(item)
    var currentItems = itemsSubject.value
    currentItems.append(item)
    itemsSubject.send(currentItems)
  }

  func remove(id: UUID) async throws {
    removedIds.append(id)
    var currentItems = itemsSubject.value
    currentItems.removeAll { $0.id == id }
    itemsSubject.send(currentItems)
  }

  func getAll() async -> [RecordingItem] {
    return itemsSubject.value
  }
}
