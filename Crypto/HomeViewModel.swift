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
    @Published var isLoading:Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellable = Set<AnyCancellable>()
    
    enum SortOption{
        case rank,rankReversed,holdings,holdingReversed,price,priceReversed
    }
    
    
    init(){
        addSucribers()
    }
    
    func addSucribers(){
        
        //为输入变化和coin列表添加监听器
        $searchText
            .combineLatest(coinDataService.$allCoins,$sortOption)//同时绑定其他的publisher，其他publisher发布消息时也同时执行
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)//在执行后续逻辑前暂停0.5秒钟，等待用户输入完毕，防止频繁执行后续操作
            .map(filterAndSortCoins)
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
                //self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        //更新拥有的货币信息
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)//伴随所有货币列表进行更新
            .map (mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                //来自接收器的值是不可变的
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellable)
        
        //更新市场数据
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false//加载完毕
            }
            .store(in: &cancellable)
        
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
    }
    
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins:[CoinModel],portfolioCoins:[PortfolioEntity])->[CoinModel]{
        allCoins.compactMap { coin -> CoinModel? in
            guard let entity = portfolioCoins.first(where:{$0.coinID == coin.id}) else{
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    private func filterAndSortCoins(text:String,coins:[CoinModel],sort:SortOption)->[CoinModel]{
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
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
    //inout可以让数组原地排序
    private func sortCoins(sort:SortOption,coins: inout [CoinModel]){
        switch sort{
        case.rank,.holdings:
             coins.sort(by: {$0.rank<$1.rank})//创建一个新的数组
//            return coins.sorted { coin1, coin2 in
//                return coin1.rank<coin2.rank
//            }
        case .rankReversed,.holdingReversed:
             coins.sort(by: {$0.rank>$1.rank})
        case.price:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case.priceReversed:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortPortfolioIfNeeded(coins:[CoinModel])->[CoinModel]{
    
    }
    
    private func mapGlobalMarketData(marketDataModel:MarketDataModel?,portfolioCoins:[CoinModel]) -> [StatisticModel]{
        var stats:[StatisticModel] = []
        guard let data = marketDataModel else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap ,percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24H Volume", value: data.volume)
        
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        
//        let portfolioValue = portfolioCoins.map { coin -> Double in
//            return coin.currentHodingsValues
//        }
        //上述语句的简化版
        let portfolioValue = portfolioCoins
            .map({$0.currentHodingsValues})//得到所有拥有货币的总价值
            .reduce(0, +)//对数组进行快速加核
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHodingsValues
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(),percentageChange: percentageChange )

        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
    
    
}
