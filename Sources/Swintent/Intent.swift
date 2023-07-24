//
//  Intent.swift
//  
//
//  Created by Kamil Zaborowski on 28/01/2023.
//  Copyright © 2023 Kamil Zaborowski. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public protocol Intent: ObservableObject {
    associatedtype State
    associatedtype Action

    var state: State { get }
    
    @MainActor
    func trigger(_ action: Action) async
}

var counter = 0

public extension Intent {
    func trigger(_ action: Action) {
        counter += 1
        let id = counter
        print("Trigger \(action) \(id)")
        Task { @MainActor in
            print("Execute \(action) \(id)")
            await trigger(action)
        }
    }
}

public extension Intent {
    func erase() -> AnyIntent<State, Action> {
        AnyIntent(self)
    }
    
    func eraseToStateObject() -> StateObject<AnyIntent<State, Action>> {
        StateObject(wrappedValue: self.erase())
    }
    
    func eraseToObservedObject() -> ObservedObject<AnyIntent<State, Action>> {
        ObservedObject(wrappedValue: self.erase())
    }
}
