//
//  HomeView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/6.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel//拿到总的vm
    
    @State private var showPortfolio: Bool = false//尽可能的使用private
    
    @State private var showPortfolioView: Bool = false // 新列表
    
    var body: some View {
        ZStack{
            //background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    //底部弹出页面
                    PortfolioView()
                        .environmentObject(vm)//会产生新的环境，需要将环境变量手动添加到view中
                })
            //content layer
            VStack{
                //头部标题栏
                homeHeader//放到extension部分
                //统计信息列表
                
                HomeStatsView(showPortfolio: $showPortfolio, statistics: vm.statistics)
                
                //搜搜栏
                SearchBarView(searchText: $vm.searchText)
                //栏标题
                columTitles
                //主列表
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
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()//显示showPortfolioView
                    }
                }
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
            
            Button {
                withAnimation(Animation.linear(duration: 2)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360:0),anchor: .center)//绕中心旋转360度
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}
