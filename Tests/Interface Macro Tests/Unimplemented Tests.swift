#if Dependencies
    import Interface_Dependencies
    import Issue_Reporting
    import Synchronization
    import Testing

    @Test private func `every unimplemented fallback reports one issue naming the operation`() async {
        let reported = Mutex<[String]>([])
        unsafe Test.Issue.Reporter.record = { issue in reported.withLock { $0.append(issue.description) } }
        Unimplemented.value(output: Void.self, failure: Never.self, operation: "save")
        for await _ in Unimplemented.value(output: AsyncStream<Int>.self, failure: Never.self, operation: "values") {}
        var finished = false
        let stream = Unimplemented.value(output: AsyncThrowingStream<Int, any Swift.Error>.self, failure: Never.self, operation: "events")
        do throws(any Swift.Error) {
            for try await _ in stream {}
            finished = true
        } catch {}
        unsafe Test.Issue.Reporter.record = nil
        #expect(finished)
        #expect(
            reported.withLock { $0 } == [
                "Unconditional failure: Unimplemented interface operation: save",
                "Unconditional failure: Unimplemented interface operation: values",
                "Unconditional failure: Unimplemented interface operation: events",
            ]
        )
    }
#endif
