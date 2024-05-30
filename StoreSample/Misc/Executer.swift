import Foundation

public protocol Executer {
    associatedtype Action
    func execute(action: Action) async
}

public extension Executer {
    @discardableResult
    func execute(action: Action) -> Task<Void, Never> {
        Task { @MainActor in
            await execute(action: action)
        }
    }
}
