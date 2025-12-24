import Foundation
import SwiftData
import UIKit

@Model
class CardInfoEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var url: String
    var imageData: Data?
    var imageUrl: String?
    var films: String?

    init(
        id: Int,
        name: String,
        url: String,
        imageData: Data?,
        imageUrl: String?,
        films: String?
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.imageData = imageData
        self.imageUrl = imageUrl
        self.films = films
    }

    var image: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }
}