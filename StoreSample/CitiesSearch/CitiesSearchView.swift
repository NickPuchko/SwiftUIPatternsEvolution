import SwiftUI

struct CitiesSearchView: View {
    let model: Model

    var body: some View {
        VStack {
            TextField(
                "Type to search...",
                text: Binding(
                    get: { model.prompt },
                    set: model.onTextChanged
                )
            )
            .padding()
            Button("Do something impossible", action: model.onDoSomethingImpossibleTapped)
            switch model.listState {
            case let .elements(suggests):
                List(suggests) { suggest in
                    Text(suggest.title)
                }
                .listStyle(.inset)
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case .error:
                Text("Error")
            case .empty:
                Text("Empty list")
            }
            Spacer()
        }
        .refreshable(action: model.onRefresh)
        .animation(.default, value: model.listState)
    }
}
