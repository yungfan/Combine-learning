//
//  ViewController.swift
//  Combine-RegisteDemo
//
//  Created by 杨帆 on 2020/3/7.
//  Copyright © 2020 杨帆. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    // 属性发布者
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var repassword: String = ""
    
    // 按钮，默认是不能点击的
    @IBOutlet var loginBtn: UIButton!
    // 显示用户名的合法时的提示
    @IBOutlet weak var usernameInfo: UIImageView!
    // 显示密码的合法时的提示
    @IBOutlet weak var passwordInfo: UIImageView!
    // 显示2次密码的一致时的提示
    @IBOutlet weak var repasswordInfo: UIImageView!
    
    // 存储订阅者防止释放
    var subscriptionUsername: AnyCancellable?
    var subscriptionPassword: AnyCancellable?
    var subscriptionRepassword: AnyCancellable?
    var subscriptionAccount: AnyCancellable?
    
    // 三个输入框的Editing Changed，每次输入后进行赋值
    @IBAction func usernameChanged(_ sender: UITextField) {
        username = sender.text ?? ""
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        password = sender.text ?? ""
    }
    
    @IBAction func repasswordChanged(_ sender: UITextField) {
        repassword = sender.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.验证用户名合法
        subscriptionUsername = validatedUsername.map{ $0 == nil }
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: usernameInfo)
        
        // 2.验证密码的合法性
        subscriptionPassword = valiatedPassword.map{ $0 == nil }
            .assign(to: \.isHidden, on: passwordInfo)
        
        // 3.验证两次数输入的密码是否一致
        subscriptionRepassword = valiatedRepassword.map{ $0 == nil }
            .assign(to: \.isHidden, on: repasswordInfo)
        
        // 4.检查用户名和密码
        subscriptionAccount = validatedAccount.map{ $0 != nil }
            .receive(on: RunLoop.main)
            // 使用 Assign 订阅者改变 UI 状态
            .assign(to: \.isEnabled, on: loginBtn)
    }
}

// 1.检验用户名的Publisher
extension ViewController {
    
    // 1.1 提交给服务器判断用户名是否合法，网络请求等异步行为
    func usernameChecked(_ username:String, completion: @escaping ((Bool) -> ())) {
        // 模拟网络验证的过程
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if username == "123456" {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
    
    // 1.2 第一个：验证用户名是否合法
    var validatedUsername: AnyPublisher<String?, Never> {
        // 限制产生值的频率
        return $username.debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates() // 去重，重复的不需要再次检验
            .flatMap { username in
                // 使用 Future 包装已有的异步操作
                return Future { promise in
                    self.usernameChecked(username) { available in
                        promise(.success(available ? username : nil))
                    }
                }
        }.eraseToAnyPublisher()
    }
}

// 2.检验密码的Publisher
extension ViewController {
    
    // 2.1 第二个：验证密码长度是否大于6
    var valiatedPassword: AnyPublisher<String?, Never> {
        return $password.flatMap{ password in
            return  Just(password.count > 6 ? password : nil)
        }.eraseToAnyPublisher()
    }
    
    // 2.2 第三个：验证两次密码是否一致
    var valiatedRepassword: AnyPublisher<String?, Never> {
        // 注意这里合并的不是$password而是上一步的valiatedPassword
        return valiatedPassword.combineLatest($repassword).flatMap{ (password, repassword) in
            return Just(password == repassword ? password : nil)
        }.eraseToAnyPublisher()
    }
}

// 3.检验用户名和密码的Publisher
extension ViewController {
    
    // 第四个：验证用户名和密码
    var validatedAccount: AnyPublisher<(String, String)?, Never> {
        // 合并第一步和第二步产生的Publisher
        validatedUsername.combineLatest(valiatedRepassword).map({ (username, password) -> (String, String)? in
            guard let uname = username, let pwd = password else { return nil }
            return (uname, pwd)
        }).eraseToAnyPublisher()
    }
}
