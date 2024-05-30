import SwiftUI

extension View {
    @MainActor func snackbar(
        _ mode: SnackbarMode,
        onTapped: @escaping () -> Void
    ) -> some View {
        ZStack {
            self
                .zIndex(1)
            switch mode {
            case let .presented(title):
                SnackbarView(
                    model: SnackbarView.Model(
                        title: title,
                        onTapped: onTapped
                    )
                )
                .zIndex(2)
            case .dismissed:
                EmptyView()
            }
        }
        .animation(
            .easeInOut,
            value: mode
        )
    }
}
