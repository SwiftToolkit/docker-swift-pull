import Command
import XCTest
import Path
import Mockable
@testable import docker_swift_pull

final class DockerPullerTests: XCTestCase {
    func test_no_docker() async throws {
        let mockRunner = MockCommandRunning()
        given(mockRunner)
            .run(
                arguments: .matching { args in args.first == "docker" },
                environment: .any,
                workingDirectory: .any
            )
            .willReturn(AsyncThrowingStream<CommandEvent, Error> {
                throw CommandError.executableNotFound("docker")
            })

        let puller = DockerPuller(runner: mockRunner)
        await XCTAssertThrowsErrorAsync(try await puller.pullImage(named: "any-image")) { error in
            guard let error = error as? DockerPuller.Error else {
                XCTFail("DockerPuller should have thrown a DockerPuller.Error")
                return
            }

            XCTAssertEqual(error, .dockerNotInstalled)
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
