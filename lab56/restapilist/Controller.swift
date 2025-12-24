import Foundation
import SwiftData
import Network

@MainActor
class Controller: ObservableObject {

    @Published var cards: [CardInfoEntity] = []
    @Published var searchText: String = ""
    @Published var isInternetAvailable = false

    private var model: DataModel?
    private let monitor = NWPathMonitor()

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isInternetAvailable = path.status == .satisfied
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }

    func setContext(_ context: ModelContext) {
        model = DataModel(context: context)
    }

    func search() {
        guard !searchText.isEmpty else { return }

        Task {
            try await model?.search(
                film: searchText,
                isOnline: isInternetAvailable
            )

            let result = model?.cards ?? []
            cards = []

            cards = result
        }
    }
}
