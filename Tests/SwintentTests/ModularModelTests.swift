//
//  SwintentTests.swift
//
//
//  Created by Kamil Zaborowski on 28/01/2023.
//  Copyright © 2023 Kamil Zaborowski. All rights reserved.
//

import XCTest
import Combine
@testable import Swintent

final class SwintentTests: XCTestCase {
    
    var sut: AnyIntent<FakeState, FakeAction>!
    var fakeIntent: FakeIntent!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() async throws {
        cancellables = Set()
        fakeIntent = FakeIntent(state: FakeState(intValue: 0))
        sut = fakeIntent.erase()
    }
    
    func testIncreaseValue() {
        let expectation = expectation(description: "testIncreaseValue")
        
        sut.objectWillChange
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.trigger(.increaseValue)
        waitForExpectations(timeout: 3)
        
        XCTAssertEqual(sut.state, FakeState(intValue: 1, stringValue: nil))
    }
    
    func testMultipleTriggersValue() {
        let expectation = expectation(description: "testMultipleTriggersValue")
        expectation.expectedFulfillmentCount = 5
        
        sut.objectWillChange
            .sink { _ in
                print("Fulfill")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.trigger(.increaseValue)
        sut.trigger(.increaseValue)
        sut.trigger(.decreaseValue)
        sut.trigger(.increaseValue)
        sut.trigger(.increaseValue)
        
        waitForExpectations(timeout: 3)
        
        XCTAssertEqual(sut.state, FakeState(intValue: 3, stringValue: nil))
        XCTAssertEqual(fakeIntent.actionsTriggered, [.increaseValue, .increaseValue, .decreaseValue, .increaseValue, .increaseValue])
    }
    
    func testReadBinding() {
        let binding = sut.binding(\.stringValue, input: { .setString($0) })
        XCTAssertNil(binding.wrappedValue)
    }
    
    func testWriteBinding() {
        let expectation = expectation(description: "testWriteBinding")
        
        sut.objectWillChange
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        let binding = sut.binding(\.stringValue, input: { .setString($0) })
        binding.wrappedValue = "test string"
        
        waitForExpectations(timeout: 3)
        
        XCTAssertEqual(sut.state, FakeState(intValue: 0, stringValue: "test string"))
        XCTAssertEqual(fakeIntent.actionsTriggered, [.setString("test string")])
    }
}
