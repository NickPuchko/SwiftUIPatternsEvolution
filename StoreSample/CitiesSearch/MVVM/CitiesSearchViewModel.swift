import Combine
import Foundation

@MainActor
final class CitiesSearchViewModel: ObservableObject {
    // MARK: - State

    @Published private(set) var listState: CitiesListState
    @Published private(set) var prompt: String
    @Published private var cachedSuggests: [CitySuggest]

    // MARK: - Dependencies

    private let networkService: DummyNetworkService
    private let logger: DummyLogger
    weak var delegate: CitiesSearchDelegate?

    init(
        listState: CitiesListState = .loading,
        prompt: String = "",
        cachedSuggests: [CitySuggest] = [],
        networkService: DummyNetworkService,
        logger: DummyLogger
    ) {
        self.listState = listState
        self.prompt = prompt
        self.cachedSuggests = cachedSuggests
        self.networkService = networkService
        self.logger = logger
    }

    // MARK: - Input

    func onAppear() {
        onUpdate()
    }

    func onRefresh() {
        onUpdate()
    }

    func promptUpdated(_ prompt: String) {
        guard prompt != self.prompt else { return }
        self.prompt = prompt
        updateFilteredSuggests()
        promptUpdatedEffect(prompt)
    }

    func onDoSomethingImpossibleTapped() {
        Task {
            await onDoSomethingImpossibleTappedEffect()
        }
    }

    // MARK: - Feedback

    private func suggestsDownloaded(_ suggests: [CitySuggest]) {
        cachedSuggests = suggests
        updateFilteredSuggests()
    }

    private func suggestsFetchingFailed() {
        listState = .error
    }

    // MARK: - Effect

    private func fetchRequestEffect() async {
        let result = await networkService.getSuggests()
        switch result {
        case let .success(values):
            logger.log("Loaded suggests: \(values.count)")
            suggestsDownloaded(values)
        case let .failure(failure):
            logger.log("Log error: \(failure)")
            delegate?.onFetchFailed()
            suggestsFetchingFailed()
        }
    }

    private func promptUpdatedEffect(_ prompt: String) {
        logger.log("Prompt updated: \(prompt)")
    }

    private func onDoSomethingImpossibleTappedEffect() async {
        logger.log("Something impossible happened")
        delegate?.onSomethingImpossibleHappened()
    }
}

private extension CitiesSearchViewModel {
    func updateFilteredSuggests() {
        let filteredSuggests = prompt.isEmpty
            ? cachedSuggests
            : cachedSuggests.filter { $0.title.contains(prompt) }
        listState = filteredSuggests.isEmpty
            ? .empty
            : .elements(filteredSuggests)
    }

    func onUpdate() {
        listState = .loading
        Task {
            await fetchRequestEffect()
        }
    }
}
