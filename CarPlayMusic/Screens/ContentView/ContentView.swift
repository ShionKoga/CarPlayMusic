import SwiftUI
import MusicKit


struct ContentView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.albums) { album in
                    AlbumCell(album: album)
                }
                .animation(.default, value: viewModel.albums)
            }
            .navigationTitle("Music Albums")
        }
        .searchable(text: $viewModel.searchTerm, prompt: "Albums")
        .onChange(of: viewModel.searchTerm, perform: viewModel.requestUpdatedSearchResults)
        .welcomeSheet()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init())
    }
}
