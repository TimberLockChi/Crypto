//
//  DetailView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/10/24.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack{
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
        
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    //.flexible可以根据内容灵活调整大小
    private let colums:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing:CGFloat = 30
    
    init(coin:CoinModel){
        self._vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing:20){
                
                overviewTitle
                Divider()
                overviewGrid
                addtionalTitle
                Divider()
                addtionalGrid
                
            }
            .padding()
            
        }
        .navigationTitle(vm.coin.name)
    }
}

struct DetailView_Previews:PreviewProvider {
    static var previews: some View{
        NavigationView{
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView{
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    
    private var addtionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth:.infinity,alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: colums,
            alignment: .leading,
            spacing: nil,
            pinnedViews: [],
            content: {
                ForEach(vm.overviewStatistics){ stat in
                    StatisticView(stat: stat)
                }
        })
    }
    
    private var addtionalGrid: some View {
        LazyVGrid(
            columns: colums,
            alignment: .leading,
            spacing: nil,
            pinnedViews: [],
            content: {
                ForEach(vm.additionalStatistics){ stat in
                    StatisticView(stat: stat)
                }
        })
    }
    
}
