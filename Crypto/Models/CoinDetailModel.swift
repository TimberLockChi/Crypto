
import Foundation


/*
 URL:https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&developer_data=false&sparkline=false
 */
struct CoinDetailModel:Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    //如果设置Codable属性，必须为所有的变量设置键值
    enum CodingKeys:String,CodingKey{
        case id,symbol,name,description,links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
}


struct Description:Codable {
    let en: String?
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    //设置解析键值
    enum CodingKeys: String, CodingKey{
        case homepage 
        case subredditURL = "subreddit_url"
    }
    
}
