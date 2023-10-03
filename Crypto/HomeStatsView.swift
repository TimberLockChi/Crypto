//
//  HomeStatsView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/23.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm:HomeViewModel//拿到系统vm
    
    @Binding var showPortfolio: Bool//绑定一个父视图变量
    
    var statistics:[StatisticModel]
    
    
    
    var body: some View {
        HStack{
            ForEach(statistics){ stat in
                StatisticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width/3)//如果程序不存在横屏可以使用，否则需要采用几何阅读器
            }
        }
        .frame(width: UIScreen.main.bounds.width,alignment: showPortfolio ? .trailing : .leading)
    }
}

struct HomeStatsView_preview:PreviewProvider {
    static var previews: some View{
        HomeStatsView(showPortfolio: .constant(false),statistics: [])
            .environmentObject(dev.homeVM)
    }
}
