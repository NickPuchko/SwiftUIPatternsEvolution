import Foundation

final class DummyNetworkService {
    func getSuggests() async -> Result<[CitySuggest], Error> {
        try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
        return .success(
            ["Moscow", "Belgrade", "Yekaterinburg"].map {
                CitySuggest(title: $0)
            }
        )
    }
}
