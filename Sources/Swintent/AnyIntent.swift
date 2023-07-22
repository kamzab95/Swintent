//
//  AnyIntent.swift
//
//
//  Created by Kamil Zaborowski on 28/01/2023.
//  Copyright © 2023 Kamil Zaborowski. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public typealias IntentOf<I: Intent> = AnyIntent<I.State, I.Action>

public final class AnyIntent<State, Action>: ObservableObject {

    private let wrappedState: () -> State
    private let wrappedTrigger: (Action) -> Void
    
    public var state: State {
        wrappedState()
    }

    public func trigger(_ action: Action) {
        wrappedTrigger(action)
    }

    private var cancelBag = Set<AnyCancellable>()
    
    public init<I: Intent>(_ intent: I) where I.State == State, I.Action == Action {
        self.wrappedState = { intent.state }
        self.wrappedTrigger = intent.trigger
        
        intent.objectWillChange
            .sink { [weak self] _ in
                if !Thread.isMainThread {
                    assertionFailure("objectWillChange was called from background thread. Add @MainActor to async function that updates state or use MainActor.run { }")
                }
                self?.objectWillChange.send()
            }.store(in: &cancelBag)
    }
}

public extension AnyIntent {
    func binding<Value>(_ keyPath: KeyPath<State, Value>, input: ((Value)->Action)?) -> Binding<Value> {
        Binding {
            self.state[keyPath: keyPath]
        } set: { newValue in
            if let input {
                self.trigger(input(newValue))
            }
        }
    }
}
