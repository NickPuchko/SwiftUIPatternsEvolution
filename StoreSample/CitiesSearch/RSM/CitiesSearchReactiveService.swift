import Combine

final class CitiesSearchReactiveService {
    // MARK: - Dependencies

    private let networkService: DummyNetworkService
    private let logger: DummyLogger
    weak var delegate: CitiesSearchDelegate?

    private var fetchRequestSubscription: Cancellable?
    private var promptUpdatedSubscription: Cancellable?
    private var somethingImpossibleTappedSubscription: Cancellable?

    init(
        networkService: DummyNetworkService,
        logger: DummyLogger
    ) {
        self.networkService = networkService
        self.logger = logger
    }

    @MainActor
    func bind(_ stateMachine: CitiesSearchStateMachine, to delegate: CitiesSearchDelegate) {
        fetchRequestSubscription = stateMachine.fetchRequestPublisher.sink { [weak self] in
            Task {
                guard let self else { return }
                let result = await self.networkService.getSuggests()
                switch result {
                case let .success(values):
                    self.logger.log("Loaded suggests: \(values.count)")
                    await stateMachine.execute(action: .suggestsDownloaded(values))
                case let .failure(failure):
                    self.logger.log("Log error: \(failure)")
                    delegate.onFetchFailed()
                    await stateMachine.execute(action: .suggestsFetchingFailed)
                }
            }
        }

        promptUpdatedSubscription = stateMachine.promptUpdatedPublisher.sink { [weak self] prompt in
            guard let self else { return }
            logger.log("Prompt updated: \(prompt)")
        }

        somethingImpossibleTappedSubscription = stateMachine.onDoSomethingImpossibleTappedPublisher
            .sink { [weak self] in
                guard let self else { return }
                logger.log("Something impossible happened")
                delegate.onSomethingImpossibleHappened()
            }
    }
}
