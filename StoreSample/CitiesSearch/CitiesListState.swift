enum CitiesListState: Equatable {
    case empty
    case error
    case loading
    case elements([CitySuggest])
}
