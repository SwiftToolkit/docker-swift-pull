import Command
import Foundation

struct DockerPuller {
    let runner: CommandRunning

    func pullImage(named name: String) async throws {
        do {
            let arguments = ["docker", "pull", name]
            for try await output in runner.run(arguments: arguments) {
                guard let outputString = output.string() else { return }

                if !output.isError {
                    print(outputString)
                }
            }
        } catch CommandError.executableNotFound {
            throw Error.dockerUnavailable
        } catch {
            throw error
        }
    }

    enum Error: Swift.Error, Equatable, CustomStringConvertible {
        case dockerUnavailable

        var description: String {
            switch self {
            case .dockerUnavailable:
                "Docker is not available, install it before running this tool."
            }
        }
    }
}
