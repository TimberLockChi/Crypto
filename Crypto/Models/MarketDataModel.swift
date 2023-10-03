//
//  MarketDataModel.swift
//  Crypto
//
//  Created by Chi Tim on 2023/9/26.
//

import Foundation


//https://api.coingecko.com/api/v3/global
/*
 {"data":{"active_cryptocurrencies":10156,"upcoming_icos":0,"ongoing_icos":49,"ended_icos":3376,"markets":870,"total_market_cap":{"btc":41355179.008700594,"eth":683025059.0484611,"ltc":16915073508.237547,"bch":5087125913.946162,"bnb":5112834268.3390045,"eos":1928529107532.1174,"xrp":2159693253725.9639,"xlm":9733364117584.285,"link":147473760419.11465,"dot":270276210001.612,"yfi":209018661.3292877,"usd":1083050404711.0464,"aed":3978065797511.765,"ars":379094826214024.25,"aud":1688899053652.762,"bdt":119416165044176.34,"bhd":408260182257.44775,"bmd":1083050404711.0464,"brl":5377995089633.186,"cad":1462545851269.7708,"chf":988867258466.9672,"clp":979294175939729.5,"cny":7916773543316.319,"czk":24973582740053.93,"dkk":7625361503122.334,"eur":1022541461650.2449,"gbp":889056582320.011,"hkd":8470529633892.251,"huf":397433374661368.4,"idr":1.6756844234933236e+16,"ils":4137478903530.7793,"inr":90159010731500.38,"jpy":161269995937891.12,"krw":1462790637990044.2,"kwd":334849942775.72833,"lkr":350979601258260.7,"mmk":2.274460217940461e+15,"mxn":18854651207549.844,"myr":5079506398094.822,"ngn":844281112488449.2,"nok":11698080490753.83,"nzd":1816238704986.663,"php":61819976658754.56,"pkr":309755300993637.06,"pln":4711988405961.79,"rub":104345955131935.17,"sar":4062813408630.0005,"sek":11909263406118.023,"sgd":1480861316663.8416,"thb":39428037341301.414,"try":29532518795023.56,"twd":34875089472019.45,"uah":40001997737177.22,"vef":108445837023.71692,"vnd":2.640942377742188e+16,"zar":20548931938663.62,"xdr":823004587287.9003,"xag":47125006888.03191,"xau":567745852.6535783,"bits":41355179008700.59,"sats":4135517900870059.5},"total_volume":{"btc":1078628.0834876278,"eth":17814697.65275268,"ltc":441179889.8610518,"bch":132682701.57567394,"bnb":133353228.30758673,"eos":50300003652.98463,"xrp":56329239795.999855,"xlm":253866145321.92923,"link":3846418837.459683,"dot":7049359170.830932,"yfi":5451636.372685672,"usd":28248181010.36873,"aed":103756133814.70448,"ars":9887572382972.408,"aud":44049959233.939865,"bdt":3114619071336.7036,"bhd":10648264824.582533,"bmd":28248181010.36873,"brl":140269167625.0873,"cad":38146202395.49681,"chf":25791690941.526005,"clp":25542005269575.44,"cny":206485728731.49188,"czk":651362376718.4476,"dkk":198885103659.75592,"eur":26669983385.50044,"gbp":23188423324.153446,"hkd":220928825944.82648,"huf":10365879425520.63,"idr":437052945137152.5,"ils":107913955329.43965,"inr":2351532342152.3335,"jpy":4206253021077.435,"krw":38152586936376.11,"kwd":8733574867.51873,"lkr":9154269518910.848,"mmk":59322598152212.8,"mxn":491768063500.5473,"myr":132483968938.62971,"ngn":22020587024822.844,"nok":305109987253.8618,"nzd":47371239116.23396,"php":1612392076229.5227,"pkr":8079055022119.659,"pln":122898344187.29512,"rub":2721557016594.368,"sar":105966525730.58484,"sek":310618071820.8924,"sgd":38623907384.56321,"thb":1028364267125.5078,"try":770268800958.0809,"twd":909614027078.681,"uah":1043334334155.5905,"vef":2828490364.568217,"vnd":688812062669589.1,"zar":535958387945.9279,"xdr":21465651508.874134,"xag":1229117055.7691233,"xau":14807978.967445407,"bits":1078628083487.6278,"sats":107862808348762.78},"market_cap_percentage":{"btc":47.14395746152663,"eth":17.593939849054458,"usdt":7.678156994843639,"bnb":3.00835168965056,"xrp":2.4662616481076856,"usdc":2.366082798180712,"steth":1.2771857520725176,"ada":0.794521793457726,"doge":0.7902157354472129,"sol":0.7346319115620176},"market_cap_change_percentage_24h_usd":0.39406720452496463,"updated_at":1695737288}}
 */

struct GlobalData:Codable {
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel:Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    
    enum CodingKeys:String,CodingKey{
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap:String{
        //获取totalMarketCap键位usd的内容
//        if let item = totalMarketCap.first(where: { (key,value) -> Bool in
//            return key == "usd"
//        }){
//            return "\(item.value)"
//        }
        if let item = totalMarketCap.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String{
        if let item = totalVolume.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance:String{
        //占总市值的比例
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}){
            return item.value.asPercentString()
        }
        return ""
    }
}
