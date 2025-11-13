import Combine
import Foundation

protocol TimerServiceType {
  var elapsedSeconds: AnyPublisher<TimeInterval, Never> { get }
  func start()
  func stop()
  func pause()
}

protocol AudioRecordingServiceType {
  var error: AnyPublisher<Error?, Never> { get }
  var recordingFinished: AnyPublisher<URL, Never> { get }
  func checkPermissions()
  func record() throws
  func pause()
  func stop()
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
  private let audioRecordingService: AudioRecordingServiceType
  private var cancellables = Set<AnyCancellable>()

  init(
    timerService: TimerServiceType = TimerService(),
    audioRecordingService: AudioRecordingServiceType = AudioRecordingService()
  ) {
    self.timerService = timerService
    self.audioRecordingService = audioRecordingService
    
    timerService.elapsedSeconds
      .sink { [weak self] seconds in
        guard let self else { return }
        self.durationText = self.formatDuration(seconds)
      }
      .store(in: &cancellables)
    
    audioRecordingService.error
      .receive(on: DispatchQueue.main)
      .sink { [weak self] error in
        guard let self else { return }
        recordingStatus = .stopped
        recordingStatusText = RecordingStatus.stopped.rawValue
        timerService.stop()
        audioRecordingService.stop()
        self.error = error
      }
      .store(in: &cancellables)

    audioRecordingService.recordingFinished
      .receive(on: DispatchQueue.main)
      .sink { fileURL in
        print("Recording finished: \(fileURL)")
      }
      .store(in: &cancellables)

    audioRecordingService.checkPermissions()
  }

  func recordButtonClicked() {
    do {
      try audioRecordingService.record()
      recordingStatus = .recording
      recordingStatusText = RecordingStatus.recording.rawValue
      timerService.start()
    } catch {
      self.error = error
    }
  }

  func stopButtonClicked() {
    audioRecordingService.stop()
    recordingStatus = .stopped
    recordingStatusText = RecordingStatus.stopped.rawValue
    timerService.stop()
  }

  func pauseButtonClicked() {
    switch recordingStatus {
    case .recording:
      audioRecordingService.pause()
      recordingStatus = .paused
      recordingStatusText = RecordingStatus.paused.rawValue
      timerService.pause()
    case .paused:
      do {
        try audioRecordingService.record()
        recordingStatus = .recording
        recordingStatusText = RecordingStatus.recording.rawValue
        timerService.start()
      } catch {
        self.error = error
      }
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
