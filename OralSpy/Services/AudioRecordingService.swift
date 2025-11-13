import AVFoundation
import Combine

enum AudioRecordingServiceError: Error, LocalizedError {
  case deniedAuthorization
  case restrictedAuthorization
  case unknownAuthorization
  
  var errorDescription: String? {
    switch self {
    case .deniedAuthorization:
      "Microphone access: Authorization denied"
    case .restrictedAuthorization:
      "Microphone access: Authorization restricted"
    case .unknownAuthorization:
      "Microphone access: Unknown authorization error"
    }
  }
}

final class AudioRecordingService: AudioRecordingServiceType {
  private let errorSubject = CurrentValueSubject<Error?, Never>(nil)
  var error: AnyPublisher<Error?, Never> {
    errorSubject.eraseToAnyPublisher()
  }
  
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
  
  func record() {
    setup()
  }
  
  func pause() {}
  
  func stop() {}
  
  private func setup() {
    checkPermissions()
  }
  
  private func set(error: AudioRecordingServiceError) {
    errorSubject.send(error)
  }
}
