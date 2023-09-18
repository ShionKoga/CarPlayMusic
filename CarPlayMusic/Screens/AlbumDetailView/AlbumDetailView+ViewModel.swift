import Combine
import SwiftUI
import MusicKit


extension AlbumDetailView {
    class ViewModel: ObservableObject {
        let album: Album
        let navigationTitle: String
        @Published var tracks: MusicItemCollection<Track>?
        
        private var musicSubscription: MusicSubscription? {
            didSet {
                let canPlayCatalogContent = musicSubscription?.canPlayCatalogContent ?? false
                isPlayButtonDisabled = !canPlayCatalogContent
                shouldOfferSubscription = musicSubscription?.canBecomeSubscriber ?? false
            }
        }
        @Published var isShowingSubscriptionOffer = false
        @Published var subscriptionOfferOptions: MusicSubscriptionOffer.Options = .default
        @Published var isPlayButtonDisabled: Bool
        @Published var shouldOfferSubscription: Bool
        
        private let player = ApplicationMusicPlayer.shared
        private var isPlaybackQueueSet = false
        
        init(album: Album) {
            self.album = album
            self.navigationTitle = album.title
            self.isPlayButtonDisabled = false
            self.shouldOfferSubscription = false
        }
        
        func loadTracksAndRelatedAlbums() async throws {
            let detailedAlbum = try await album.with([.artists, .tracks])
            await update(tracks: detailedAlbum.tracks)
        }
        
        @MainActor
        private func update(tracks: MusicItemCollection<Track>?) {
            self.tracks = tracks
        }
        
        func startObservingMusicSubscription() async {
            for await subscription in MusicSubscription.subscriptionUpdates {
                DispatchQueue.main.async {
                    self.musicSubscription = subscription
                }
            }
        }
        
        func handleSubscriptionOfferButtonSelected() {
            subscriptionOfferOptions.messageIdentifier = .playMusic
            subscriptionOfferOptions.itemID = album.id
            isShowingSubscriptionOffer = true
        }
        
        func handlePlayButtonSelected() {
            if player.state.playbackStatus != .playing {
                if !isPlaybackQueueSet {
                    player.queue = [album]
                    isPlaybackQueueSet = true
                    beginPlaying()
                } else {
                    Task {
                        do {
                            try await player.play()
                        } catch {
                            print("Failed to resume playing with error: \(error).")
                        }
                    }
                }
            } else {
                player.pause()
            }
        }
        
        func handleTrackSelected(_ track: Track, loadedTracks: MusicItemCollection<Track>) {
            player.queue = ApplicationMusicPlayer.Queue(for: loadedTracks, startingAt: track)
            isPlaybackQueueSet = true
            beginPlaying()
        }
        
        private func beginPlaying() {
            Task {
                do {
                    try await player.play()
                } catch {
                    print("Failed to prepare to play with error: \(error).")
                }
            }
        }
    }
}
