//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/14.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    @Published var statistics:[StatisticModel] = [
    ]
    
    @Published var statistics_portfolio:[StatisticModel] = []
    
    
    @Published var allCoins:[CoinModel] = []
    @Published var portfolioCoins:[CoinModel] = []
    
    @Published var searchText:String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        addSucribers()
    }
    
    func addSucribers(){
        //为输入变化和coin列表添加监听器
        $searchText
            .combineLatest(coinDataService.$allCoins)//同时绑定其他的publisher，其他publisher发布消息时也同时执行
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)//在执行后续逻辑前暂停0.5秒钟，等待用户输入完毕，防止频繁执行后续操作
            .map(filterCoins)
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellable)
        //更新时长数据
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellable)
    }
    
    
    private func filterCoins(text:String,coins:[CoinModel])->[CoinModel]{
        guard
            !text.isEmpty
        else{
            //如果输入为空，则不需要过滤，直接返回即可
            return coins
        }
        let lowecasedText = text.lowercased()//转换为小写
        
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowecasedText) ||
            coin.symbol.lowercased().contains(lowecasedText) ||
            coin.id.lowercased().contains(lowecasedText)//将全部的虚拟货币信息过滤后返回
        }
    }
    
    private func mapGlobalMarketData(marketDataModel:MarketDataModel?) -> [StatisticModel]{
        var stats:[StatisticModel] = []
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap ,percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24H Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00",percentageChange: 0)

        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
    
    
}
