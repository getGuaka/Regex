//
//  StringExtensions.swift
//  Regex
//
//  Created by Omar Abdelhafith on 14/11/2016.
//
//

extension String {

    public func replacing(pattern: String, withString string: String) -> String {
        guard let regex = try? Regex(pattern: "(\(pattern))") else {
            return self
        }

        return regex.captures(string: self).reversed().reduce(self) { acc, capture in
            return acc.replacing(range: capture.range, withString: string)
        }
    }


    public func replacing(range: Range<String.Index>, withString string: String) -> String {
        let firstPart = self[self.startIndex..<range.lowerBound]
        let secondPart = self[range.upperBound..<self.endIndex]
        return "\(firstPart)\(string)\(secondPart)"
    }
}
