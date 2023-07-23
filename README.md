# Swintent
[![Build Status](https://app.bitrise.io/app/0cb43eed-1cc9-49e7-99bb-aeabca7895eb/status.svg?token=2XIPikHRJNqU6frpklYplg&branch=main)](https://app.bitrise.io/app/0cb43eed-1cc9-49e7-99bb-aeabca7895eb)

## Overview

Swintent is a lightweight library for implementing a Model-View-Intent (MVI) architectural pattern in SwiftUI. MVI is a unidirectional data flow architecture inspired by Reactive and Functional programming paradigms. This library simplifies the process of implementing this architecture in your SwiftUI applications, making it easier to manage and update state across different views.

## Features

* Strong type checking with State and Action associated types.
* Intent protocol to define how to mutate your state in response to user actions.
* Erase function to convert your custom Intent to AnyIntent, making it easier to pass intents around your application.
* Binding extension to create bindings from your state, enabling SwiftUI two-way binding syntax.

## Installation

You can add Swintent to your Swift project using Swift Package Manager.

```swift
dependencies: [
    .package(url: "https://github.com/kamzab95/Swintent.git", from: "0.9.0")
]
```

## Usage

Here's a simple example of how you might use Swintent:

```swift
struct MyState {
    var text: String = ""
}

enum MyAction {
    case updateText(String)
}

class MyIntent: Intent {
    @Published var state: MyState = MyState()
    
    @MainActor
    func trigger(_ action: MyAction) async {
        switch action {
        case .updateText(let newText):
            state.text = newText
        }
    }
}

struct MyView: View {
    @StateObject var intent: AnyIntent<MyState, MyAction>
    
    var body: some View {
        TextField("Enter text", text: intent.binding(\.text, input: { .updateText($0) }))
    }
}
```

In this example, `MyIntent` is an Intent that takes `MyState` and `MyAction`. The `TextField` view uses a binding to the `text` property of `MyState`, and when the TextField updates, it triggers `MyAction.updateText`.

## API

The key types and functions provided by Swintent include:

- `Intent`: A protocol representing a type that holds state and defines actions to mutate that state.
- `AnyIntent`: A type-erased wrapper around an Intent.
- `trigger(_:)`: A method to mutate the state in response to an action.
- `erase()`: A method to erase the types of an Intent to an AnyIntent.
- `binding(_:)`: A method to create a binding from a property of the state.

## License

Swintent is available under the MIT license. See the LICENSE file for more details. 

## Contributions

Contributions are welcome! Please create a new issue if you have any suggestions, feature requests, or bugs to report. Feel free to submit a pull request if you've added or fixed something.
