import Foundation

struct RecordingItem: Identifiable, Codable {
  let id: UUID
  let timestamp: String
  let duration: TimeInterval
  let fileSize: Int
  let fileURL: String

  static let test: [RecordingItem] = [
    RecordingItem(
      id: UUID(),
      timestamp: "2024-11-13_103000",
      duration: 125,
      fileSize: 1024000,
      fileURL: "/path/to/rec1.m4a"
    ),
    RecordingItem(
      id: UUID(),
      timestamp: "2024-11-13_141530",
      duration: 320,
      fileSize: 2048000,
      fileURL: "/path/to/rec2.m4a"
    ),
    RecordingItem(
      id: UUID(),
      timestamp: "2024-11-13_164510",
      duration: 67,
      fileSize: 512000,
      fileURL: "/path/to/rec3.m4a"
    )
  ]
}
