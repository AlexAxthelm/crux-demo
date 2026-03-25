import SwiftUI
import SharedTypes

struct ContentView: View {
    @ObservedObject var core: Core

    var body: some View {
        switch core.view.current_screen {
        case .library(let libraryViewModel):
            LibraryView(core: core, viewModel: libraryViewModel)
        case .settings:
            SettingsView(core: core)
        case .feedDetail(let feedDetailViewModel):
            FeedDetailViewModel(core: core, viewModel: feedDetailViewModel)
        }
    }
}
