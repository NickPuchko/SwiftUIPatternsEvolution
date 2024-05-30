import SwiftUI

struct MVVMCitiesSearchContainer: View {
    @StateObject private var viewModel: CitiesSearchViewModel
    @StateObject private var snackbarViewModel: SnackbarViewModel

    init(
        viewModel: @MainActor @escaping @autoclosure () -> CitiesSearchViewModel,
        snackbarViewModel: @MainActor @escaping @autoclosure () -> SnackbarViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        _snackbarViewModel = StateObject(wrappedValue: snackbarViewModel())
    }

    var body: some View {
        CitiesSearchView(model: model)
            .snackbar(
                snackbarViewModel.mode,
                onTapped: {
                    snackbarViewModel.onTapped()
                }
            )
            .onAppear {
                viewModel.delegate = snackbarViewModel
                viewModel.onAppear()
            }
    }

    private var model: CitiesSearchView.Model {
        CitiesSearchView.Model(
            listState: viewModel.listState,
            prompt: viewModel.prompt,
            onTextChanged: { text in
                viewModel.promptUpdated(text)
            },
            onRefresh: {
                viewModel.onRefresh()
            },
            onDoSomethingImpossibleTapped: {
                viewModel.onDoSomethingImpossibleTapped()
            }
        )
    }
}
