import SwiftUI

struct RecordingListView: View {
  @ObservedObject var viewModel: RecordingListViewModel

  var body: some View {
    List {
      ForEach(viewModel.items) { item in
        RecordingRowView(
          item: item,
          isPlaying: viewModel.playingItemId == item.id,
          onPlay: { id, url in
            viewModel.playItem(id: id, url: url)
          },
          onStop: {
            viewModel.stopItem()
          }
        )
        .transition(.move(edge: .leading).combined(with: .opacity))
        .contextMenu {
          Button("Delete", role: .destructive) {
            viewModel.removeItem(id: item.id)
          }
        }
      }
    }
    .animation(.easeInOut(duration: 0.3), value: viewModel.items)
    .alert("Error", isPresented: .constant(viewModel.error != nil)) {
      Button("OK") {}
    } message: {
      Text(viewModel.error?.localizedDescription ?? "Unknown error")
    }
  }
}

#Preview {
  RecordingListView(
    viewModel: RecordingListViewModel()
  )
}
