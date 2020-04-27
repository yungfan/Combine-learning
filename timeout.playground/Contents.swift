import Combine
import UIKit

let publisher = PassthroughSubject<String, Never>()
// delay时间超过timeout 不会有输出
let subscription = publisher
            .delay(for: 2, scheduler: DispatchQueue.main)
            .timeout(4, scheduler: RunLoop.main)
            .sink { data in
                print("timeout:" + data)
            }

// 发送Hello
publisher.send("Hello")
