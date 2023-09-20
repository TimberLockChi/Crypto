//
//  CoinImageService.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/20.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService{
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin:CoinModel
    init(coin:CoinModel){
        self.coin = coin
        getCoinImage()
    }
    private func getCoinImage(){
        guard let url = URL(string: coin.image) else{
            return
        }
        //持续监听，通过coinSubscription访问
        imageSubscription = NetworkingManager.download(url:url)//网络层工具下载
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: {[weak self] (returnImage) in
                self?.image = returnImage
                self?.imageSubscription?.cancel()//当前请求是可知的只会传递一次结果，所以可以直接取消
            })
    }
}
