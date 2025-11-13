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
  @Published private(set) var durationText = "00:00:00"

  private var elapsedSeconds: TimeInterval = 0
  private var timerCancellable: AnyCancellable?

  func recordButtonClicked() {
    recordingStatus = .recording
    recordingStatusText = RecordingStatus.recording.rawValue
    startTimer()
  }

  func stopButtonClicked() {
    recordingStatus = .stopped
    recordingStatusText = RecordingStatus.stopped.rawValue
    stopTimer()
  }

  func pauseButtonClicked() {
    switch recordingStatus {
    case .recording:
      recordingStatus = .paused
      recordingStatusText = RecordingStatus.paused.rawValue
      timerCancellable?.cancel()
      timerCancellable = nil
    case .paused:
      recordingStatus = .recording
      recordingStatusText = RecordingStatus.recording.rawValue
      startTimer()
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

  private func startTimer() {
    timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self else { return }
        self.elapsedSeconds += 1
        self.durationText = self.formatDuration(self.elapsedSeconds)
      }
  }

  private func stopTimer() {
    timerCancellable?.cancel()
    timerCancellable = nil
    elapsedSeconds = 0
    durationText = "00:00:00"
  }
}
