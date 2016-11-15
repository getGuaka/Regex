//
//  regex.swift
//  cli
//
//  Created by Omar Abdelhafith on 23/10/2016.
//
//
// This was modified from POSIXRegex https://github.com/ZewoGraveyard/POSIXRegex/blob/master/Source/Regex.swift

// Original header comment

// Regex.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


#if os(Linux)
  @_exported import Glibc
#else
  @_exported import Darwin.C
#endif


/// Internal class that handles posix regex matching
class __Regex {
  
  var preg = regex_t()

  init(pattern: String, options: RegexOptions = .extended) throws {
    // FIXME: Nongreedy regex
    // Cross compile PCRE and link it
    let result = regcomp(&preg, pattern, options.rawValue)

    if result != 0 {
      throw RegexError.error(from: result, preg: preg)
    }
  }

  deinit {
    regfree(&preg)
  }

  func matches(_ string: String, options: MatchOptions = []) -> Bool {
    var regexMatches = [regmatch_t](repeating: regmatch_t(), count: 1)
    let result = regexec(&preg, string, regexMatches.count, &regexMatches, options.rawValue)

    if result == 1 {
      return false
    }

    return true
  }

  func groups(_ string: String, options: MatchOptions = [])
    -> [(String.Index, String.Index)] {
      let original = string
      var string = string
      let maxMatches = 20
      var groups: [(String.Index, String.Index)] = []
      var accOffset = 0

      while true {
        var regexMatches = [regmatch_t](repeating: regmatch_t(), count: maxMatches)
        let result = regexec(&preg, string, regexMatches.count, &regexMatches, options.rawValue)

        if result == 1 {
          break
        }

        var j = 1

        while regexMatches[j].rm_so != -1 {
          let start = Int(accOffset + regexMatches[j].rm_so)
          let end = Int(accOffset +   regexMatches[j].rm_eo)
          let startIndex = original.index(original.startIndex, offsetBy: start)
          let endIndex = original.index(original.startIndex, offsetBy: end)
          groups.append((startIndex, endIndex))
          j += 1
        }

        let offset = Int(regexMatches[0].rm_eo)
        accOffset += offset
        let startIndex = string.utf8.index(string.utf8.startIndex, offsetBy: offset)
        if let offsetString = String(string.utf8[startIndex ..< string.utf8.endIndex]) {
          string = offsetString
        } else {
          break
        }
      }

      return groups
  }

}

public struct RegexError: Error {
  public let description: String

  fileprivate static func error(from result: Int32, preg: regex_t) -> RegexError {
    var preg = preg
    var buffer = [Int8](repeating: 0, count: Int(BUFSIZ))
    regerror(result, &preg, &buffer, buffer.count)
    let description = String(validatingUTF8: buffer)!
    return RegexError(description: description)
  }
}
