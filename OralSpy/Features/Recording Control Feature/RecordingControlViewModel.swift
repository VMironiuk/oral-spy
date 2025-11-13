import Combine
import Foundation

protocol TimerServiceType {
  var elapsedSeconds: AnyPublisher<TimeInterval, Never> { get }
  func start()
  func stop()
  func pause()
}

enum RecordingStatus: String {
  case stopped = "Stopped"
  case recording = "Recording"
  case paused = "Paused"
}

final class RecordingControlViewModel: ObservableObject {
  @Published private(set) var recordingStatus: RecordingStatus = .stopped
  @Published private(set) var recordingStatusText = ""
  @Published private(set) var durationText = "00:00:00"
  @Published var error: Error?

  private let timerService: TimerServiceType
  private var timerCancellable: AnyCancellable?

  init(timerService: TimerServiceType = TimerService()) {
    self.timerService = timerService
    timerCancellable = timerService.elapsedSeconds
      .sink { [weak self] seconds in
        guard let self else { return }
        self.durationText = self.formatDuration(seconds)
      }
  }

  func recordButtonClicked() {
    recordingStatus = .recording
    recordingStatusText = RecordingStatus.recording.rawValue
    timerService.start()
  }

  func stopButtonClicked() {
    recordingStatus = .stopped
    recordingStatusText = RecordingStatus.stopped.rawValue
    timerService.stop()
  }

  func pauseButtonClicked() {
    switch recordingStatus {
    case .recording:
      recordingStatus = .paused
      recordingStatusText = RecordingStatus.paused.rawValue
      timerService.pause()
    case .paused:
      recordingStatus = .recording
      recordingStatusText = RecordingStatus.recording.rawValue
      timerService.start()
    case .stopped:
      break
    }
  }

  private func formatDuration(_ seconds: TimeInterval) -> String {
    let totalSeconds = Int(seconds)
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }
}
