import Combine
import Foundation

final class RecordingRowViewModel: ObservableObject {
  @Published private(set) var isPlaying = false

  func playButtonClicked(for url: String) {
    isPlaying = true
  }

  func stopButtonClicked() {
    isPlaying = false
  }
}
