import SwiftUI
import MusicKit


struct ContentView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.albums) { album in
                    NavigationLink {
                        AlbumDetailView(viewModel: .init(album: album))
                    } label: {
                        MusicItemCell(
                            artwork: album.artwork,
                            title: album.title,
                            subtitle: album.artistName
                        )
                    }
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
