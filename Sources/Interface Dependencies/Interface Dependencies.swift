#if Dependencies
    import IssueReporting

    /// Every use reports an issue. Only explicitly supported output shapes have
    /// fallback values; arbitrary domain values and typed errors are never invented.
    public enum Unimplemented {
        private struct Failure: Swift.Error {}

        public static func value<Output: ~Copyable, Failure: Swift.Error>(
            output: Output.Type,
            failure: Failure.Type,
            operation: String
        ) throws(Failure) -> Output {
            reportIssue("Unimplemented interface operation: \(operation)")
            if let error = Unimplemented.Failure() as? Failure { throw error }
            fatalError("Provide an explicit test implementation for \(operation); no lawful fallback exists")
        }

        public static func value<Failure: Swift.Error>(output: Void.Type, failure: Failure.Type, operation: String) throws(Failure) {
            reportIssue("Unimplemented interface operation: \(operation)")
        }

        public static func value<Element>(
            output: AsyncThrowingStream<Element, any Swift.Error>.Type,
            failure: Never.Type,
            operation: String
        ) -> AsyncThrowingStream<Element, any Swift.Error> {
            reportIssue("Unimplemented interface operation: \(operation)")
            return AsyncThrowingStream { $0.finish() }
        }

        public static func value<Element>(
            output: AsyncStream<Element>.Type,
            failure: Never.Type,
            operation: String
        ) -> AsyncStream<Element> {
            reportIssue("Unimplemented interface operation: \(operation)")
            return AsyncStream { $0.finish() }
        }
    }
#endif
