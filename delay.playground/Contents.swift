import Combine
import UIKit

let publisher = PassthroughSubject<String, Never>()
let subscription = publisher
            .delay(for: 3, scheduler: DispatchQueue.main)
            .sink { data in
                print("delay:" + data)
            }

// 输入Hello
publisher.send("Hello")
