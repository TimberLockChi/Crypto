//
//  StatisticView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/23.
//

import SwiftUI

struct StatisticView: View {
    
    let stat: StatisticModel
    
    
    var body: some View {
        
        VStack(alignment: .leading ,spacing: 4){
            Text(stat.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            HStack{
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees:(stat.percentageChange ?? 0) >= 0 ? 0: 180)//大于0（上涨），箭头不转动，否则旋转180度
                    )
                Text(stat.percentageChange?.asPercentString() ?? "")//添加百分号
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)//如果没有变化就透明显示
        }
    }
}

struct StatisticView_PreviewProvider: PreviewProvider {
    static var previews: some View{
        StatisticView(stat: dev.state1)
    }
    
}
