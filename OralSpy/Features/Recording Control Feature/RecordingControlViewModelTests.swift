import Testing

@testable import OralSpy

struct RecordingControlViewModelTests {
  @Test func initialStateIsStopped() {
    let viewModel = RecordingControlViewModel()
    #expect(viewModel.recordingStatus == .stopped)
  }

  @Test func recordButtonClickedTransitionsToRecording() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    #expect(viewModel.recordingStatus == .recording)
  }

  @Test func stopButtonClickedTransitionsToStopped() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    viewModel.stopButtonClicked()
    #expect(viewModel.recordingStatus == .stopped)
  }

  @Test func pauseButtonClickedWhileRecordingTransitionsToPaused() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatus == .paused)
  }

  @Test func pauseButtonClickedWhilePausedTransitionsToRecording() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatus == .recording)
  }

  @Test func pauseButtonClickedWhileStoppedDoesNothing() {
    let viewModel = RecordingControlViewModel()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatus == .stopped)
  }

  @Test func stopButtonClickedWhilePausedTransitionsToStopped() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    viewModel.stopButtonClicked()
    #expect(viewModel.recordingStatus == .stopped)
  }

  @Test func initialRecordingStatusTextIsNil() {
    let viewModel = RecordingControlViewModel()
    #expect(viewModel.recordingStatusText == nil)
  }

  @Test func recordButtonClickedSetsRecordingStatusTextToRecording() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    #expect(viewModel.recordingStatusText == "Recording")
  }

  @Test func stopButtonClickedSetsRecordingStatusTextToStopped() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    viewModel.stopButtonClicked()
    #expect(viewModel.recordingStatusText == "Stopped")
  }

  @Test func pauseButtonClickedWhileRecordingSetsRecordingStatusTextToPaused() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatusText == "Paused")
  }

  @Test func pauseButtonClickedWhilePausedSetsRecordingStatusTextToRecording() {
    let viewModel = RecordingControlViewModel()
    viewModel.recordButtonClicked()
    viewModel.pauseButtonClicked()
    viewModel.pauseButtonClicked()
    #expect(viewModel.recordingStatusText == "Recording")
  }
}
