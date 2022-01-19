import XCTest
@testable import ConcurrentIteration

final class ConcurrentIterationTests: XCTestCase {
	let strings = ["Allotrope", "DocThing", "Hello, World", "Heartbreaker", "two"]
	var mapped: [Int] {
		strings.map({ $0.count })
	}

	var sum: Int {
		var addition = 0
		strings.forEach({ addition += $0.count })
		return addition
	}
    func testConcurrentIteration() async throws {
		let asyncMapped = await strings.asyncMap({ $0.count })

        XCTAssertEqual(mapped, asyncMapped)
    }

	func testConcurrentMap() async throws {
		let concurrentMapped = await strings.concurrentMap({ $0.count })

		XCTAssertEqual(mapped, concurrentMapped)
	}

	func testAsyncForEach() async throws {
		var addition = 0
		await strings.asyncForEach({ addition += $0.count })

		XCTAssertEqual(sum, addition)
	}

	func testConcurrentForEach() async throws {
		var addition = 0
		await strings.concurrentForEach({ addition += $0.count })

		XCTAssertEqual(sum, addition)
	}
}
