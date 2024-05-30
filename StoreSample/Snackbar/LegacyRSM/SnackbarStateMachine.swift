import Combine
import Foundation

@MainActor
class SnackbarStateMachine: ObservableObject {
    @Published private(set) var mode: SnackbarMode

    init(mode: SnackbarMode = .dismissed) {
        self.mode = mode
    }
}

extension SnackbarStateMachine: Executer {
    enum Action {
        case onTriggered(SnackbarMode)
        case onTapped
    }

    func execute(action: Action) async {
        switch action {
        case let .onTriggered(mode):
            self.mode = mode

        case .onTapped:
            mode = .dismissed
        }
    }
}
