import Combine

// 1 创建CurrentValueSubject，需要初始化一个数据
let subject = CurrentValueSubject<String, Never>("Hello")
// CurrentValueSubject有value属性
print(subject.value)

// 2 发送数据
subject.send("Combine")
print(subject.value)

// 3 订阅
let subscription = subject.sink { value in
    print(value)
}
