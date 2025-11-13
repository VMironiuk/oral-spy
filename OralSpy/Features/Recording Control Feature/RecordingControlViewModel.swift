import Combine
import Foundation

enum RecordingState {
  case stopped
  case recording
  case paused
}

final class RecordingControlViewModel: ObservableObject {
  @Published private(set) var recordingState: RecordingState = .stopped
  @Published private(set) var recordingStatusText: String?

  func recordButtonClicked() {
    recordingState = .recording
    recordingStatusText = "Recording"
  }

  func stopButtonClicked() {
    recordingState = .stopped
    recordingStatusText = "Stopped"
  }

  func pauseButtonClicked() {
    switch recordingState {
    case .recording:
      recordingState = .paused
      recordingStatusText = "Paused"
    case .paused:
      recordingState = .recording
      recordingStatusText = "Recording"
    case .stopped:
      break
    }
  }
}
