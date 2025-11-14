import Foundation

struct RecordingItem: Identifiable, Codable {
  let id: UUID
  let timestamp: String
  let duration: TimeInterval
  let fileSize: Int
  let fileURL: String
}
