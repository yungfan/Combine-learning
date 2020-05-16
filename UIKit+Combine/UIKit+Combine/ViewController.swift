//
//  ViewController.swift
//  UIKit+Combine
//
//  Created by 杨帆 on 2020/5/16.
//  Copyright © 2020 杨帆. All rights reserved.
//

import UIKit
import Combine

extension Notification.Name {
    static var message = Notification.Name("YungFan")
}

class ViewController: UIViewController {

    @IBOutlet weak var allow: UISwitch!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var content: UILabel!
    
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var allowMessage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        $allowMessage.assign(to: \.isEnabled, on: button).store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .message)
            
        .map{ notification -> String in
            
            return (notification.object as? String ?? "defalue Value")
        }
            .assign(to: \.text, on: content).store(in: &cancellables)
    }

    @IBAction func change(_ sender: UISwitch) {
        
        allowMessage =  sender.isOn
    }
    
    @IBAction func click(_ sender: UIButton) {
        
        NotificationCenter.default.post(name: .message, object: "Combine + UIKit")
    }
}

