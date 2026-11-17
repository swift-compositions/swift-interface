#if Dependencies
    import Issue_Reporting

    /// Fallbacks for an operation a test does not expect to be called. Every use reports an issue.
    /// Only output shapes with a lawful empty value have a fallback; domain values and typed errors
    /// are never invented, so any other operation needs an explicit test implementation.
    public enum Unimplemented {}

    extension Unimplemented {
        public static func value<Failure: Swift.Error>(output: Void.Type, failure: Failure.Type, operation: String) throws(Failure) {
            report(operation)
        }

        public static func value<Element>(
            output: AsyncThrowingStream<Element, any Swift.Error>.Type,
            failure: Never.Type,
            operation: String
        ) -> AsyncThrowingStream<Element, any Swift.Error> {
            report(operation)
            return AsyncThrowingStream { $0.finish() }
        }

        public static func value<Element>(
            output: AsyncStream<Element>.Type,
            failure: Never.Type,
            operation: String
        ) -> AsyncStream<Element> {
            report(operation)
            return AsyncStream { $0.finish() }
        }

        private static func report(_ operation: String) {
            Test.Issue.Reporter.report(Test.Issue(kind: .unconditional("Unimplemented interface operation: \(operation)")))
        }
    }
#endif
