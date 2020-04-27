import UIKit
import Combine

// 自定义通知名
extension Notification.Name{
    static var myNotiName = Notification.Name("YungFan")
}

// 订阅通知
let subscription = NotificationCenter.default.publisher(for: .myNotiName)
    .sink(receiveValue: { notification in
        print(notification.object as? String)
    })

// 创建通知
let noti = Notification(name: .myNotiName, object: "some info", userInfo: nil)
// 发送通知
NotificationCenter.default.post(noti)

