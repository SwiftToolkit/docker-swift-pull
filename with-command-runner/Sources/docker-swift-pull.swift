import Command
import Darwin

@main
struct DockerSwiftPull {
    let runner: CommandRunning

    static func main() async throws {
        try await Self(runner: CommandRunner()).run()
    }

    func run() async throws {
        let swiftVersion = try await swiftVersion()
        print("Swift version: \(swiftVersion)")

        do {
            try await pullDockerImage(swiftVersion: swiftVersion)
        } catch CommandError.executableNotFound {
            print("Docker is not available, install it before running this tool.")
            exit(1)
        } catch {
            print("Error: \(error)")
            exit(1)
        }
    }

    func swiftVersion() async throws -> String {
        try await runner
            .run(arguments: ["swift", "--version"])
            .concatenatedString()
            .extractSwiftVersion()
    }

    func pullDockerImage(swiftVersion: String) async throws {
        let arguments = ["docker", "pull", "swift:\(swiftVersion)-amazonlinux2"]
        for try await output in runner.run(arguments: arguments) {
            guard let outputString = output.string() else { return }

            if output.isError {
                print("Error: \(outputString)")
            }

            print(outputString)
        }
    }
}
