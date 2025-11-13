import Combine
import Foundation

@testable import OralSpy

final class TimerServiceStub: TimerServiceType {
  private let elapsedSecondsSubject = CurrentValueSubject<TimeInterval, Never>(0)
  var secondsToAdvance: TimeInterval = 0

  var elapsedSeconds: AnyPublisher<TimeInterval, Never> {
    elapsedSecondsSubject.eraseToAnyPublisher()
  }

  func start() {
    let newValue = elapsedSecondsSubject.value + secondsToAdvance
    elapsedSecondsSubject.send(newValue)
  }

  func stop() {
    elapsedSecondsSubject.send(0)
  }

  func pause() {
    // Do nothing - preserves current value
  }
}
