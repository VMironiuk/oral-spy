import AVFoundation
import Combine

struct RecordingMetadata {
  let url: URL
  let timestamp: String
  let duration: TimeInterval
  let fileSize: Int
}

enum AudioRecordingServiceError: Error, LocalizedError {
  case deniedAuthorization
  case restrictedAuthorization
  case unknownAuthorization
  case recordingSetupFailed(reason: String)
  case recordingFailed(reason: String)
  case fileSystemError(reason: String)

  var errorDescription: String? {
    switch self {
    case .deniedAuthorization:
      "Microphone access: Authorization denied"
    case .restrictedAuthorization:
      "Microphone access: Authorization restricted"
    case .unknownAuthorization:
      "Microphone access: Unknown authorization error"
    case .recordingSetupFailed(let reason):
      "Recording setup failed: \(reason)"
    case .recordingFailed(let reason):
      "Recording failed: \(reason)"
    case .fileSystemError(let reason):
      "File system error: \(reason)"
    }
  }
}

final class AudioRecordingService: NSObject, AudioRecordingServiceType {
  private let errorSubject = CurrentValueSubject<Error?, Never>(nil)
  var error: AnyPublisher<Error?, Never> {
    errorSubject.eraseToAnyPublisher()
  }

  private let recordingFinishedSubject = PassthroughSubject<RecordingMetadata, Never>()
  var recordingFinished: AnyPublisher<RecordingMetadata, Never> {
    recordingFinishedSubject.eraseToAnyPublisher()
  }

  private var audioRecorder: AVAudioRecorder?
  private var currentRecordingURL: URL?
  private var isRecording = false
  private var isPaused = false
  
  private static let dateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd_HHmmss"
    return dateFormatter
  }()
  
  func checkPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .audio) {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .audio) { [weak self] authorized in
        if !authorized {
          self?.set(error: .deniedAuthorization)
        }
      }
      
    case .restricted:
      set(error: .restrictedAuthorization)
      
    case .denied:
      set(error: .deniedAuthorization)
      
    case .authorized:
      break
      
    @unknown default:
      set(error: .unknownAuthorization)
    }
  }
  
  func record() throws {
    guard AVCaptureDevice.authorizationStatus(for: .audio) == .authorized else {
      throw AudioRecordingServiceError.deniedAuthorization
    }

    if isPaused, let recorder = audioRecorder {
      recorder.record()
      isPaused = false
      isRecording = true
      return
    }

    do {
      let recordingURL = try generateRecordingURL()
      currentRecordingURL = recordingURL

      let recorder = try AVAudioRecorder(url: recordingURL, settings: getAudioSettings())
      recorder.delegate = self
      audioRecorder = recorder

      let success = recorder.record()
      if success {
        isRecording = true
        isPaused = false
      } else {
        cleanup()
        throw AudioRecordingServiceError.recordingSetupFailed(reason: "Failed to start recording")
      }
    } catch let error as AudioRecordingServiceError {
      cleanup()
      throw error
    } catch {
      cleanup()
      throw AudioRecordingServiceError.recordingSetupFailed(reason: error.localizedDescription)
    }
  }
  
  func pause() {
    guard let recorder = audioRecorder, isRecording else {
      return
    }

    recorder.pause()
    isPaused = true
    isRecording = false
  }
  
  func stop() {
    guard let recorder = audioRecorder, let fileURL = currentRecordingURL else {
      return
    }

    let duration = recorder.currentTime
    recorder.stop()

    if FileManager.default.fileExists(atPath: fileURL.path) {
      let fileSize = (try? FileManager.default.attributesOfItem(atPath: fileURL.path)[.size] as? Int) ?? 0

      let filename = fileURL.deletingPathExtension().lastPathComponent
      let timestamp = filename.replacingOccurrences(of: "recording_", with: "")

      let metadata = RecordingMetadata(
        url: fileURL,
        timestamp: timestamp,
        duration: duration,
        fileSize: fileSize
      )
      recordingFinishedSubject.send(metadata)
    }

    cleanup()
  }

  private func set(error: AudioRecordingServiceError) {
    errorSubject.send(error)
  }

  private func cleanup() {
    audioRecorder = nil
    currentRecordingURL = nil
    isRecording = false
    isPaused = false
  }

  private func getRecordingsDirectory() throws -> URL {
    let fileManager = FileManager.default
    let appSupportURL = try fileManager.url(
      for: .applicationSupportDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )

    let recordingsURL = appSupportURL.appendingPathComponent("OralSpy/Recordings", isDirectory: true)

    if !fileManager.fileExists(atPath: recordingsURL.path) {
      try fileManager.createDirectory(at: recordingsURL, withIntermediateDirectories: true)
    }

    return recordingsURL
  }

  private func generateRecordingURL() throws -> URL {
    let recordingsDir = try getRecordingsDirectory()
    let timestamp = Self.dateFormatter.string(from: Date())
    let filename = "recording_\(timestamp).m4a"
    return recordingsDir.appendingPathComponent(filename)
  }

  private func getAudioSettings() -> [String: Any] {
    return [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 44100.0,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
  }
}

extension AudioRecordingService: AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if !flag {
      set(error: .recordingFailed(reason: "Recording finished unsuccessfully"))
    }
  }

  func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
    if let error = error {
      set(error: .recordingFailed(reason: error.localizedDescription))
    }
  }
}
