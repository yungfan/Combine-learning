import Combine
import UIKit

// 服务器返回的数据对应的Model
struct NewsModel: Codable {
    var reason: String
    var error_code: Int
    var result: Result
}

struct Result: Codable {
    var stat: String
    var data: [DataItem]
}

// 实现Hashable，List中的数据必须实现
struct DataItem: Codable, Hashable {
    var title: String
    var date: String
    var category: String
    var author_name: String
    var url: String
}


let url = URL(string: "http://v.juhe.cn/toutiao/index?type=top&key=d1287290b45a69656de361382bc56dcd")
let request = URLRequest(url: url!)
let session = URLSession.shared
let backgroundQueue = DispatchQueue.global()

let dataPublisher = session.dataTaskPublisher(for: request)
    .retry(5)
    .timeout(5, scheduler: backgroundQueue)
    .map{$0.data}
    .decode(type: NewsModel.self, decoder: JSONDecoder())
    .subscribe(on: backgroundQueue)
    .eraseToAnyPublisher()

let subscription = dataPublisher.receive(on: DispatchQueue.main)
    .sink(receiveCompletion: {_ in }) {
        newsModel in
        print(newsModel.result.data)
}
