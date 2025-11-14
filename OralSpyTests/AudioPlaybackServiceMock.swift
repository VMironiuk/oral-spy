import Combine
import Foundation

@testable import OralSpy

final class AudioPlaybackServiceMock: AudioPlaybackServiceType {
  private let errorSubject = CurrentValueSubject<Error?, Never>(nil)
  var error: AnyPublisher<Error?, Never> {
    errorSubject.eraseToAnyPublisher()
  }

  private let playbackFinishedSubject = PassthroughSubject<Void, Never>()
  var playbackFinished: AnyPublisher<Void, Never> {
    playbackFinishedSubject.eraseToAnyPublisher()
  }

  var playCallCount = 0
  var stopCallCount = 0
  var lastPlayedURL: URL?

  func play(url: URL) {
    playCallCount += 1
    lastPlayedURL = url
  }

  func stop() {
    stopCallCount += 1
  }

  func simulatePlaybackFinished() {
    playbackFinishedSubject.send()
  }

  func simulateError(_ error: Error) {
    errorSubject.send(error)
  }
}
