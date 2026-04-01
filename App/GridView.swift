/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct GridView: View {
    @EnvironmentObject var dataModel: DataModel

    private static let initialColumns = 3
    @State private var isAddingPhoto = false
    @State private var isEditing = false

    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: initialColumns)

    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }

    var body: some View {
        VStack(spacing: 0) {
            if isEditing {
                ColumnStepper(title: columnsTitle, range: 1...8, columns: $gridColumns)
                    .padding()
            }

            if dataModel.items.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "wineglass")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    Text("No cocktails yet")
                        .font(.headline)
                    Text("Tap + to add cocktail photos, then tap a card to see the recipe.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
            } else {
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 12) {
                        ForEach(dataModel.items) { item in
                            GeometryReader { geo in
                                NavigationLink(destination: DetailView(item: item)) {
                                    GridItemView(size: geo.size.width, item: item)
                                }
                                .buttonStyle(.plain)
                            }
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(alignment: .topTrailing) {
                                if isEditing {
                                    Button {
                                        withAnimation {
                                            dataModel.removeItem(item)
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, .red)
                                            .shadow(radius: 2)
                                    }
                                    .offset(x: 6, y: -6)
                                }
                            }
                        }
                    }
                    .padding(12)
                }
            }
        }
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.08), Color.pink.opacity(0.06), Color.clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationTitle("Cocktail Recipe Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isAddingPhoto) {
            PhotoPicker()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(isEditing ? "Done" : "Manage") {
                    withAnimation { isEditing.toggle() }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isAddingPhoto = true
                } label: {
                    Label("Add Cocktail Photo", systemImage: "plus")
                        .labelStyle(.iconOnly)
                }
                .disabled(isEditing)
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
            .environmentObject(DataModel())
            .previewDevice("iPad (8th generation)")
    }
}
