//
//  CoinDataService.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/14.
//

import Foundation
import Combine

class CoinDataService{
    
    let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en"
    
    @Published var allCoins: [CoinModel] = []//发生变化时，允许其他方法对其进行监听
    
    var coinSubscription: AnyCancellable?
    
    init(){
        getCoins()//初始化时就进行请求
    }
    
    func getCoins(){
        guard let url = URL(string: url) else{
            return
        }
        //持续监听，通过coinSubscription访问
        coinSubscription = NetworkingManager.download(url:url)//网络层工具下载
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: {[weak self] (returnCoins) in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()//当前请求是可知的只会传递一次结果，所以可以直接取消
            })
    }
}
