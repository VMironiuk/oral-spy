import SwiftUI

struct RecordingControlView: View {
  @StateObject private var viewModel = RecordingControlViewModel()

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      if let statusText = viewModel.recordingStatusText {
        Text(statusText)
          .font(.headline)
      }

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
    }
    .padding()
  }

  private var isStopButtonDisabled: Bool {
    viewModel.recordingStatus == .stopped
  }

  private var isRecordButtonDisabled: Bool {
    viewModel.recordingStatus != .stopped
  }

  private var isPauseButtonDisabled: Bool {
    viewModel.recordingStatus == .stopped
  }

  private var pauseButtonIcon: String {
    switch viewModel.recordingStatus {
    case .recording:
      "pause.fill"
    case .paused:
      "play.fill"
    case .stopped:
      "pause.fill"
    }
  }
}

#Preview {
  RecordingControlView()
}
