//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/17.
//

import Foundation
import Combine


class NetworkingManager{
    
    //报错信息自定义
    enum NetworkingError:LocalizedError{
        //可以自定义错误类型
        case badURLResponse(url:URL)//可以传入参数
        case unknown
        //对应枚举信息的错误信息描述
        var errorDescription: String?{
            switch self{
            case .badURLResponse(url:let url): return "Bad response from URL:\(url)"
            case .unknown: return "Unknown error occured"
            }
        }
    }
    
    private init(){
        
    }
    
    static func download(url:URL) -> AnyPublisher<Data,Error> {
       return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on:DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0,url: url)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()//抹除具体的Publisher类型
    }
    
    static func handleURLResponse(output:URLSession.DataTaskPublisher.Output,url:URL) throws -> Data {
        guard
            let reponse = output.response as? HTTPURLResponse,
            reponse.statusCode >= 200 && reponse.statusCode < 300 else{
                //校验回应是否出现错误
                throw NetworkingError.badURLResponse(url: url)
            }
        return output.data
    }
    
    static func handleCompletion(completion:Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            break
        case.failure(let error):
            print(error.localizedDescription)
        }
    }
}
