import Store
import SwiftUI

final class RootFactory {
    lazy var networkService = DummyNetworkService()
    lazy var logger = DummyLogger()

    func makeCitiesSearchContainer() -> some View {
        lazy var effectHandler = CitiesSearchEffectHandler(
            networkService: self.networkService,
            logger: self.logger
        )

        let citiesSearchStore = { @MainActor in
            Store(effectHandler: effectHandler)
        }
        let snackbarStore = { @MainActor in
            let snackbarStore = SnackbarStore()
            effectHandler.delegate = snackbarStore
            return snackbarStore
        }

        return CitiesSearchContainer(
            store: citiesSearchStore,
            snackbarStore: snackbarStore
        )
    }
}
