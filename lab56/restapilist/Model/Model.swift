import Foundation
import SwiftData

@MainActor
class DataModel {
    private let repository: Repository
    var cards: [CardInfoEntity] = []

    init(context: ModelContext) {
        self.repository = Repository(modelContext: context)
    }

    func search(film: String, isOnline: Bool) async {
        do {
            cards = try await repository.getCards(
                byFilm: film,
                isNetworkAvailable: isOnline
            )
        } catch {
            print(error)
        }
    }
}
