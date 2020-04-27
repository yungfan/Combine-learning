import Combine
import UIKit

struct SomeError: Error {
}

let subscription = Just(1)
.tryMap { _ in throw SomeError() }
.catch { _ in Just(2) } // 创建新的Publisher
.sink { print($0) }


let subscription2 = Just(1)
.tryMap { _ -> Int in throw SomeError() }
.replaceError(with: 2)
.sink { print($0) }


let url = URL(string: "https://www.baidu.com")
   
let subscription3 = URLSession.shared.dataTaskPublisher(for: url!)
   .retry(3) // 尝试3次
   .receive(on: DispatchQueue.main)
   .sink(receiveCompletion: { print($0) },
         receiveValue: { value in print(value) })


// 1 声明自定义错误类型
enum APIError: Error {
    case userIsOffline
    case somethingWentWrong
}

// 2 创建Result的Publisher
let errorPublisher = Result<Int, Error>.Publisher(URLError(.notConnectedToInternet))

// 3 订阅，将Error转换成APIError
let subscription4 = errorPublisher
    .mapError { error -> APIError in
        switch error {
        case URLError.notConnectedToInternet:
            return .userIsOffline
        default:
            return .somethingWentWrong
        }
}
    .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
