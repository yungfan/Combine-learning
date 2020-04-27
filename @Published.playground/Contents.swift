import Combine

class Student {
    @Published var name: String = "zhangsan"
    @Published var isCollegeStudent: Bool = false
}

let stu = Student()

var subscription = stu.$name.sink {
    print($0)
}
stu.name = "lisi"

subscription = stu.$isCollegeStudent.sink {
    print($0)
}
stu.isCollegeStudent = true
