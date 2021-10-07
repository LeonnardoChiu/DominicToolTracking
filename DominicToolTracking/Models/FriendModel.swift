//
//  FriendModel.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 01/10/21.
//

import Foundation

struct Friend {
    let name: String
    var borrowedTools: [FriendLoanedTool]
}

struct FriendLoanedTool: Codable {
    let name: String
    var totalLoaned: Int
    
    func createDic() -> [String: Any]? {
        guard let result = self.createDictionary else {
            return nil
        }
        
        return result
    }
}

func getFriendList() -> [String] {
    return ["Brian",
            "Luke",
            "Letty",
            "Shaw",
            "Parker"]
}
