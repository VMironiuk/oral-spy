import Combine
import Foundation

@testable import OralSpy

final class AudioRecordingServiceMock: AudioRecordingServiceType {
  private let errorSubject = CurrentValueSubject<Error?, Never>(nil)
  var error: AnyPublisher<Error?, Never> {
    errorSubject.eraseToAnyPublisher()
  }

  private let recordingFinishedSubject = PassthroughSubject<RecordingMetadata, Never>()
  var recordingFinished: AnyPublisher<RecordingMetadata, Never> {
    recordingFinishedSubject.eraseToAnyPublisher()
  }

  var shouldThrowOnRecord = false
  var recordCallCount = 0
  var pauseCallCount = 0
  var stopCallCount = 0
  var checkPermissionsCallCount = 0

  func checkPermissions() {
    checkPermissionsCallCount += 1
  }

  func record() throws {
    recordCallCount += 1
    if shouldThrowOnRecord {
      throw AudioRecordingServiceError.deniedAuthorization
    }
  }

  func pause() {
    pauseCallCount += 1
  }

  func stop() {
    stopCallCount += 1
  }

  func simulateRecordingFinished(metadata: RecordingMetadata) {
    recordingFinishedSubject.send(metadata)
  }

  func simulateError(_ error: Error) {
    errorSubject.send(error)
  }
}
