import UIKit
import Combine

// 为了确保订阅一直有效，除了引入新的变量来持有它，还有另外一种方法，Combine 也为此专门在 AnyCancellable 添加了一个方法，来将订阅产生的 AnyCancellable 加到一个集合中。
var cancellables: Set<AnyCancellable> = []

func fetchData(from url: URL) -> Future<Data, URLError> {
    return Future<Data, URLError> { promise in
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .print("Future")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    promise(.failure(error))
                }
            }, receiveValue: {
                promise(.success($0))
            }).store(in: &cancellables) // 存储订阅者维持较长生命周期
    }
}


fetchData(from: URL(string: "https://www.baidu.com")!)
    .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
            // 失败的处理
        }
    }, receiveValue: { _ in
        // 成功的处理
    }).store(in: &cancellables) // 存储订阅者维持较长生命周期

/*输出
 Future: receive subscription: (DataTaskPublisher)
 Future: request unlimited
 Future: receive value: (2443 bytes)
 Future: receive finished
 */
