//
//  PortfolioView.swift
//  Crypto
//
//  Created by Chi Tim on 2023/10/3.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    
    @State private var selectedCoin: CoinModel? = nil//点击选中的Coin
    @State private var quantityText:String = ""
    @State private var showCheckMark:Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading,spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil{
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement:.topBarLeading) {
                    Button(action: {
                        dismiss()//关闭sheet，只能在此环境中调用，否则不起效
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
                ToolbarItem(placement:.topBarTrailing) {
                    trailingNavigationBarButtons
                }
            })
            .onChange(of: vm.searchText) { value in
                if value == "" {
                    removeSeletedCoin()
                }
            }
        }
    }
}

extension PortfolioView{
    private var coinLogoList: some View{
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack(spacing: 10){
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn){
                                updateSeletedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear ,
                                        lineWidth:1)//选中显示绿色框
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    
    private func updateSeletedCoin(coin:CoinModel){
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}),
           let amount = portfolioCoin.currentHoldings
        {
            quantityText = "\(amount)"
        }else{
            quantityText = ""
        }
    }
    
    private var portfolioInputSection:some View{
        VStack(spacing:20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holding")
                Spacer()
                TextField("Ex: 1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)//文本对齐
                    .keyboardType(.decimalPad)//设置键盘类型为数字键盘
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavigationBarButtons:some View{
        HStack(spacing:10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ) ? 1.0 : 0.0)
        }
        .font(.headline)
    }
    
    private func removeSeletedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
    
    private func saveButtonPressed(){
        
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)//输入的数字
        else{
            return
        }
        //保存 portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        //显示对钩
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSeletedCoin()
        }
        //隐藏键盘
        UIApplication.shared.endEditing()
        //隐藏对钩
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut){
                showCheckMark = false
            }
        }
    }
    
    private func getCurrentValue()-> Double{
        //输入数量后，才进行计算
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
}

struct PortfolioView_Previews: PreviewProvider{
    static var previews: some View{
        PortfolioView()
    }
}
