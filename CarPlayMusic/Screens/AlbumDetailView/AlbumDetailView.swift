import SwiftUI
import MusicKit


struct AlbumDetailView: View {
    @StateObject var viewModel: ViewModel
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
    private var isPlaying: Bool {
        return (playerState.playbackStatus == .playing)
    }
    
    private var header: some View {
        VStack {
            if let artwork = viewModel.album.artwork {
                ArtworkImage(artwork, width: 320)
                    .cornerRadius(8)
            }
            Text(viewModel.album.artistName)
                .font(.title2.bold())
            playButtonRow
        }
    }
    
    private var playButtonRow: some View {
        HStack {
            Button(action: viewModel.handlePlayButtonSelected) {
                HStack {
                    Image(systemName: (isPlaying ? "pause.fill" : "play.fill"))
                    Text(isPlaying ? "Pause" : "Play")
                }
                .frame(maxWidth: 200)
            }
            .buttonStyle(.prominent)
            .disabled(viewModel.isPlayButtonDisabled)
            .animation(.easeInOut(duration: 0.1), value: isPlaying)
            
            if viewModel.shouldOfferSubscription {
                Button(action: viewModel.handleSubscriptionOfferButtonSelected) {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Join")
                    }
                    .frame(maxWidth: 200)
                }
                .buttonStyle(.prominent)
            }
        }
    }
    
    var body: some View {
        List {
            Section(header: header, content: {})
                .textCase(nil)
                .foregroundColor(Color.primary)
            
            if let loadedTracks = viewModel.tracks, !loadedTracks.isEmpty {
                Section(header: Text("Tracks")) {
                    ForEach(loadedTracks) { track in
                        TrackCell(track, from: viewModel.album) {
                            viewModel.handleTrackSelected(track, loadedTracks: loadedTracks)
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .task {
            try? await viewModel.loadTracksAndRelatedAlbums()
        }
        .task {
            await viewModel.startObservingMusicSubscription()
        }
        .musicSubscriptionOffer(isPresented: $viewModel.isShowingSubscriptionOffer, options: viewModel.subscriptionOfferOptions)
    }
}
