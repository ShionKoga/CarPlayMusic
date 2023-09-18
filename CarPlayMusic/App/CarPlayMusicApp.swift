import SwiftUI

@main
struct CarPlayMusicApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
    }
}
