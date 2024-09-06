import Command
import Darwin

@main
struct DockerSwiftPull {
    let runner: CommandRunning

    static func main() async throws {
        // try await Self(runner: CommandRunner()).run()
        try await Self(runner: CommandRunner()).longRunningTask()
    }

    func longRunningTask() async throws {
        throw CommandError.executableNotFound("docker")
    }

    func run() async throws {
        let swiftVersion = try await swiftVersion()
        print("Swift version: \(swiftVersion)")

        do {
            let imageName = "swift:\(swiftVersion)-amazonlinux2"
            try await DockerPuller(runner: runner).pullImage(named: imageName)
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
}
