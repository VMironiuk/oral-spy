import Combine
import Foundation

final class RecordingListViewModel: ObservableObject {
  @Published private(set) var items: [RecordingItem] = []
  @Published private(set) var playingItemId: UUID?
  @Published var error: Error?

  private let repository: RecordingRepositoryType
  private var cancellables = Set<AnyCancellable>()

  init(repository: RecordingRepositoryType = UserDefaultsRecordingRepository()) {
    self.repository = repository

    repository.items
      .receive(on: DispatchQueue.main)
      .sink { [weak self] items in
        self?.items = items
      }
      .store(in: &cancellables)
  }

  func removeItem(id: UUID) {
    Task {
      do {
        try await repository.remove(id: id)
      } catch {
        await MainActor.run {
          self.error = error
        }
      }
    }
  }

  func playItem(id: UUID, url: String) {
    playingItemId = id
  }

  func stopItem() {
    playingItemId = nil
  }
}
