import SwiftUI

struct RecordingRowView: View {
  let item: RecordingItem
  let isPlaying: Bool
  let onPlay: (UUID, String) -> Void
  let onStop: () -> Void

  @State private var isHovered = false

  var body: some View {
    HStack(spacing: 12) {
      if isPlaying {
        Button(action: { onStop() }) {
          Image(systemName: "stop.fill")
        }
        .buttonStyle(.borderless)
      } else if isHovered {
        Button(action: { onPlay(item.id, item.fileURL) }) {
          Image(systemName: "play.fill")
        }
        .buttonStyle(.borderless)
      } else {
        Image(systemName: "music.note")
      }

      Text(item.timestamp)
    }
    .padding(.vertical)
    .onHover { hovering in
      isHovered = hovering
    }
  }
}

#Preview {
  RecordingRowView(
    item: RecordingItem(
      id: UUID(),
      timestamp: "2024-11-13 10:30:00",
      duration: 125,
      fileSize: 1024000,
      fileURL: "/path/to/recording.m4a"
    ),
    isPlaying: false,
    onPlay: { _, _ in },
    onStop: {}
  )
}
