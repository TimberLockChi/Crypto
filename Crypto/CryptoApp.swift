//
//  CryptoApp.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/6.
//

import SwiftUI

@main
struct CryptoApp: App {
    
    @StateObject var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)//将vm存入环境变量，让HomeView的所有视图都能访问vm
        }
    }
}
