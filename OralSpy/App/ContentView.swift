import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(spacing: 0) {
      RecordingControlView()
      RecordingListView()
    }
    .frame(minWidth: 250, idealWidth: 250, minHeight: 500, idealHeight: 600)
  }
}

#Preview {
  ContentView()
}
