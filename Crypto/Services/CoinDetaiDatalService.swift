//
//  CoinDetailService.swift
//  Crypto
//
//  Created by Chi Tim on 2023/10/25.
//

import Foundation
import Combine

class CoinDetaiDatalService{
    
    @Published var coinDetails: CoinDetailModel?
    
    
    var url:String
    var coin:CoinModel
    var coinDetailSubscription:AnyCancellable?
    
    init(coin:CoinModel){
        self.coin = coin
        self.url = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&developer_data=false&sparkline=false"
        getCoinDetail()
    }
    
    
    func getCoinDetail(){
        guard let url = URL(string: url) else {return}
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] returnedCoinDetails in
                    self?.coinDetails = returnedCoinDetails
                    self?.coinDetailSubscription?.cancel()//获取成功后，将取消订阅
            })
        
    }
    
    
}
