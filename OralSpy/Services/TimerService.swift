import Combine
import Foundation

final class TimerService: TimerServiceType {
  private let elapsedSecondsSubject = CurrentValueSubject<TimeInterval, Never>(0)
  private var timerCancellable: AnyCancellable?

  var elapsedSeconds: AnyPublisher<TimeInterval, Never> {
    elapsedSecondsSubject.eraseToAnyPublisher()
  }

  func start() {
    timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        guard let self else { return }
        let newValue = self.elapsedSecondsSubject.value + 1
        self.elapsedSecondsSubject.send(newValue)
      }
  }

  func stop() {
    timerCancellable?.cancel()
    timerCancellable = nil
    elapsedSecondsSubject.send(0)
  }

  func pause() {
    timerCancellable?.cancel()
    timerCancellable = nil
  }
}
