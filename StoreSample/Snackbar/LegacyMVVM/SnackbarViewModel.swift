import Combine
import Foundation

@MainActor
class SnackbarViewModel: ObservableObject {
    // MARK: - State

    @Published private(set) var mode: SnackbarMode

    init(mode: SnackbarMode = .dismissed) {
        self.mode = mode
    }

    // MARK: - Input

    func onTriggered(_ mode: SnackbarMode) {
        self.mode = mode
    }

    func onTapped() {
        mode = .dismissed
    }
}
