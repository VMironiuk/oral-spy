import SwiftUI

struct RecordingRowView: View {
  let item: RecordingItem
  @StateObject private var viewModel = RecordingRowViewModel()
  @State private var isHovered = false

  var body: some View {
    HStack(spacing: 12) {
      if viewModel.isPlaying {
        Button(action: { viewModel.stopButtonClicked() }) {
          Image(systemName: "stop.fill")
        }
        .buttonStyle(.borderless)
      } else if isHovered {
        Button(action: { viewModel.playButtonClicked(for: item.fileURL) }) {
          Image(systemName: "play.fill")
        }
        .buttonStyle(.borderless)
      } else {
        Image(systemName: "music.note")
      }

      Text(item.timestamp)
    }
    .padding()
    .onHover { hovering in
      isHovered = hovering
    }
  }
}

#Preview {
  RecordingRowView(
    item: RecordingItem(
      timestamp: "2024-11-13 10:30:00",
      duration: 125,
      fileSize: 1024000,
      fileURL: "/path/to/recording.m4a"
    )
  )
}
