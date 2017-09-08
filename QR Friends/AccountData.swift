import Foundation
import Locksmith

var accountData = AccountData()

enum SocialNetwork: CustomStringConvertible {
    case vk
    
    init?(string: String) {
        switch string {
        case "vk": self = .vk
        default  : return nil
        }
    }
    
    var description: String {
        switch self {
        case .vk: return "vk"
        }
    }
}

struct AccountData {
    static let userAccount = "default"
    
    var keys = [SocialNetwork:String]()
    
    init() {
//        flush()
        
        let data = Locksmith.loadDataForUserAccount(userAccount: AccountData.userAccount)
        
        keys = Dictionary(pairs: (data ?? [:]).map {
            net, key in (SocialNetwork(string: net)!, key as! String)
        })
    }
    
    func flush() {
        try? Locksmith.saveData(
            data: Dictionary(pairs: keys.map {net, key in (net.description, key as Any)}),
            forUserAccount: AccountData.userAccount
        )
    }
    
    func getKey(socialNetwork: SocialNetwork) -> String? {
        return keys[socialNetwork]
    }
    
    mutating func setKey(_ key: String, forSocialNetwork network: SocialNetwork) {
        keys[network] = key
        flush()
    }
}
