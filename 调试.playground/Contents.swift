import Combine

let subscription = [1, 2, 3].publisher
.print("debug info")
.map { $0 * $0 }
.sink { _ in }



let subscription2 = [1, 2, 3].publisher
.handleEvents(receiveSubscription: { print("Receive subscription: \($0)") },
              receiveOutput: { print("Receive output: \($0)") },
              receiveCompletion: { print("Receive completion: \($0)") },
              receiveCancel: { print("Receive cancel") },
              receiveRequest: { print("Receive request: \($0)") })
.map { $0 * $0 }
.sink { _ in }
