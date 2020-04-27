import Combine

let publisher1 = PassthroughSubject<Int, Never>()
let publisher2 = PassthroughSubject<Int, Never>()

let subscription = publisher1.merge(with: publisher2)
    .sink { print($0) }

publisher1.send(1)
publisher1.send(2)

publisher2.send(11)
publisher2.send(22)

publisher1.send(3)
publisher2.send(33)
