import UIKit

let userInput = ["aaa", "aaa", "bbbb", "ccc", "bbbb"].publisher
let subscription = userInput
    .removeDuplicates()
    .sink(receiveValue: { print($0) })
