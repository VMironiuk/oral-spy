import SwiftUI

struct RecordingControlView: View {
  @StateObject private var viewModel = RecordingControlViewModel()

  var body: some View {
    HStack(spacing: 20) {
      Button(action: { viewModel.stopButtonClicked() }) {
        Image(systemName: "stop.fill")
          .font(.system(size: 24))
      }
      .buttonStyle(.borderless)
      .disabled(isStopButtonDisabled)

      Button(action: { viewModel.recordButtonClicked() }) {
        Image(systemName: "record.circle")
          .font(.system(size: 24))
      }
      .buttonStyle(.borderless)
      .disabled(isRecordButtonDisabled)

      Button(action: { viewModel.pauseButtonClicked() }) {
        Image(systemName: pauseButtonIcon)
          .font(.system(size: 24))
      }
      .buttonStyle(.borderless)
      .disabled(isPauseButtonDisabled)
    }
    .frame(maxWidth: .infinity)
    .padding()
  }

  private var isStopButtonDisabled: Bool {
    viewModel.recordingState == .stopped
  }

  private var isRecordButtonDisabled: Bool {
    viewModel.recordingState != .stopped
  }

  private var isPauseButtonDisabled: Bool {
    viewModel.recordingState == .stopped
  }

  private var pauseButtonIcon: String {
    switch viewModel.recordingState {
    case .recording:
      return "pause.fill"
    case .paused:
      return "play.fill"
    case .stopped:
      return "pause.fill"
    }
  }
}

#Preview {
  RecordingControlView()
}
