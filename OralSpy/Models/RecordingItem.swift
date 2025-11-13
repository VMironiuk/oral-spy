import Foundation

struct RecordingItem: Identifiable {
  let id = UUID()
  let timestamp: String
  let duration: TimeInterval
  let fileSize: Int
  let fileURL: String

  static let test: [RecordingItem] = [
    RecordingItem(
      timestamp: "2024-11-13 10:30:00",
      duration: 125,
      fileSize: 1024000,
      fileURL: "/path/to/rec1.m4a"
    ),
    RecordingItem(
      timestamp: "2024-11-13 14:15:30",
      duration: 320,
      fileSize: 2048000,
      fileURL: "/path/to/rec2.m4a"
    ),
    RecordingItem(
      timestamp: "2024-11-13 16:45:10",
      duration: 67,
      fileSize: 512000,
      fileURL: "/path/to/rec3.m4a"
    )
  ]
}
