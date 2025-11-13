import Testing

@testable import OralSpy

struct RecordingRowViewModelTests {
  @Test func initialIsPlayingIsFalse() {
    let viewModel = RecordingRowViewModel()
    #expect(viewModel.isPlaying == false)
  }

  @Test func playButtonClickedSetsIsPlayingToTrue() {
    let viewModel = RecordingRowViewModel()
    viewModel.playButtonClicked(for: "/path/to/file.m4a")
    #expect(viewModel.isPlaying == true)
  }

  @Test func stopButtonClickedSetsIsPlayingToFalse() {
    let viewModel = RecordingRowViewModel()
    viewModel.playButtonClicked(for: "/path/to/file.m4a")
    viewModel.stopButtonClicked()
    #expect(viewModel.isPlaying == false)
  }

  @Test func multiplePlayStopTogglesWork() {
    let viewModel = RecordingRowViewModel()
    viewModel.playButtonClicked(for: "/path/to/file1.m4a")
    #expect(viewModel.isPlaying == true)
    viewModel.stopButtonClicked()
    #expect(viewModel.isPlaying == false)
    viewModel.playButtonClicked(for: "/path/to/file2.m4a")
    #expect(viewModel.isPlaying == true)
    viewModel.stopButtonClicked()
    #expect(viewModel.isPlaying == false)
  }
}
