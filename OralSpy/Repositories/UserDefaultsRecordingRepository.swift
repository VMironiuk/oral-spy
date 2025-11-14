import Combine
import Foundation

actor UserDefaultsRecordingRepository: RecordingRepositoryType {
  private static let userDefaultsKey = "recordingItems"

  private let itemsSubject = CurrentValueSubject<[RecordingItem], Never>([])
  nonisolated var items: AnyPublisher<[RecordingItem], Never> {
    itemsSubject.eraseToAnyPublisher()
  }

  private var cachedItems: [RecordingItem] = []

  init() {
    cachedItems = loadFromUserDefaults()
    itemsSubject.send(cachedItems)
  }

  func add(_ item: RecordingItem) async {
    cachedItems.append(item)
    saveToUserDefaults()
    itemsSubject.send(cachedItems)
  }

  func remove(id: UUID) async throws {
    guard let item = cachedItems.first(where: { $0.id == id }) else {
      return
    }

    let fileURL = URL(fileURLWithPath: item.fileURL)
    if FileManager.default.fileExists(atPath: fileURL.path) {
      try FileManager.default.removeItem(at: fileURL)
    }

    cachedItems.removeAll { $0.id == id }
    saveToUserDefaults()
    itemsSubject.send(cachedItems)
  }

  func getAll() async -> [RecordingItem] {
    return cachedItems
  }

  private func loadFromUserDefaults() -> [RecordingItem] {
    guard let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey) else {
      return []
    }

    do {
      let items = try JSONDecoder().decode([RecordingItem].self, from: data)
      return items
    } catch {
      print("Failed to decode recording items: \(error)")
      return []
    }
  }

  private func saveToUserDefaults() {
    do {
      let data = try JSONEncoder().encode(cachedItems)
      UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
    } catch {
      print("Failed to encode recording items: \(error)")
    }
  }
}
