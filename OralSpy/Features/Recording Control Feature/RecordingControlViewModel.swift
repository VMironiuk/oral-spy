import Combine
import Foundation

enum RecordingStatus: String {
  case stopped = "Stopped"
  case recording = "Recording"
  case paused = "Paused"
}

final class RecordingControlViewModel: ObservableObject {
  @Published private(set) var recordingStatus: RecordingStatus = .stopped
  @Published private(set) var recordingStatusText = ""

  func recordButtonClicked() {
    recordingStatus = .recording
    recordingStatusText = RecordingStatus.recording.rawValue
  }

  func stopButtonClicked() {
    recordingStatus = .stopped
    recordingStatusText = RecordingStatus.stopped.rawValue
  }

  func pauseButtonClicked() {
    switch recordingStatus {
    case .recording:
      recordingStatus = .paused
      recordingStatusText = RecordingStatus.paused.rawValue
    case .paused:
      recordingStatus = .recording
      recordingStatusText = RecordingStatus.recording.rawValue
    case .stopped:
      break
    }
  }
}
