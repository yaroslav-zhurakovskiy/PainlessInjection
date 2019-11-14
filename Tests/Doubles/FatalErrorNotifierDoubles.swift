//
//  FatalErrorNotifierDoubles.swift
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 14.11.2019.
//  Copyright © 2019 Yaroslav Zhurakovskiy. All rights reserved.
//

import Foundation
import PainlessInjection
import XCTest

class FatalErrorNotifierSpy: FatalErrorNotifierProtocol {
    struct Message {
        let text: String
        let file: StaticString
        let line: UInt
    }
    
    private(set) var recordedMessags: [Message] = []
   
    var lastMessage: Message? {
        return recordedMessags.last
    }
    
    func notify(_ message: String, file: StaticString, line: UInt) {
        recordedMessags.append(Message(text: message, file: file, line: line))
    }
}

class FatalErrorNotifierMock: FatalErrorNotifierSpy {
    func assertNotErrors(_ file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(recordedMessags.count, 0, "Should not raise any errors")
    }
    
    func assertLastMessage(
        _ message: String,
        inFile: String,
        atLine: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertNotNil(lastMessage, "No messages were notified.", file: file, line: line)
        XCTAssertEqual(lastMessage!.text, message, "Text", file: file, line: line)
        XCTAssertEqual(String(lastMessage!.file), inFile, "File", file: file, line: line)
        XCTAssertEqual(lastMessage!.line, UInt(atLine), "Line", file: file, line: line)
    }
    
    func assertLastMessage<Expected, Received>(
        expectedType: Expected.Type,
        receivedType: Received.Type,
        parameterIndex: Int,
        inFile: String,
        atLine: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let lastMessage =
            "Expected \(expectedType) parameter" +
            " at index \(parameterIndex)" +
            " but got \(receivedType): file \(inFile), line \(atLine)"
        assertLastMessage(
            lastMessage,
            inFile: inFile,
            atLine: atLine,
            file: file,
            line: line
        )
    }
    
    func assertLastMessage<Expected>(
        expectedType: Expected.Type,
        parameterIndex: Int,
        inFile: String,
        atLine: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let lastMessage =
            "Expected \(expectedType) parameter" +
            " at index \(parameterIndex)" +
            " but got nothing: file \(inFile), line \(atLine)"
        assertLastMessage(
           lastMessage,
           inFile: inFile,
           atLine: atLine,
           file: file,
           line: line
       )
    }
    
    func assertLastMessage<T>(
        missingDependencyType type: T.Type,
        inFile: String,
        atLine: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertLastMessage(
            "Could not find a dependency for type \(type).",
            inFile: inFile,
            atLine: atLine,
            file: file,
            line: line
        )
    }
}
