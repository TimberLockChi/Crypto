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
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin:CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
            print("Retrieved image from File Manager!")
        }else{
            downloadCoinImage()
            print("Downloading image now")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else{
            return
        }
        
        //持续监听，通过coinSubscription访问
        imageSubscription = NetworkingManager.download(url:url)//网络层工具下载
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: {[weak self] (returnImage) in
                    //保证self存在，保证returnImage存在
                    guard
                        let self = self,
                        let downloadedImage = returnImage
                    else {
                        return
                    }
                    self.image = downloadedImage
                    self.image = returnImage
                    self.imageSubscription?.cancel()//当前请求是可知的只会传递一次结果，所以可以直接取消
                    self.fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)//传入的参数必须要保证存在，例如downloadedImage，传入returnImage会报错
            })
    }
}
