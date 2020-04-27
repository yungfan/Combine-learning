import Combine
import UIKit

class Person: NSObject {
    @objc dynamic var age: Int = 0
}

let person = Person()

let subscription = person.publisher(for: \.age)
    .sink { newValue in
        print("person的age改成了\(newValue)")
    }

person.age = 10 // 改变时会收到通知
