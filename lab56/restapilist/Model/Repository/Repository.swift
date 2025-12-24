import Foundation
import SwiftData

class Repository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getCards(byFilm film: String, isNetworkAvailable: Bool) async throws -> [CardInfoEntity] {

        // 1️⃣ Ищем в БД
        let localCards = loadFromDatabase(film: film)
        if !localCards.isEmpty {
            print("Найдено в БД: \(localCards.count)")
            return localCards
        }

        // 2️⃣ Если нет интернета — всё
        guard isNetworkAvailable else { return [] }

        // 3️⃣ Загружаем из сети
        let networkCards = try await fetchFromNetwork(film: film)

        // 4️⃣ Фильтрация по фильму
        let filtered = networkCards.filter {
            $0.films?.localizedCaseInsensitiveContains(film) == true
        }

        return filtered
    }

    // MARK: - Local DB

    private func loadFromDatabase(film: String) -> [CardInfoEntity] {
        let descriptor = FetchDescriptor<CardInfoEntity>()
        let all = (try? modelContext.fetch(descriptor)) ?? []

        return all.filter {
            $0.films?.localizedCaseInsensitiveContains(film) == true
        }
    }

    // MARK: - Network

    private func fetchFromNetwork(film: String) async throws -> [CardInfoEntity] {
        let url = URL(string: "https://api.disneyapi.dev/character?films=\(film)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        let wrapper = try JSONDecoder().decode(CardInfoWrapper.self, from: data)

        var result: [CardInfoEntity] = []

        for card in wrapper.data {
            let imageData = try? await downloadImage(card.imageUrl)

            let entity = CardInfoEntity(
                id: card._id,
                name: card.name,
                url: card.url,
                imageData: imageData,
                imageUrl: card.imageUrl,
                films: card.films?.joined(separator: ", ")
            )

            modelContext.insert(entity)
            result.append(entity)
        }

        try modelContext.save()
        return result
    }

    private func downloadImage(_ urlString: String?) async throws -> Data? {
        guard let urlString,
              let url = URL(string: urlString) else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
