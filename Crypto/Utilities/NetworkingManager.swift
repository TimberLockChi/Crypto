//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/17.
//

import Foundation
import Combine


class NetworkingManager{
    
    static var instance = NetworkingManager()
    
    private init(){
        
    }
    
    func download(url:URL) -> AnyPublisher<Data,Error> {
       return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on:DispatchQueue.global(qos: .default))
            .tryMap { output -> Data in
                guard
                    let reponse = output.response as? HTTPURLResponse,
                    reponse.statusCode >= 200 && reponse.statusCode < 300 else{
                    //校验回应是否出现错误
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()//抹除具体的Publisher类型
    }
    func handleCompletion(completion:Subscribers.Completion<Error>){
        switch completion {
        case .finished:
            break
        case.failure(let error):
            print(error.localizedDescription)
        }
    }
}
