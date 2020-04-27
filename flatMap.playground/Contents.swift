import UIKit
import Combine

let subscription = URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.example1.com")!)
    .flatMap { data, response in
        URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.example2.com")!)
}
    .flatMap { data, response in
        URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.example3.com")!)
}
    .sink(receiveCompletion: {_ in print("receiveCompletion") },
      receiveValue: { value in  })
