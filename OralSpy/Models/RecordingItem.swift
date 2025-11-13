import Foundation

struct RecordingItem: Identifiable {
  let id = UUID()
  let timestamp: String
  let duration: TimeInterval
  let fileSize: Int
  let fileURL: String
}
