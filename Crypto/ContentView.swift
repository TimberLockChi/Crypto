//
//  ContentView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/6.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background//自定义Extension
                .ignoresSafeArea()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
