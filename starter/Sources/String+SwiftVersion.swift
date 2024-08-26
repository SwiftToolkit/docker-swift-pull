import Foundation
import RegexBuilder

extension String {
    func extractSwiftVersion() throws -> String {
        let regex = Regex {
            "Swift version "
            Capture {
                OneOrMore(.digit)
                "."
                OneOrMore(.digit)
            }
        }

        guard let match = firstMatch(of: regex) else {
            throw Error(input: self)
        }

        return String(match.output.1)
    }
}

private struct Error: Swift.Error, LocalizedError {
    let input: String

    var errorDescription: String? {
        "Swift version could not be found from \"\(input)\""
    }
}
