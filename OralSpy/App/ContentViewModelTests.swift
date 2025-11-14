import Testing

@testable import OralSpy

struct ContentViewModelTests {
  @Test func initialStateHasBothEnabled() {
    let repository = RecordingRepositoryMock()
    let audioRecordingService = AudioRecordingServiceMock()
    let audioPlaybackService = AudioPlaybackServiceMock()
    let recordingControlViewModel = RecordingControlViewModel(audioRecordingService: audioRecordingService, repository: repository)
    let recordingListViewModel = RecordingListViewModel(repository: repository, audioPlaybackService: audioPlaybackService)
    let viewModel = ContentViewModel(repository: repository, recordingControlViewModel: recordingControlViewModel, recordingListViewModel: recordingListViewModel)

    #expect(viewModel.isRecordingEnabled == true)
    #expect(viewModel.isPlaybackEnabled == true)
  }

  @Test func playbackDisabledWhenRecordingStarts() {
    let repository = RecordingRepositoryMock()
    let audioRecordingService = AudioRecordingServiceMock()
    let audioPlaybackService = AudioPlaybackServiceMock()
    let recordingControlViewModel = RecordingControlViewModel(audioRecordingService: audioRecordingService, repository: repository)
    let recordingListViewModel = RecordingListViewModel(repository: repository, audioPlaybackService: audioPlaybackService)
    let viewModel = ContentViewModel(repository: repository, recordingControlViewModel: recordingControlViewModel, recordingListViewModel: recordingListViewModel)

    viewModel.recordingControlViewModel.recordButtonClicked()

    #expect(viewModel.isPlaybackEnabled == false)
  }

  @Test func playbackDisabledWhenRecordingPaused() {
    let repository = RecordingRepositoryMock()
    let audioRecordingService = AudioRecordingServiceMock()
    let audioPlaybackService = AudioPlaybackServiceMock()
    let recordingControlViewModel = RecordingControlViewModel(audioRecordingService: audioRecordingService, repository: repository)
    let recordingListViewModel = RecordingListViewModel(repository: repository, audioPlaybackService: audioPlaybackService)
    let viewModel = ContentViewModel(repository: repository, recordingControlViewModel: recordingControlViewModel, recordingListViewModel: recordingListViewModel)

    viewModel.recordingControlViewModel.recordButtonClicked()
    viewModel.recordingControlViewModel.pauseButtonClicked()

    #expect(viewModel.isPlaybackEnabled == false)
  }

  @Test func playbackEnabledWhenRecordingStopped() {
    let repository = RecordingRepositoryMock()
    let audioRecordingService = AudioRecordingServiceMock()
    let audioPlaybackService = AudioPlaybackServiceMock()
    let recordingControlViewModel = RecordingControlViewModel(audioRecordingService: audioRecordingService, repository: repository)
    let recordingListViewModel = RecordingListViewModel(repository: repository, audioPlaybackService: audioPlaybackService)
    let viewModel = ContentViewModel(repository: repository, recordingControlViewModel: recordingControlViewModel, recordingListViewModel: recordingListViewModel)

    viewModel.recordingControlViewModel.recordButtonClicked()
    viewModel.recordingControlViewModel.stopButtonClicked()

    #expect(viewModel.isPlaybackEnabled == true)
  }

  @Test func recordingDisabledWhenPlaybackStarts() {
    let repository = RecordingRepositoryMock()
    let audioRecordingService = AudioRecordingServiceMock()
    let audioPlaybackService = AudioPlaybackServiceMock()
    let recordingControlViewModel = RecordingControlViewModel(audioRecordingService: audioRecordingService, repository: repository)
    let recordingListViewModel = RecordingListViewModel(repository: repository, audioPlaybackService: audioPlaybackService)
    let viewModel = ContentViewModel(repository: repository, recordingControlViewModel: recordingControlViewModel, recordingListViewModel: recordingListViewModel)
    let testItem = RecordingItem.test[0]

    viewModel.recordingListViewModel.playItem(id: testItem.id, url: testItem.fileURL)

    #expect(viewModel.isRecordingEnabled == false)
  }

  @Test func recordingEnabledWhenPlaybackStops() {
    let repository = RecordingRepositoryMock()
    let audioRecordingService = AudioRecordingServiceMock()
    let audioPlaybackService = AudioPlaybackServiceMock()
    let recordingControlViewModel = RecordingControlViewModel(audioRecordingService: audioRecordingService, repository: repository)
    let recordingListViewModel = RecordingListViewModel(repository: repository, audioPlaybackService: audioPlaybackService)
    let viewModel = ContentViewModel(repository: repository, recordingControlViewModel: recordingControlViewModel, recordingListViewModel: recordingListViewModel)
    let testItem = RecordingItem.test[0]

    viewModel.recordingListViewModel.playItem(id: testItem.id, url: testItem.fileURL)
    viewModel.recordingListViewModel.stopItem()

    #expect(viewModel.isRecordingEnabled == true)
  }

  @Test func playbackStopsAutomaticallyWhenRecordingStarts() {
    let repository = RecordingRepositoryMock()
    let audioRecordingService = AudioRecordingServiceMock()
    let audioPlaybackService = AudioPlaybackServiceMock()
    let recordingControlViewModel = RecordingControlViewModel(audioRecordingService: audioRecordingService, repository: repository)
    let recordingListViewModel = RecordingListViewModel(repository: repository, audioPlaybackService: audioPlaybackService)
    let viewModel = ContentViewModel(repository: repository, recordingControlViewModel: recordingControlViewModel, recordingListViewModel: recordingListViewModel)
    let testItem = RecordingItem.test[0]

    viewModel.recordingListViewModel.playItem(id: testItem.id, url: testItem.fileURL)
    viewModel.recordingControlViewModel.recordButtonClicked()

    #expect(viewModel.recordingListViewModel.playingItemId == nil)
  }

  @Test func playbackStopsAutomaticallyWhenRecordingResumes() {
    let repository = RecordingRepositoryMock()
    let audioRecordingService = AudioRecordingServiceMock()
    let audioPlaybackService = AudioPlaybackServiceMock()
    let recordingControlViewModel = RecordingControlViewModel(audioRecordingService: audioRecordingService, repository: repository)
    let recordingListViewModel = RecordingListViewModel(repository: repository, audioPlaybackService: audioPlaybackService)
    let viewModel = ContentViewModel(repository: repository, recordingControlViewModel: recordingControlViewModel, recordingListViewModel: recordingListViewModel)
    let testItem = RecordingItem.test[0]

    viewModel.recordingControlViewModel.recordButtonClicked()
    viewModel.recordingControlViewModel.pauseButtonClicked()
    viewModel.recordingListViewModel.playItem(id: testItem.id, url: testItem.fileURL)
    viewModel.recordingControlViewModel.pauseButtonClicked()

    #expect(viewModel.recordingListViewModel.playingItemId == nil)
  }
}
