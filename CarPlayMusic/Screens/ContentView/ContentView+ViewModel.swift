import Combine
import MusicKit

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var searchTerm = ""
        @Published var albums: MusicItemCollection<Album> = []
        
        func requestUpdatedSearchResults(for searchTerm: String) {
            Task {
                if searchTerm.isEmpty {
                    await self.reset()
                } else {
                    do {
                        var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
                        searchRequest.limit = 5
                        let searchResponse = try await searchRequest.response()
                        
                        await self.apply(searchResponse, for: searchTerm)
                    } catch {
                        print("Search request failed with error: \(error).")
                        await self.reset()
                    }
                }
            }
        }
        
        @MainActor
        private func apply(_ searchResponse: MusicCatalogSearchResponse, for searchTerm: String) {
            if searchTerm == searchTerm {
                albums = searchResponse.albums
            }
        }
        
        @MainActor
        private func reset() {
            albums = []
        }
    }
}
