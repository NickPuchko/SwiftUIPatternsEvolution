import Combine

@MainActor
@dynamicMemberLookup
public final class Store<S, EH>: ObservableObject where
    S: State,
    EH: EffectHandler<S>
{
    public typealias Reduce = (inout S, Message<S.Input, S.Feedback>) -> S.Effect?

    @Published public private(set) var state: S
    public let effectHandler: EH
    private let reduce: Reduce
    private var tasks: [Task<Void, Error>] = []

    public init(
        state: S,
        effectHandler: EH
    ) {
        self.state = state
        self.effectHandler = effectHandler
        self.reduce = S.reduce
    }

    public subscript<Value>(dynamicMember keypath: KeyPath<S, Value>) -> Value {
        state[keyPath: keypath]
    }

    public func send(_ message: S.Input) {
        send(.input(message))
    }

    private func send(_ message: Message<S.Input, S.Feedback>) {
        var updatedState = state
        let effect = reduce(&updatedState, message)
        if state != updatedState {
            state = updatedState
        }

        let task = Task {
            guard let effect,
                  let feedback = await effectHandler.handle(effect: effect)
            else {
                return
            }
            try Task.checkCancellation()
            send(.feedback(feedback))
        }
        tasks.append(task)
    }

    deinit {
        for task in tasks {
            task.cancel()
        }
    }
}
