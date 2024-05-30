import Foundation
import Store

struct CitiesSearchState {
    var listState: CitiesListState
    var prompt: String
    var cachedSuggests: [CitySuggest]
}

extension CitiesSearchState: State {
    enum Input {
        case onAppear
        case onRefresh
        case promptUpdated(String)
        case onDoSomethingImpossibleTapped
    }

    enum Feedback {
        case suggestsDownloaded([CitySuggest])
        case suggestsFetchingFailed
    }

    enum Effect {
        case fetchRequest
        case promptUpdated(String)
        case onDoSomethingImpossibleTapped
    }

    @MainActor
    static func reduce(
        state: inout Self,
        with message: Message<Input, Feedback>
    ) -> Effect? {
        switch message {
        case .input(.onAppear), .input(.onRefresh):
            state.listState = .loading
            return .fetchRequest

        case let .input(.promptUpdated(prompt)):
            guard prompt != state.prompt else { return nil }
            state.prompt = prompt
            state.updateFilteredSuggests()
            return .promptUpdated(prompt)

        case .input(.onDoSomethingImpossibleTapped):
            return .onDoSomethingImpossibleTapped

        case let .feedback(.suggestsDownloaded(suggests)):
            state.cachedSuggests = suggests
            state.updateFilteredSuggests()

        case .feedback(.suggestsFetchingFailed):
            state.listState = .error
        }

        return nil
    }
}

private extension CitiesSearchState {
    mutating func updateFilteredSuggests() {
        let filteredSuggests = prompt.isEmpty
            ? cachedSuggests
            : cachedSuggests.filter { $0.title.contains(prompt) }
        listState = filteredSuggests.isEmpty
            ? .empty
            : .elements(filteredSuggests)
    }
}
