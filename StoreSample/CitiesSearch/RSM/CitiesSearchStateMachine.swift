import Combine
import Foundation

@MainActor
final class CitiesSearchStateMachine: ObservableObject {
    // MARK: - State

    @Published private(set) var listState: CitiesListState
    @Published private(set) var prompt: String
    @Published private var cachedSuggests: [CitySuggest]

    let reactiveService: CitiesSearchReactiveService

    // MARK: - Effect

    private var fetchRequestSignal = PassthroughSubject<Void, Never>()
    var fetchRequestPublisher: AnyPublisher<Void, Never> {
        fetchRequestSignal.eraseToAnyPublisher()
    }

    private var promptUpdatedSignal = PassthroughSubject<String, Never>()
    var promptUpdatedPublisher: AnyPublisher<String, Never> {
        promptUpdatedSignal.eraseToAnyPublisher()
    }

    private var onDoSomethingImpossibleTappedSignal = PassthroughSubject<Void, Never>()
    var onDoSomethingImpossibleTappedPublisher: AnyPublisher<Void, Never> {
        onDoSomethingImpossibleTappedSignal.eraseToAnyPublisher()
    }

    init(
        listState: CitiesListState = .loading,
        prompt: String = "",
        cachedSuggests: [CitySuggest] = [],
        reactiveService: CitiesSearchReactiveService
    ) {
        self.listState = listState
        self.prompt = prompt
        self.cachedSuggests = cachedSuggests
        self.reactiveService = reactiveService
    }
}

extension CitiesSearchStateMachine: Executer {
    enum Action {
        // MARK: - Input

        case onAppear
        case onRefresh
        case promptUpdated(String)
        case onDoSomethingImpossibleTapped

        // MARK: - Feedback

        case suggestsDownloaded([CitySuggest])
        case suggestsFetchingFailed
    }

    func execute(action: Action) async {
        switch action {
        case .onAppear, .onRefresh:
            listState = .loading
            fetchRequestSignal.send()

        case let .promptUpdated(prompt):
            guard prompt != self.prompt else { return }
            self.prompt = prompt
            updateFilteredSuggests()
            promptUpdatedSignal.send(prompt)

        case .onDoSomethingImpossibleTapped:
            onDoSomethingImpossibleTappedSignal.send()

        case let .suggestsDownloaded(suggests):
            cachedSuggests = suggests
            updateFilteredSuggests()

        case .suggestsFetchingFailed:
            listState = .error
        }
    }
}

private extension CitiesSearchStateMachine {
    func updateFilteredSuggests() {
        let filteredSuggests = prompt.isEmpty
            ? cachedSuggests
            : cachedSuggests.filter { $0.title.contains(prompt) }
        listState = filteredSuggests.isEmpty
            ? .empty
            : .elements(filteredSuggests)
    }
}
