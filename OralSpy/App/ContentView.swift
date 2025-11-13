import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = ContentViewModel()

  var body: some View {
    VStack(spacing: 0) {
      RecordingControlView(
        viewModel: viewModel.recordingControlViewModel
      )
      .disabled(!viewModel.isRecordingEnabled)
      RecordingListView(
        viewModel: viewModel.recordingListViewModel
      )
      .disabled(!viewModel.isPlaybackEnabled)
    }
    .frame(minWidth: 250, idealWidth: 250, minHeight: 500, idealHeight: 600)
  }
}

#Preview {
  ContentView()
}
