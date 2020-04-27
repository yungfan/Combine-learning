import UIKit
import Combine

let dataPublisher = URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.baidu.com")!)

let cancellableSink = dataPublisher
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("received finished")
            break
        case .failure(let error):
            print("received error: ", error)
        }}, receiveValue: { someValue in
            print("received \(someValue)")
    })

// 可以取消
//cancellableSink.cancel()
