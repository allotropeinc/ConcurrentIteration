import Foundation

// Credit to https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map/

extension Sequence {
	public func asyncMap<T>(
		_ transform: (Element) async throws -> T
	) async rethrows -> [T] {
		var values = [T]()

		for element in self {
			try await values.append(transform(element))
		}

		return values
	}
}

extension Sequence {
	public func concurrentMap<T>(
		_ transform: @escaping (Element) async throws -> T
	) async rethrows -> [T] {
		let tasks = map { element in
			Task {
				try await transform(element)
			}
		}

		return try await tasks.asyncMap { task in
			try await task.value
		}
	}
}

extension Sequence {
	public func asyncForEach(
		_ operation: (Element) async throws -> Void
	) async rethrows {
		for element in self {
			try await operation(element)
		}
	}
}

extension Sequence {
	public func concurrentForEach(
		_ operation: @escaping (Element) async throws -> Void
	) async rethrows {
		// A task group automatically waits for all of its
		// sub-tasks to complete, while also performing those
		// tasks in parallel:
		await withThrowingTaskGroup(of: Void.self) { group in
			for element in self {
				group.addTask {
					try await operation(element)
				}
			}
		}
	}
}
