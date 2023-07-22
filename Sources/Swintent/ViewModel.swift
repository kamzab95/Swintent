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

public protocol ViewModel: ObservableObject {
    associatedtype State
    associatedtype Action

    var state: State { get }
    
    @MainActor
    func trigger(_ action: Action) async
}

public extension ViewModel {
    func erase() -> AnyViewModel<State, Action> {
        AnyViewModel(self)
    }
    
    func eraseToStateObject() -> StateObject<AnyViewModel<State, Action>> {
        StateObject(wrappedValue: self.erase())
    }
    
    func eraseToObservedObject() -> ObservedObject<AnyViewModel<State, Action>> {
        ObservedObject(wrappedValue: self.erase())
    }
}
