//
//  MarketDataService.swift
//  Crypto
//
//  Created by Chi Tim on 2023/10/2.
//

import Foundation
import Combine

class MarketDataService{
    
    let url = "https://api.coingecko.com/api/v3/global"
    
    @Published var marketData: MarketDataModel?
    
    var marketDataSubscription: AnyCancellable?
    
    init(){
        getData()
    }
    
    private func getData(){
        guard let url = URL(string: url) else{
            return
        }
        //持续监听，通过coinSubscription访问
        marketDataSubscription = NetworkingManager.download(url:url)//网络层工具下载
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: {[weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()//当前请求是可知的只会传递一次结果，所以可以直接取消
            })
    }
}

