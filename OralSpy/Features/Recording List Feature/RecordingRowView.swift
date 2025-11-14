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

      VStack(alignment: .leading, spacing: 4) {
        Text(item.timestamp)
          .font(.body)

        HStack(spacing: 8) {
          Text(formatDuration(item.duration))
            .font(.caption)
            .foregroundColor(.secondary)

          Text("•")
            .foregroundColor(.secondary)

          Text(formatFileSize(item.fileSize))
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }

      Spacer()
    }
    .onHover { hovering in
      isHovered = hovering
    }
  }

  private func formatDuration(_ seconds: TimeInterval) -> String {
    let totalSeconds = Int(seconds)
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let secs = totalSeconds % 60

    if hours > 0 {
      return String(format: "%d:%02d:%02d", hours, minutes, secs)
    } else {
      return String(format: "%d:%02d", minutes, secs)
    }
  }

  private func formatFileSize(_ bytes: Int) -> String {
    let formatter = ByteCountFormatter()
    formatter.countStyle = .file
    return formatter.string(fromByteCount: Int64(bytes))
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
