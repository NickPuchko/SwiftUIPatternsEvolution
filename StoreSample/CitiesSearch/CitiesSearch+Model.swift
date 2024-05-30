import Foundation

extension CitiesSearchView {
    struct Model {
        let listState: CitiesListState
        let prompt: String
        let onTextChanged: (String) -> Void
        let onRefresh: @MainActor @Sendable () -> Void
        let onDoSomethingImpossibleTapped: () -> Void
    }
}
