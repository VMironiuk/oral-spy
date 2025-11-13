import Combine
import Foundation

enum RecordingState {
  case stopped
  case recording
  case paused
}

final class RecordingControlViewModel: ObservableObject {
  @Published private(set) var recordingState: RecordingState = .stopped

  func recordButtonClicked() {
    recordingState = .recording
  }

  func stopButtonClicked() {
    recordingState = .stopped
  }

  func pauseButtonClicked() {
    switch recordingState {
    case .recording:
      recordingState = .paused
    case .paused:
      recordingState = .recording
    case .stopped:
      break
    }
  }
}
