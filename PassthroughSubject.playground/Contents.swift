import Combine

// 1 创建PassthroughSubject
let subject = PassthroughSubject<String, Never>()
// 2 订阅
let subscription = subject.sink(receiveCompletion: { _ in
    print("receiveCompletion")
}, receiveValue: { value in
    print(value)
})
// 3 发送数据
subject.send("Hello")
subject.send("Combine")
subject.send(completion: .finished)
