import SharedTypes
import SwiftUI

struct SettingsView: View {
    @ObservedObject var core: Core

    var body: some View {
        NavigationStack {
            Text("Settings coming soon")
                .foregroundStyle(.secondary)
                .navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            core.update(.navigateToLibrary)
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
        }
    }
}
