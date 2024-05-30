import SwiftUI

struct RSMCitiesSearchContainer: View {
    @StateObject private var stateMachine: CitiesSearchStateMachine
    @StateObject private var snackbarStateMachine: SnackbarStateMachine

    init(
        stateMachine: @MainActor @escaping @autoclosure () -> CitiesSearchStateMachine,
        snackbarStateMachine: @MainActor @escaping @autoclosure () -> SnackbarStateMachine
    ) {
        _stateMachine = StateObject(wrappedValue: stateMachine())
        _snackbarStateMachine = StateObject(wrappedValue: snackbarStateMachine())
    }

    var body: some View {
        CitiesSearchView(model: model)
            .snackbar(
                snackbarStateMachine.mode,
                onTapped: {
                    snackbarStateMachine.execute(action: .onTapped)
                }
            )
            .onAppear {
                stateMachine.reactiveService.bind(stateMachine, to: snackbarStateMachine)
                stateMachine.execute(action: .onAppear)
            }
    }

    private var model: CitiesSearchView.Model {
        CitiesSearchView.Model(
            listState: stateMachine.listState,
            prompt: stateMachine.prompt,
            onTextChanged: { text in
                stateMachine.execute(action: .promptUpdated(text))
            },
            onRefresh: {
                stateMachine.execute(action: .onRefresh)
            },
            onDoSomethingImpossibleTapped: {
                stateMachine.execute(action: .onDoSomethingImpossibleTapped)
            }
        )
    }
}
