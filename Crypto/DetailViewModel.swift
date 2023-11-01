//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Chi Tim on 2023/10/25.
//

import Foundation
import Combine

class DetailViewModel:ObservableObject{
    
    @Published var overviewStatistics:[StatisticModel] = []
    @Published var additionalStatistics:[StatisticModel] = []
    
    @Published var coin:CoinModel
    private let coinDetailService: CoinDetaiDatalService
    private var cancelable = Set<AnyCancellable>()
    
    
    init(coin:CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetaiDatalService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers(){
        
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapData2Statistics)
            .sink { [weak self] returnedArray in
                self?.overviewStatistics = returnedArray.overview
                self?.additionalStatistics = returnedArray.addtional
            }
            .store(in: &cancelable)
    }
    
    
    private func mapData2Statistics (coinDetailModel:CoinDetailModel?,coinModel:CoinModel) -> (overview:[StatisticModel],addtional:[StatisticModel]) {
        
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel)
        
        return (overviewArray,additionalArray)
    }
    
    private func createOverviewArray(coinModel:CoinModel)->[StatisticModel]{
        //overview
        let price = coinModel.currentPrice.asCurrencyWith2Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price,percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap,percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray:[StatisticModel] = [
            priceStat,marketCapStat,rankStat,volumeStat
        ]
        
        return overviewArray
    }
    
    
    private func createAdditionalArray (coinModel:CoinModel, coinDetailModel:CoinDetailModel?) -> [StatisticModel] {
        
        //additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.high24H?.asCurrencyWith2Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24H Pirce Change", value: priceChange,percentageChange: pricePercentChange)
        let marketCapChange = "$"+( coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange,percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray:[StatisticModel] = [
            highStat,lowStat,priceChangeStat,marketCapChangeStat,blockStat,hashingStat
        ]
        
        return additionalArray
    }
    
}
