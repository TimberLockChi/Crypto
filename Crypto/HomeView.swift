//
//  HomeView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/6.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @State private var showPortfolio: Bool = false//尽可能的使用private
    
    var body: some View {
        ZStack{
            //background layer
            Color.theme.background
                .ignoresSafeArea()
            //content layer
            VStack{
                homeHeader//放到extension部分
                
                columTitles
                
                if !showPortfolio{
                    allCoinList
                        .transition(.move(edge: .leading))//设置动画
                }
                
                if showPortfolio{
                    portfolioCoinList
                        .transition(.move(edge: .trailing))//设置动画
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .toolbar(.hidden)
        }
        .environmentObject(dev.homeVM)//所有视图共用
    }
}

extension HomeView{
    private var homeHeader:some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")//按钮视图
                .animation(.none, value: showPortfolio)//根据特定值的变化设置动画效果，.none表示取消动画
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)//设置背景，实现自定义动画效果
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))//旋转按钮
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()//改变按钮状态
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinList:some View{
        List{
            ForEach(vm.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColum: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))//设置列表间隔位置
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinList:some View{
        List{
            ForEach(vm.portfolioCoins){ coin in
                CoinRowView(coin: coin, showHoldingsColum: true)//是否显示中间的持有部分
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))//设置列表间隔位置
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columTitles:some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width/3.5,alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}
