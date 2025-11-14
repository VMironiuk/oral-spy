import Combine
import Foundation

protocol RecordingRepositoryType {
  var items: AnyPublisher<[RecordingItem], Never> { get }
  func add(_ item: RecordingItem) async
  func remove(id: UUID) async throws
  func getAll() async -> [RecordingItem]
}

final class ContentViewModel: ObservableObject {
  let recordingControlViewModel: RecordingControlViewModel
  let recordingListViewModel: RecordingListViewModel

  @Published private(set) var isRecordingEnabled = true
  @Published private(set) var isPlaybackEnabled = true

  private var cancellables = Set<AnyCancellable>()

  init(
    repository: RecordingRepositoryType = CoreDataRecordingRepository()
  ) {
    self.recordingControlViewModel = RecordingControlViewModel(repository: repository)
    self.recordingListViewModel = RecordingListViewModel(repository: repository)

    setupCoordination()
  }

  private func setupCoordination() {
    recordingControlViewModel.$recordingStatus
      .sink { [weak self] status in
        guard let self else { return }
        switch status {
        case .stopped:
          self.isPlaybackEnabled = true
        case .recording, .paused:
          self.isPlaybackEnabled = false
          self.recordingListViewModel.stopItem()
        }
      }
      .store(in: &cancellables)

    recordingListViewModel.$playingItemId
      .sink { [weak self] playingId in
        guard let self else { return }
        self.isRecordingEnabled = (playingId == nil)
      }
      .store(in: &cancellables)
  }
}
