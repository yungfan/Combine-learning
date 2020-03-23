//
//  ContentView.swift
//  Combine-SwiftUIRegisteDemo
//
//  Created by 杨帆 on 2020/3/12.
//  Copyright © 2020 杨帆. All rights reserved.
//

import SwiftUI
import Combine

class UserAccount: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var repassword: String = ""
    
    // 提交给服务器判断用户名是否合法，网络请求等异步行为
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
    
    // 第一个：验证用户名是否合法
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
        }.receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // 第二个：验证密码长度是否大于6
    var valiatedPassword: AnyPublisher<String?, Never> {
        return $password.flatMap{ password in
            return  Just(password.count > 6 ? password : nil)
        }.eraseToAnyPublisher()
    }
    
    // 第三个：验证两次密码是否一致
    var valiatedRepassword: AnyPublisher<String?, Never> {
        // 注意这里合并的不是$password而是上一步的valiatedPassword
        return valiatedPassword.combineLatest($repassword).flatMap{ (password, repassword) in
            return Just(password == repassword ? password : nil)
        }.eraseToAnyPublisher()
    }
}


struct ContentView: View {
    
    @ObservedObject var userAccount: UserAccount = UserAccount()
    
    // 保存三个Publisher的订阅值
    @State private var unameCondition: Bool = false
    @State private var pwdCondition: Bool = false
    @State private var rePwdCondition: Bool = false
    
    // 按钮的验证条件
    var validation: Bool {
        return !unameCondition || !pwdCondition || !rePwdCondition
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField("用户名", text: self.$userAccount.username)
                        .onReceive(userAccount.validatedUsername.map{ $0 != nil }) {
                            valid in
                            self.unameCondition = valid
                    }
                    
                    // 根据条件控制Image的透明度来达到显隐
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(Color.green)
                        .opacity(unameCondition ? 1 : 0)
                    
                }
                
                HStack {
                    SecureField("密码", text: self.$userAccount.password)
                        .onReceive(userAccount.valiatedPassword.map{ $0 != nil }) {
                            valid in
                            self.pwdCondition = valid
                    }
                    
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(Color.green)
                        .opacity(pwdCondition ? 1 : 0)
                }
                
                HStack {
                    SecureField("确认密码", text: self.$userAccount.repassword)
                        .onReceive(userAccount.valiatedRepassword.map{ $0 != nil }) {
                            valid in
                            self.rePwdCondition = valid
                    }
                    
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(Color.green)
                        .opacity(rePwdCondition ? 1 : 0)
                }
                
                Section {
                    Button("注册") {
                    }
                }.disabled(validation) // 只要不满足条件按钮点击不了
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

