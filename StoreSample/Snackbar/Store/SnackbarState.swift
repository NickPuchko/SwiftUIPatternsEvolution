import Foundation
import Store

struct SnackbarState {
    var mode: SnackbarMode
}

extension SnackbarState: State {
    enum Input {
        case onTriggered(SnackbarMode)
        case onTapped
    }

    @MainActor
    static func reduce(
        state: inout Self,
        with message: Message<Input, Feedback>
    ) -> Effect? {
        switch message {
        case let .input(.onTriggered(mode)):
            state.mode = mode
        case .input(.onTapped):
            state.mode = .dismissed
        }

        return nil
    }
}
