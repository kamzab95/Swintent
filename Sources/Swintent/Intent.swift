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

public extension Intent {
    func trigger(_ action: Action) {
        Task {
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
