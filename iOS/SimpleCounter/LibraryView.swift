import SwiftUI
import SharedTypes

struct LibraryView: View {
    @ObservedObject var core: Core
    let viewModel: LibraryViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.feeds, id: \.id) { feed in
                Button {
                    core.update(.navigateToFeedDetail(feed.id))
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(feed.title)
                                .font(.headline)
                                Text("\(feed.episode_count) episodes")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        core.update(.navigateToSettings)
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}
