import Combine
import Foundation

final class RecordingListViewModel: ObservableObject {
  @Published private(set) var items: [RecordingItem] = RecordingItem.test
  @Published private(set) var playingItemId: UUID?

  func removeItem(id: UUID) {
    items.removeAll { $0.id == id }
  }

  func playItem(id: UUID, url: String) {
    playingItemId = id
  }

  func stopItem() {
    playingItemId = nil
  }
}
