import SharedTypes
import SwiftUI

struct ContentView: View {
    @ObservedObject var core: Core

    var body: some View {
        switch core.view.current_screen {
        case let .library(libraryViewModel):
            LibraryView(core: core, viewModel: libraryViewModel)
        case .settings:
            SettingsView(core: core)
        case let .feedDetail(feedDetailViewModel):
            FeedDetailView(core: core, viewModel: feedDetailViewModel)
        }
    }
}
