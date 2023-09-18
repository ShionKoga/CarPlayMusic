import SwiftUI
import MusicKit


struct ContentView: View {
    @State private var searchTerm = ""
    @State private var albums: MusicItemCollection<Album> = []
    
    var body: some View {
        NavigationView {
            navigationViewContents
                .navigationTitle("Music Albums")
        }
        .searchable(text: $searchTerm, prompt: "Albums")
        .onChange(of: searchTerm, perform: requestUpdatedSearchResults)
        .welcomeSheet()
    }
    
    private var navigationViewContents: some View {
        VStack {
            List(albums) { album in
                AlbumCell(album: album)
            }
            .animation(.default, value: albums)
        }
    }
    
    private func requestUpdatedSearchResults(for searchTerm: String) {
        Task {
            if searchTerm.isEmpty {
                await self.reset()
            } else {
                do {
                    // Issue a catalog search request for albums matching the search term.
                    var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
                    searchRequest.limit = 5
                    let searchResponse = try await searchRequest.response()
                    
                    // Update the user interface with the search response.
                    await self.apply(searchResponse, for: searchTerm)
                } catch {
                    print("Search request failed with error: \(error).")
                    await self.reset()
                }
            }
        }
    }
    
    /// Safely updates the `albums` property on the main thread.
    @MainActor
    private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.albums = searchResponse.albums
        }
    }
    
    @MainActor
    private func reset() {
        self.albums = []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
