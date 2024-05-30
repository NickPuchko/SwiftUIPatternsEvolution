import Store

typealias CitiesSearchStore = Store<CitiesSearchState, CitiesSearchEffectHandler>

extension CitiesSearchStore {
    convenience init(effectHandler: CitiesSearchEffectHandler) {
        self.init(
            state: CitiesSearchState(
                listState: .loading,
                prompt: "",
                cachedSuggests: []
            ),
            effectHandler: effectHandler
        )
    }
}
