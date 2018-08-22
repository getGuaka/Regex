//
//  CaptureResult.swift
//  Regex
//
//  Created by Omar Abdelhafith on 13/11/2016.
//
//

/// Capture result strucute representing a captured result
public struct CaptureResult {

    /// The start index captures
    public let startIndex: String.Index

    /// The end index captures
    public let endIndex: String.Index

    /// The original string containing the captured string
    public let originalString: String

    /// The captured string
    public var string: String {
        return internalValue.string
    }

    /// Closed range of the capture
    public var range: Range<String.Index> {
        return startIndex..<endIndex
    }

    private let internalValue: InternalCapture

    init(originalString: String, startIndex: String.Index, endIndex: String.Index) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.originalString = originalString

        self.internalValue = InternalCapture(originalString: originalString,
                                             startIndex: startIndex,
                                             endIndex: endIndex)
    }

}


extension CaptureResult {

    fileprivate class InternalCapture {

        let startIndex: String.Index
        let endIndex: String.Index
        let originalString: String

        lazy var string: String = {
            return String(self.originalString[self.startIndex..<self.endIndex])
        }()

        init(originalString: String, startIndex: String.Index, endIndex: String.Index) {
            self.originalString = originalString
            self.startIndex = startIndex
            self.endIndex = endIndex
        }
    }

}
