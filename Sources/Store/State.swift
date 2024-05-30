public protocol State<Input, Feedback, Effect>: Equatable {
    associatedtype Input = Never
    associatedtype Feedback = Never
    associatedtype Effect = Never

    static func reduce(
        state: inout Self,
        with message: Message<Input, Feedback>
    ) -> Effect?
}
