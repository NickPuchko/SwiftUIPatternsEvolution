extension CitiesSearchView.Model {
    static func fixture() -> Self {
        CitiesSearchView.Model(
            listState: .empty,
            prompt: "",
            onTextChanged: { _ in },
            onRefresh: {},
            onDoSomethingImpossibleTapped: {}
        )
    }
}
