//
//  CoinRowView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/11.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin:CoinModel
    let showHoldingsColum:Bool
    
    
    var body: some View {
        HStack(spacing: 0) {
            leftColum
            Spacer()
            if showHoldingsColum{
                centerColum
            }
            rightColum
        }
        .font(.headline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin,showHoldingsColum: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin,showHoldingsColum: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)//黑暗模式
        }
        
    }
}

extension CoinRowView{
    private var leftColum:some View{
        HStack(spacing:0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)//主题颜色
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30,height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColum:some View{
        VStack(alignment: .trailing){
            Text(coin.currentHodingsValues.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColum:some View{
        VStack(alignment:.trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width/3,alignment: .trailing)//定义大小为屏幕的1/3
    }

    
}
