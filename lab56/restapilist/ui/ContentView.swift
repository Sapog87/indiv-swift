import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var controller = Controller()

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Введите фильм (например: Frozen)",
                          text: $controller.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                Button("Поиск") {
                    controller.search()
                }
                .padding(.bottom)

                if controller.isInternetAvailable {
                    Text("Интернет доступен")
                        .foregroundColor(.green)
                } else {
                    Text("Нет интернета")
                        .foregroundColor(.red)
                }

                ListCards(cards: controller.cards)
            }
            .navigationTitle("Disney Search")
            .onAppear {
                controller.setContext(modelContext)
            }
        }
    }
}

struct ListCards: View {
    let cards: [CardInfoEntity]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]) {
                ForEach(cards, id: \.id) { item in
                    NavigationLink {
                        CardInfoPage(item: item)
                    } label: {
                        CardView(item: item)
                    }
                }
            }
            .padding()
        }
    }
}

struct CardView: View {
    let item: CardInfoEntity

    var body: some View {
        VStack {
            Text(item.name)
                .font(.headline)
                .lineLimit(1)

            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct CardInfoPage: View {
    let item: CardInfoEntity

    var body: some View {
        ScrollView {
            Text(item.name)
                .font(.largeTitle)

            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }

            Text(item.films ?? "")
                .padding()
        }
    }
}
