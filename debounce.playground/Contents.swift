import Combine
import UIKit


let publisher = PassthroughSubject<String, Never>()
let subscription = publisher
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { data in
                print("debounce:" + data)
            }

let typingHelloWorld: [(TimeInterval, String)] = [
    (0.0, "H"),
    (0.1, "He"),
    (0.2, "Hel"),
    (0.3, "Hell"),
    (0.4, "Hello"),
    (1.6, "HelloC"),
    (1.7, "HelloCo"),
    (2.8, "HelloCom"),
    (2.9, "HelloComb"),
    (3.0, "HelloCombi"),
    (3.1, "HelloCombin"),
    (3.2, "HelloCombine")
]
//模拟输入HelloCombine
typingHelloWorld.forEach { (delay, str) in
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        publisher.send(str)
    }
}
