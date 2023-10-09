//
//  CryptoApp.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/6.
//

import SwiftUI

@main
struct CryptoApp: App {
    
    @StateObject var vm = HomeViewModel()//总数据管理模型
    
    init(){
        //便更导航栏系统默认颜色
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor:UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor:UIColor(Color.theme.accent)]
    }
    
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
