
//  Regex.swift
//  Regex
//
//  Created by Omar Abdelhafith on 13/11/2016.
//
//

/// Regex structure
public struct Regex {

    /// The regex pattern
    public let pattern: String

    let internalRegex: __Regex

    /// Initialize a Regex matcher with a pattern
    ///
    /// - parameter pattern: the pattern to try to match
    ///
    /// - throws: a RegexError error if the pattern is incorrect
    ///
    /// - returns: a regex matcher instance
    public init(pattern: String, options: RegexOptions = .extended) throws {
        self.pattern = pattern
        self.internalRegex = try __Regex(pattern: pattern, options: options)
    }

    /// Matches a string against the regex pattern
    ///
    /// - parameter string: the string to match
    ///
    /// - returns: true if matched, otherwise false
    public func matches(_ string: String, options: MatchOptions = []) -> Bool {
        return internalRegex.matches(string, options: options)
    }

    /// Return the list of captures for the passed string
    ///
    /// - parameter string: the string to get the captures
    ///
    /// - returns: a list of Capture result instances
    public func captures(string: String) -> [CaptureResult] {
        return internalRegex.groups(string).map {
            CaptureResult(originalString: string, startIndex: $0.0, endIndex: $0.1)
        }
    }

}

/// MARK: operator

/// Matches the string the regex on the right with on the left
///
/// - parameter string: string to match
/// - parameter regex:  regex to match
///
/// - returns: true if it matches otherwise false
public func ~= (regex: Regex, string: String) -> Bool {
    return regex.matches(string)
}


/// Matches the string on the left with the regex on the right
///
/// - parameter string: string to match
/// - parameter regex:  regex to match
///
/// - returns: true if it matches otherwise false
public func ~= (string: String, regex: Regex) -> Bool {
    return regex.matches(string)
}
