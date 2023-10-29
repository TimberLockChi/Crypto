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
    
    
    init(coin:CoinModel){
        self._vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing:20){
                Text("")
                    .frame(height: 150)
                
                Text("Overview")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth:.infinity,alignment: .leading)
                Divider()
                
                Text("")
                    .frame(height: 150)
                
                Text("Additional Details")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth:.infinity,alignment: .leading)
                Divider()
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
