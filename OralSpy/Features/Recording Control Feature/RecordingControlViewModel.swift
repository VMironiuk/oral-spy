import Combine
import Foundation

enum RecordingStatus {
  case stopped
  case recording
  case paused
}

final class RecordingControlViewModel: ObservableObject {
  @Published private(set) var recordingStatus: RecordingStatus = .stopped
  @Published private(set) var recordingStatusText: String?

  func recordButtonClicked() {
    recordingStatus = .recording
    recordingStatusText = "Recording"
  }

  func stopButtonClicked() {
    recordingStatus = .stopped
    recordingStatusText = "Stopped"
  }

  func pauseButtonClicked() {
    switch recordingStatus {
    case .recording:
      recordingStatus = .paused
      recordingStatusText = "Paused"
    case .paused:
      recordingStatus = .recording
      recordingStatusText = "Recording"
    case .stopped:
      break
    }
  }
}
