//
//  Types.swift
//  Regex
//
//  Created by Omar Abdelhafith on 13/11/2016.
//
//


/// Regex options
public struct RegexOptions: OptionSet {
  public let rawValue: Int32

  public init(rawValue: Int32) {
    self.rawValue = rawValue
  }

  public static let basic =            RegexOptions(rawValue: 0)
  public static let extended =         RegexOptions(rawValue: 1)
  public static let caseInsensitive =  RegexOptions(rawValue: 2)
  public static let resultOnly =       RegexOptions(rawValue: 8)
  public static let newLineSensitive = RegexOptions(rawValue: 4)
}


/// Match options
public struct MatchOptions: OptionSet {
  public let rawValue: Int32

  public init(rawValue: Int32) {
    self.rawValue = rawValue
  }

  public static let FirstCharacterNotAtBeginningOfLine = MatchOptions(rawValue: REG_NOTBOL)
  public static let LastCharacterNotAtEndOfLine =        MatchOptions(rawValue: REG_NOTEOL)
}
