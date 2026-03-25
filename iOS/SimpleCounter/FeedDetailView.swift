import SwiftUI
import SharedTypes

struct FeedDetailView: View {
    @ObservedObject var core: Core
    let viewModel: FeedDetailViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.episodes, id: \.id) { episode in
                HStack {
                    VStack(alignment: .leading) {
                        Text(episode.title)
                            .font(.headline)
                        Text(episode.duration)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        core.update(.navigateToLibrary)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}
