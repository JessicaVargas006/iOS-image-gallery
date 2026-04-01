import Foundation

class DataModel: ObservableObject {
    @Published var items: [Item] = []

    init() {
        var loadedURLs: [URL] = []

        if let documentDirectory = FileManager.default.documentDirectory {
            let urls = FileManager.default.getContentsOfDirectory(documentDirectory)
                .filter { $0.isImage }
            loadedURLs.append(contentsOf: urls)
        }

        // Support bundled sample images and any custom JPGs Jessica drops into the package resources.
        if let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: nil) {
            loadedURLs.append(contentsOf: urls)
        }
        if let urls = Bundle.main.urls(forResourcesWithExtension: "jpeg", subdirectory: nil) {
            loadedURLs.append(contentsOf: urls)
        }
        if let urls = Bundle.main.urls(forResourcesWithExtension: "png", subdirectory: nil) {
            loadedURLs.append(contentsOf: urls)
        }


        // De-duplicate in case a resource appears in multiple searches.
        var seen = Set<String>()
        items = loadedURLs.compactMap { url in
            let key = url.absoluteString
            guard !seen.contains(key) else { return nil }
            seen.insert(key)
            return Item(url: url)
        }
    }

    /// Adds an item to the data collection.
    func addItem(_ item: Item) {
        items.insert(item, at: 0)
    }

    /// Removes an item from the data collection.
    func removeItem(_ item: Item) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
            FileManager.default.removeItemFromDocumentDirectory(url: item.url)
        }
    }
}

extension URL {
    /// Indicates whether the URL has a file extension corresponding to a common image format.
    var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "heic"]
        return imageExtensions.contains(self.pathExtension.lowercased())
    }
}
