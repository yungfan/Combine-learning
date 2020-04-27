import Combine

let publisher1 = PassthroughSubject<Int, Never>()
let publisher2 = PassthroughSubject<Int, Never>()
let publisher3 = PassthroughSubject<Int, Never>()

let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()

let subscription = publishers
    .switchToLatest()
    .sink(receiveCompletion: { _ in print("Completed!") },
          receiveValue: { print($0) })

publishers.send(publisher1)
publisher1.send(1)
publisher1.send(2)

publishers.send(publisher2)
publisher1.send(3)
publisher2.send(4)
publisher2.send(5)

publishers.send(publisher3)
publisher2.send(6)
publisher3.send(7)
publisher3.send(8)
publisher3.send(9)
