//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/14.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    
    @Published var allCoins:[CoinModel] = []
    @Published var portfolioCoins:[CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        addSucribers()
    }
    
    func addSucribers(){
        //为allCoins添加监听器
        dataService.$allCoins
            .sink(receiveValue: {[weak self] (returnCoins) in
                self?.allCoins = returnCoins
                self?.portfolioCoins = returnCoins
            })
            .store(in: &cancellable)
            
    }
    
    
    
    
}
