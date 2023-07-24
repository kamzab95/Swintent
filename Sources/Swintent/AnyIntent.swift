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

public typealias AnyIntentOf<I: Intent> = AnyIntent<I.State, I.Action>

public final class AnyIntent<State, Action>: ObservableObject {

    private let wrappedState: () -> State
    private let wrappedAsyncTrigger: (Action) async -> Void
    
    public var state: State {
        wrappedState()
    }

    public func trigger(_ action: Action) {
        Task { @MainActor in
            await trigger(action)
        }
    }

    @MainActor
    public func trigger(_ action: Action) async {
        await wrappedAsyncTrigger(action)
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
    public init<I: Intent>(_ intent: I) where I.State == State, I.Action == Action {
        self.wrappedState = { intent.state }
        self.wrappedAsyncTrigger = intent.trigger
        
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
    
    func binding<Value>(_ keyPath: KeyPath<State, Value>, input: @autoclosure @escaping ()->Action) -> Binding<Value> {
        Binding {
            self.state[keyPath: keyPath]
        } set: { _ in
            self.trigger(input())
        }
    }
}
