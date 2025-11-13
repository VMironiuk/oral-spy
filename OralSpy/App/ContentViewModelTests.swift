import Testing

@testable import OralSpy

@Test func initialStateHasBothEnabled() {
  let viewModel = ContentViewModel()

  #expect(viewModel.isRecordingEnabled == true)
  #expect(viewModel.isPlaybackEnabled == true)
}

@Test func playbackDisabledWhenRecordingStarts() {
  let viewModel = ContentViewModel()

  viewModel.recordingControlViewModel.recordButtonClicked()

  #expect(viewModel.isPlaybackEnabled == false)
}

@Test func playbackDisabledWhenRecordingPaused() {
  let viewModel = ContentViewModel()

  viewModel.recordingControlViewModel.recordButtonClicked()
  viewModel.recordingControlViewModel.pauseButtonClicked()

  #expect(viewModel.isPlaybackEnabled == false)
}

@Test func playbackEnabledWhenRecordingStopped() {
  let viewModel = ContentViewModel()

  viewModel.recordingControlViewModel.recordButtonClicked()
  viewModel.recordingControlViewModel.stopButtonClicked()

  #expect(viewModel.isPlaybackEnabled == true)
}

@Test func recordingDisabledWhenPlaybackStarts() {
  let viewModel = ContentViewModel()
  let testItem = RecordingItem.test[0]

  viewModel.recordingListViewModel.playItem(id: testItem.id, url: testItem.fileURL)

  #expect(viewModel.isRecordingEnabled == false)
}

@Test func recordingEnabledWhenPlaybackStops() {
  let viewModel = ContentViewModel()
  let testItem = RecordingItem.test[0]

  viewModel.recordingListViewModel.playItem(id: testItem.id, url: testItem.fileURL)
  viewModel.recordingListViewModel.stopItem()

  #expect(viewModel.isRecordingEnabled == true)
}

@Test func playbackStopsAutomaticallyWhenRecordingStarts() {
  let viewModel = ContentViewModel()
  let testItem = RecordingItem.test[0]

  viewModel.recordingListViewModel.playItem(id: testItem.id, url: testItem.fileURL)
  viewModel.recordingControlViewModel.recordButtonClicked()

  #expect(viewModel.recordingListViewModel.playingItemId == nil)
}

@Test func playbackStopsAutomaticallyWhenRecordingResumes() {
  let viewModel = ContentViewModel()
  let testItem = RecordingItem.test[0]

  viewModel.recordingControlViewModel.recordButtonClicked()
  viewModel.recordingControlViewModel.pauseButtonClicked()
  viewModel.recordingListViewModel.playItem(id: testItem.id, url: testItem.fileURL)
  viewModel.recordingControlViewModel.pauseButtonClicked()

  #expect(viewModel.recordingListViewModel.playingItemId == nil)
}
