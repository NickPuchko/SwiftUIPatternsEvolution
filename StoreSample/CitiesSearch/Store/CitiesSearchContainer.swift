import Store
import SwiftUI

struct CitiesSearchContainer: View {
    @StateObject private var store: CitiesSearchStore
    @StateObject private var snackbarStore: SnackbarStore

    init(
        store: @MainActor @escaping () -> CitiesSearchStore,
        snackbarStore: @MainActor @escaping () -> SnackbarStore
    ) {
        _store = StateObject(wrappedValue: store())
        _snackbarStore = StateObject(wrappedValue: snackbarStore())
    }

    var body: some View {
        CitiesSearchView(model: viewModel)
            .snackbar(
                snackbarStore.mode,
                onTapped: {
                    snackbarStore.send(.onTapped)
                }
            )
            .onAppear {
                store.send(.onAppear)
            }
    }

    private var viewModel: CitiesSearchView.Model {
        CitiesSearchView.Model(
            listState: store.listState,
            prompt: store.prompt,
            onTextChanged: { text in
                store.send(.promptUpdated(text))
            },
            onRefresh: {
                store.send(.onRefresh)
            },
            onDoSomethingImpossibleTapped: {
                store.send(.onDoSomethingImpossibleTapped)
            }
        )
    }
}
