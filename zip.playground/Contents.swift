import Combine

let publisher1 = PassthroughSubject<Int, Never>()
let publisher2 = PassthroughSubject<String, Never>()

let subscription = publisher1
    .zip(publisher2)
    .sink(receiveCompletion: { _ in print("Completed") },
          receiveValue: { print("P1: \($0), P2: \($1)") })

publisher1.send(1)
publisher1.send(2)

publisher2.send("a")
publisher2.send("b")

publisher1.send(3)
publisher2.send("c")

publisher1.send(completion: .finished)
publisher2.send(completion: .finished)
