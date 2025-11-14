import Combine
import Foundation

enum AudioPlaybackServiceError: Error, LocalizedError {
  case fileNotFound
  case invalidFormat
  case playbackFailed(reason: String)

  var errorDescription: String? {
    switch self {
    case .fileNotFound:
      "Audio file not found"
    case .invalidFormat:
      "Unsupported audio format"
    case .playbackFailed(let reason):
      "Playback failed: \(reason)"
    }
  }
}

protocol AudioPlaybackServiceType {
  var error: AnyPublisher<Error?, Never> { get }
  var playbackFinished: AnyPublisher<Void, Never> { get }
  func play(url: URL)
  func stop()
}

final class RecordingListViewModel: ObservableObject {
  @Published private(set) var items: [RecordingItem] = []
  @Published private(set) var playingItemId: UUID?
  @Published var error: Error?

  private let repository: RecordingRepositoryType
  private let audioPlaybackService: AudioPlaybackServiceType
  private var cancellables = Set<AnyCancellable>()

  init(
    repository: RecordingRepositoryType = CoreDataRecordingRepository(),
    audioPlaybackService: AudioPlaybackServiceType = AudioPlaybackService()
  ) {
    self.repository = repository
    self.audioPlaybackService = audioPlaybackService

    repository.items
      .receive(on: DispatchQueue.main)
      .sink { [weak self] items in
        self?.items = items
      }
      .store(in: &cancellables)

    audioPlaybackService.error
      .receive(on: DispatchQueue.main)
      .compactMap { $0 }
      .sink { [weak self] error in
        self?.error = error
        self?.playingItemId = nil
      }
      .store(in: &cancellables)

    audioPlaybackService.playbackFinished
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.playingItemId = nil
      }
      .store(in: &cancellables)
  }

  func removeItem(id: UUID) {
    Task {
      do {
        try await repository.remove(id: id)
      } catch {
        await MainActor.run {
          self.error = error
        }
      }
    }
  }

  func playItem(id: UUID, url: String) {
    let fileURL = URL(fileURLWithPath: url)
    audioPlaybackService.play(url: fileURL)
    playingItemId = id
  }

  func stopItem() {
    audioPlaybackService.stop()
    playingItemId = nil
  }
}
