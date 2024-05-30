struct CitySuggest: Identifiable, Equatable {
    let title: String

    var id: String {
        title
    }
}
