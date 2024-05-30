public protocol EffectHandler<S> {
    associatedtype S: State
    func handle(effect: S.Effect) async -> S.Feedback?
}
