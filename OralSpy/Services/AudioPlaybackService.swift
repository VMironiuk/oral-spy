import AVFoundation
import Combine
import Foundation

final class AudioPlaybackService: NSObject, AudioPlaybackServiceType {
  private let errorSubject = CurrentValueSubject<Error?, Never>(nil)
  var error: AnyPublisher<Error?, Never> {
    errorSubject.eraseToAnyPublisher()
  }

  private var audioPlayer: AVAudioPlayer?
  private let playbackFinishedSubject = PassthroughSubject<Void, Never>()
  var playbackFinished: AnyPublisher<Void, Never> {
    playbackFinishedSubject.eraseToAnyPublisher()
  }

  func play(url: URL) {
    stop()

    guard FileManager.default.fileExists(atPath: url.path) else {
      errorSubject.send(AudioPlaybackServiceError.fileNotFound)
      return
    }

    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.delegate = self
      audioPlayer = player

      let success = player.play()
      if !success {
        errorSubject.send(AudioPlaybackServiceError.playbackFailed(reason: "Failed to start playback"))
        audioPlayer = nil
      }
    } catch {
      errorSubject.send(AudioPlaybackServiceError.playbackFailed(reason: error.localizedDescription))
      audioPlayer = nil
    }
  }

  func stop() {
    audioPlayer?.stop()
    audioPlayer = nil
  }
}

extension AudioPlaybackService: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    playbackFinishedSubject.send()
    audioPlayer = nil
  }

  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    if let error = error {
      errorSubject.send(AudioPlaybackServiceError.playbackFailed(reason: error.localizedDescription))
    }
    audioPlayer = nil
  }
}
