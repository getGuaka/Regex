# Regex

[![Build Status](https://travis-ci.com/getGuaka/Regex.svg?branch=master)](https://travis-ci.com/getGuaka/Regex)
[![codecov](https://codecov.io/gh/getGuaka/Regex/branch/master/graph/badge.svg)](https://codecov.io/gh/getGuaka/Regex)
[![Platform](https://img.shields.io/badge/platform-osx-lightgrey.svg)](https://travis-ci.com/getGuaka/Regex)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.com/getGuaka/Regex)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)


## Why?

If you are developing cross platform (macOS and Linux) command line apps, and
you want to use Regular expressions, `Regex` is just what you need.

You can use `Regex` with [Guaka](https://github.com/nsomar/Guaka) to create
aweseome command line applications.

## Usage

- Checking if a string matches a pattern.

```swift
let r = try! Regex(pattern: "Hello [a-z]+ame")
r.matches("Hello Name")
```

- Capture a string with a regex capture group

```swift
let r = try! Regex(pattern: "Hello (.*) name")
let result = r.captures(string: "Hello mr name")
```

`result` is an array of `CaptureResult`

- Using the `~=` operator

```swift
// Regex ~= String
let value = try! Regex(pattern: "Hello [a-z]+ame") ~= "Hello Name"
// value is true

// String ~= Regex
let value = "Hello Name" ~= try! Regex(pattern: "Hello [a-z]+ame")
// value is true
```

- Using regex matching with switch

```swift
switch "Hello I am on swift" {
  case try! Regex(pattern: "Hello [a-z] am .*"):
    // First
  case try! Regex(pattern: ".*"):
    // Second
}
```

The first passing regex will be matched. In the example above, the first case
is matched.

### String extensions

Replace a pattern with a string:

```swift
"This string is wrong".replacing(pattern: "w.*g", withString: "right")
// "This string is right"
```

### CaptureResult

`CaptureResult` represent a captured string, it contains:

- `originalString` the original string
- `startIndex` the capture start index
- `endIndex` the capture end index 
- `range` the range of the captured string
- `string` the captured string 

### RegexOptions

`RegexOptions` optionset can be passed when initilaizing a `Regex` object.  For
a discussion on the meaning of these flags, refer to [GNU regex
documentation](http://www.gnu.org/software/libc/manual/html_node/POSIX-Regexp-Compilation.html#POSIX-Regexp-Compilation)

### MatchOptions
`matches(_:options:)` accepts the `MatchOptions` option set.  For a discussion
on the meaning of these flags, refer to [GNU regex
documentation](http://www.gnu.org/software/libc/manual/html_node/Matching-POSIX-Regexps.html#Matching-POSIX-Regexps)

## Installation
You can install Regex using Swift package manager (SPM) and carthage

### Swift Package Manager
Add Regex as dependency in your `Package.swift`

```swift
import PackageDescription

let package = Package(name: "YourPackage",
  dependencies: [
    .Package(url: "https://github.com/getGuaka/Regex.git", majorVersion: 0),
  ]
)
```

### Carthage
    github "getGuaka/Regex"

## Tests
Tests can be found [here](https://github.com/getGuaka/Regex/tree/master/Tests).

Run them with
```
swift test
```

## Contributing

Just send a PR! We don't bite ;)
