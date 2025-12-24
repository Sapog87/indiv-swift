struct CardInfoWrapper: Codable {
    let data: [CardInfo]
}

struct CardInfo: Codable {
    let _id: Int
    let name: String
    let url: String
    let imageUrl: String?
    let films: [String]?
}