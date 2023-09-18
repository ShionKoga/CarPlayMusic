import SwiftUI
import MusicKit

struct AlbumCell: View {
    let album: Album
    
    var body: some View {
        NavigationLink {
            AlbumDetailView(album: album)
        } label: {
            MusicItemCell(
                artwork: album.artwork,
                title: album.title,
                subtitle: album.artistName
            )
        }
    }
}
