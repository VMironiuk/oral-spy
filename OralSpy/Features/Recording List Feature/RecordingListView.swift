import SwiftUI

struct RecordingListView: View {
  @StateObject private var viewModel = RecordingListViewModel()

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
      }
      .onDelete { indexSet in
        indexSet.forEach { index in
          viewModel.removeItem(id: viewModel.items[index].id)
        }
      }
    }
  }
}

#Preview {
  RecordingListView()
}
