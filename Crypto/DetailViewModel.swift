//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Chi Tim on 2023/10/25.
//

import Foundation
import Combine

class DetailViewModel:ObservableObject{
    
    
    let coin:CoinModel
    private let coinDetailService: CoinDetaiDatalService
    private var cancelable = Set<AnyCancellable>()
    
    
    init(coin:CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetaiDatalService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers(){
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetail in
                print("Get Data")
            }
            .store(in: &cancelable)
    }
    
    
    
}
