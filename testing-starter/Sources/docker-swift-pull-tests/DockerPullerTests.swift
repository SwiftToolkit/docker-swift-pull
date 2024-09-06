import Command
import XCTest
import Path
@testable import docker_swift_pull

final class DockerPullerTests: XCTestCase {
    func test_no_docker() async throws {
        let puller = DockerPuller(runner: MockCommandRunner())
        await XCTAssertThrowsErrorAsync(try await puller.pullImage(named: "any-image")) { error in
            guard let error = error as? DockerPuller.Error else {
                XCTFail("DockerPuller should have thrown a DockerPuller.Error")
                return
            }

            XCTAssertEqual(error, .dockerUnavailable)
        }
    }
}

private struct MockCommandRunner: CommandRunning {
    func run(
        arguments: [String],
        environment: [String : String],
        workingDirectory: AbsolutePath?
    ) -> AsyncThrowingStream<Command.CommandEvent, any Error> {
        .init { continuation in
            if arguments.first == "docker" {
                continuation.finish(throwing: CommandError.executableNotFound("docker"))
            }

            continuation.finish()
        }
    }
}

func XCTAssertThrowsErrorAsync<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        XCTFail(message())
    } catch {
        errorHandler(error)
    }
}
