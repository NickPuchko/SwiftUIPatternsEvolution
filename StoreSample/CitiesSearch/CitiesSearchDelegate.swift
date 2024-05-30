@MainActor protocol CitiesSearchDelegate: AnyObject {
    func onFetchFailed()
    func onSomethingImpossibleHappened()
}

extension SnackbarStore: CitiesSearchDelegate {
    func onFetchFailed() {
        send(.onTriggered(.presented("Failed to fetch")))
    }

    func onSomethingImpossibleHappened() {
        send(.onTriggered(.presented("Something impossible happened")))
    }
}

extension SnackbarViewModel: CitiesSearchDelegate {
    func onFetchFailed() {
        onTriggered(.presented("Failed to fetch"))
    }

    func onSomethingImpossibleHappened() {
        onTriggered(.presented("Something impossible happened"))
    }
}

extension SnackbarStateMachine: CitiesSearchDelegate {
    func onFetchFailed() {
        execute(action: .onTriggered(.presented("Failed to fetch")))
    }

    func onSomethingImpossibleHappened() {
        execute(action: .onTriggered(.presented("Something impossible happened")))
    }
}
