import UIKit
import Combine

// every：间隔时间 on：在哪个线程 in：在哪个Runloop
let subscription = Timer.publish(every: 1, on: .main, in: .default)
    .autoconnect()
    .sink { _ in
        print("Hello")
}

// 可以取消
// subscription.cancel()


// every：间隔时间 on：在哪个线程 in：在哪个Runloop
let timerPublisher = Timer.publish(every: 1, on: .main, in: .default)
    
let cancellablePublisher = timerPublisher
    .sink { _ in
        print("World")
}

let subscription2 = timerPublisher.connect()

// 可以取消
// subscription2.cancel()
