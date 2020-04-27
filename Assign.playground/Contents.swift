import UIKit
import PlaygroundSupport
import AVFoundation
import Combine

// 1 Just发送单个数据
let publisher = Just(1)
// 2 sink订阅
let subscription = publisher.sink(receiveCompletion: { _ in
    print("receiveCompletion")
}, receiveValue: { value in
    print(value)
})
