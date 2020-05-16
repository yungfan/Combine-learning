//
//  ContentView.swift
//  SwiftUI+Combine
//
//  Created by 杨帆 on 2020/5/16.
//  Copyright © 2020 杨帆. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var text = "😄"
    
    var body: some View {
        
        VStack {
            Text(text)
            
            Text(text).onReceive(Just(123).map{
                String($0)
            }) {
                self.text = $0
            }
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
