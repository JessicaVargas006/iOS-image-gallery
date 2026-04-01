/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct GridItemView: View {
    let size: Double
    let item: Item

    private var displayName: String {
        item.url.deletingPathExtension().lastPathComponent
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "([a-z])([A-Z])", with: "$1 $2", options: .regularExpression)
            .split(separator: " ")
            .map { String($0).capitalized }
            .joined(separator: " ")
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: item.url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        Color.gray.opacity(0.12)
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    }
                default:
                    ZStack {
                        Color.gray.opacity(0.08)
                        ProgressView()
                    }
                }
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(.white.opacity(0.25), lineWidth: 1)
            }

            LinearGradient(
                colors: [.clear, .black.opacity(0.60)],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(displayName)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text("Tap for recipe")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(10)
        }
        .shadow(radius: 4, y: 2)
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        if let url = Bundle.main.url(forResource: "bobcat", withExtension: "jpg") {
            GridItemView(size: 120, item: Item(url: url))
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}
