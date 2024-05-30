import Foundation
import Store

final class CitiesSearchEffectHandler: EffectHandler {
    typealias S = CitiesSearchState

    private let networkService: DummyNetworkService
    private let logger: DummyLogger
    weak var delegate: CitiesSearchDelegate?

    init(
        networkService: DummyNetworkService,
        logger: DummyLogger
    ) {
        self.networkService = networkService
        self.logger = logger
    }

    func handle(effect: S.Effect) async -> S.Feedback? {
        switch effect {
        case .fetchRequest:
            let result = await networkService.getSuggests()
            switch result {
            case let .success(values):
                logger.log("Loaded suggests: \(values.count)")
                return .suggestsDownloaded(values)
            case let .failure(failure):
                logger.log("Log error: \(failure)")
                await delegate?.onFetchFailed()
                return .suggestsFetchingFailed
            }

        case let .promptUpdated(prompt):
            logger.log("Prompt updated: \(prompt)")

        case .onDoSomethingImpossibleTapped:
            logger.log("Something impossible happened")
            await delegate?.onSomethingImpossibleHappened()
        }

        return nil
    }
}
