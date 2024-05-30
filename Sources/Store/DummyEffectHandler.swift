public final class DummyEffectHandler<S: State>: EffectHandler {
    public init() {}

    public func handle(effect _: S.Effect) async -> S.Feedback? {
        nil
    }
}

public extension Store {
    convenience init(state: S) where EH == DummyEffectHandler<S> {
        self.init(
            state: state,
            effectHandler: DummyEffectHandler<S>()
        )
    }
}
