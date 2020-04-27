import Combine
import UIKit

let publisher = PassthroughSubject<String, Never>()
// latest 为true 发送最新数据
let subscription = publisher
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { data in
                print("throttle:" + data)
            }

let typingHelloWorld: [(TimeInterval, String)] = [
    (0.0, "H"),
    (0.1, "He"),
    (0.2, "Hel"),
    (0.3, "Hell"),
    (0.4, "Hello"),
    (1.0, "HelloC"),
    (1.2, "HelloCo"),
    (1.5, "HelloCom"),
    (2.0, "HelloComb"),
    (2.1, "HelloCombi"),
    (3.2, "HelloCombin"),
    (3.3, "HelloCombine")
]
//模拟输入HelloCombine
typingHelloWorld.forEach { (delay, str) in
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        publisher.send(str)
    }
}
