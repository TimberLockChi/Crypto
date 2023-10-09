//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Chi Tim on 2023/10/7.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName:String = "PortfolioEntity"
    
    @Published var savedEntities:[PortfolioEntity] = []//可以配其他成员监听
    
    init() {
        self.container = NSPersistentContainer(name: containerName)
        self.container.loadPersistentStores { _, error in
            if let error = error{
                print("Error loading Core Data!\(error)")
            }
            self.getPortfolio()
        }
    }
    // MARK: PUBLIC
    func updatePortfolio(coin: CoinModel,amount: Double){
        //寻找id相同的第一个实体
//        if let entity = savedEntities.first(where: { savedEntity -> Bool in
//            return savedEntity.coinID == coin.id
//        }){
//            
//        }
        //上述写法的简化版
        //是否当前存储的内容中存在目标实体
        if let entity = savedEntities.first(where: {$0.coinID == coin.id}){
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else {
                delete(entity: entity)//数量小于等于0时，删除当前已存储的货币
            }
        } else{
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)//获取到本地存储实体
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio entities.\(error)")
        }
    }
    
    private func add(coin:CoinModel,amount:Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()//应用更新，拿到最新的savedEntities
    }
    
    private func update(entity:PortfolioEntity,amount:Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity:PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to CoreData.\(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
}
