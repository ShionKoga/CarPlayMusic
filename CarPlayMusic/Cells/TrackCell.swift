import SwiftUI
import MusicKit


struct TrackCell: View {
    let track: Track
    let album: Album
    let action: () -> Void
    
    init(_ track: Track, from album: Album, action: @escaping () -> Void) {
        self.track = track
        self.album = album
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            MusicItemCell(
                artwork: nil,
                title: track.title,
                subtitle: subtitle
            )
            .frame(minHeight: 50)
        }
    }
    
    private var subtitle: String {
        var subtitle = ""
        if track.artistName != album.artistName {
            subtitle = track.artistName
        }
        return subtitle
    }
}
