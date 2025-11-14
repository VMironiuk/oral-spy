import Testing

@testable import OralSpy

struct RecordingControlViewModelTests {
  @Test func initialStateIsStopped() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    #expect(viewModel.recordingStatus == .stopped)
  }

  @Test func recordButtonClickedTransitionsToRecording() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.recordingStatus == .recording)
  }

  @Test func stopButtonClickedTransitionsToStopped() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.stopButtonClicked()
    #expect(viewModel.recordingStatus == .stopped)
  }

  @Test func pauseButtonClickedWhileRecordingTransitionsToPaused() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatus == .paused)
  }

  @Test func pauseButtonClickedWhilePausedTransitionsToRecording() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatus == .recording)
  }

  @Test func pauseButtonClickedWhileStoppedDoesNothing() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatus == .stopped)
  }

  @Test func stopButtonClickedWhilePausedTransitionsToStopped() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    viewModel.stopButtonClicked()
    #expect(viewModel.recordingStatus == .stopped)
  }

  @Test func initialRecordingStatusTextIsNil() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    #expect(viewModel.recordingStatusText.isEmpty)
  }

  @Test func recordButtonClickedSetsRecordingStatusTextToRecording() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.recordingStatusText == "Recording")
  }

  @Test func stopButtonClickedSetsRecordingStatusTextToStopped() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.stopButtonClicked()
    #expect(viewModel.recordingStatusText == "Stopped")
  }

  @Test func pauseButtonClickedWhileRecordingSetsRecordingStatusTextToPaused() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatusText == "Paused")
  }

  @Test func pauseButtonClickedWhilePausedSetsRecordingStatusTextToRecording() {
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatusText == "Recording")
  }

  @Test func durationTextFormatsSeconds() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 5
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.durationText == "00:00:05")
  }

  @Test func durationTextFormatsMinutesAndSeconds() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 125
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.durationText == "00:02:05")
  }

  @Test func durationTextFormatsHoursMinutesAndSeconds() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 3665
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.durationText == "01:01:05")
  }

  @Test func durationTextFormatsExactlyOneHour() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 3600
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.durationText == "01:00:00")
  }

  @Test func durationTextFormatsExactlyOneMinute() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 60
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.durationText == "00:01:00")
  }

  @Test func durationTextFormatsMultipleHours() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 7325
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.durationText == "02:02:05")
  }

  @Test func durationTextResetsToZeroOnStop() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 125
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.stopButtonClicked()
    #expect(viewModel.durationText == "00:00:00")
  }

  @Test func durationTextPreservesValueOnPause() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 125
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.durationText == "00:02:05")
  }

  @Test func durationTextContinuesFromPausedValueOnResume() {
    let stub = TimerServiceStub()
    stub.secondsToAdvance = 60
    let audioService = AudioRecordingServiceMock()
    let repository = RecordingRepositoryMock()
    let viewModel = RecordingControlViewModel(timerService: stub, audioRecordingService: audioService, repository: repository)
    viewModel.recordButtonClicked()
    #expect(viewModel.durationText == "00:01:00")
    stub.secondsToAdvance = 30
    viewModel.pauseButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.durationText == "00:01:30")
  }
}
