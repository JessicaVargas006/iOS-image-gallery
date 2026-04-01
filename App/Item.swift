/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let url: URL
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id
    }
}
