import Combine
import Foundation

final class ContentViewModel: ObservableObject {
  let recordingControlViewModel: RecordingControlViewModel
  let recordingListViewModel: RecordingListViewModel

  @Published private(set) var isRecordingEnabled = true
  @Published private(set) var isPlaybackEnabled = true

  private var cancellables = Set<AnyCancellable>()

  init(
    recordingControlViewModel: RecordingControlViewModel = RecordingControlViewModel(),
    recordingListViewModel: RecordingListViewModel = RecordingListViewModel()
  ) {
    self.recordingControlViewModel = recordingControlViewModel
    self.recordingListViewModel = recordingListViewModel

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
