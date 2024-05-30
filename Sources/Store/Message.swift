public enum Message<Input, Feedback>: Sendable where Input: Sendable, Feedback: Sendable {
    case input(Input)
    case feedback(Feedback)
}
