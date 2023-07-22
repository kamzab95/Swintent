//
//  FakeViewModel.swift
//
//
//  Created by Kamil Zaborowski on 22/07/2023.
//

import Foundation
@testable import Swintent

struct FakeState: Equatable {
    var intValue: Int
    var stringValue: String?
}

enum FakeAction: Equatable {
    case increaseValue
    case decreaseValue
    case setString(String?)
}

class FakeIntent: ViewModel {
    @Published var state: FakeState
    
    init(state: FakeState) {
        self.state = state
    }
    
    var actionsTriggered = [FakeAction]()
    func trigger(_ action: FakeAction) async {
        switch action {
        case .increaseValue:
            state.intValue += 1
        case .decreaseValue:
            state.intValue -= 1
        case .setString(let string):
            state.stringValue = string
        }
        actionsTriggered.append(action)
    }
}
