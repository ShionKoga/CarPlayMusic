import Combine
import MusicKit
import SwiftUI

extension WelcomeView {
    class ViewModel: ObservableObject {
        @Published var musicAuthorizationStatus: MusicAuthorization.Status {
            didSet {
                isWelcomeViewPresented = (musicAuthorizationStatus != .authorized)
            }
        }
        
        @Published var isWelcomeViewPresented: Bool
        
        init() {
            let authorizationStatus = MusicAuthorization.currentStatus
            musicAuthorizationStatus = authorizationStatus
            isWelcomeViewPresented = (authorizationStatus != .authorized)
        }
        
        var showButton: Bool {
            return musicAuthorizationStatus == .notDetermined || musicAuthorizationStatus == .denied
        }
        
        var buttonText: String {
            switch musicAuthorizationStatus {
                case .notDetermined:
                    return "Continue"
                case .denied:
                    return "Open Settings"
                default:
                    fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
            }
        }
        
        var explanatoryText: String {
            switch musicAuthorizationStatus {
                case .restricted:
                    return "Music Albums cannot be used on this iPhone because usage of Apple Music is restricted."
                default:
                    return "Music Albums uses Apple Music\nto help you rediscover your music."
            }
        }
        
        var secondaryExplanatoryText: String? {
            switch musicAuthorizationStatus {
                case .denied:
                    return "Please grant Music Albums access to Apple Music in Settings."
                default:
                    return nil
            }
        }
        
        func handleButtonPressed() {
            switch musicAuthorizationStatus {
                case .notDetermined:
                    Task {
                        let musicAuthorizationStatus = await MusicAuthorization.request()
                        await update(with: musicAuthorizationStatus)
                    }
                case .denied:
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                default:
                    fatalError("No button should be displayed for current authorization status: \(musicAuthorizationStatus).")
            }
        }
        
        @MainActor
        private func update(with musicAuthorizationStatus: MusicAuthorization.Status) {
            self.musicAuthorizationStatus = musicAuthorizationStatus
        }
    }
}
