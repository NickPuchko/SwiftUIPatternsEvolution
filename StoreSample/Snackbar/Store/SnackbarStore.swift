import Store

typealias SnackbarStore = Store<SnackbarState, DummyEffectHandler<SnackbarState>>

extension SnackbarStore {
    convenience init() {
        self.init(state: SnackbarState(mode: .dismissed))
    }
}
