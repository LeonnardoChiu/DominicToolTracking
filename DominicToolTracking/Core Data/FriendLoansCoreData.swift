//
//  FriendLoansCoreData.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 01/10/21.
//

import UIKit
import CoreData

class FriendLoansCoreData {
    
    enum Keys: String {
        case name
        case loanedTools
    }
    
    static let friendLoansEntityName = "FriendLoans"
    
    static func saveFriendLoans(_ friend: Friend) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
            
        let entity = NSEntityDescription.entity(forEntityName: friendLoansEntityName, in: context)
        
        let newFriend = NSManagedObject(entity: entity!, insertInto: context)
        
        var friendLoanedToolDict: [[String:Any]] = []
        for tool in friend.borrowedTools {
            if let dict = tool.createDic() {
                friendLoanedToolDict.append(dict)
            }
        }
        
        guard let loanedToolJson = json(from: friendLoanedToolDict) else {
            print(">> Loaned Tool JSON Error")
            return
        }
        
        newFriend.setValue(friend.name, forKey: Keys.name.rawValue)
        newFriend.setValue(loanedToolJson, forKey: Keys.loanedTools.rawValue)
        
        do {
            try context.save()
            print(">> Friend Loans saved")
        } catch {
            print(">> Failed Saving Friend Loans \(error)")
        }
        
    }
    
    static func fetchFriendLoans() -> [Friend]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        
        var friendResult: [Friend] = []
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: friendLoansEntityName)
        
        do {
            let result = try context.fetch(request)
            for data in result {
                let name = data.value(forKey: Keys.name.rawValue) as! String
                let loanedToolsJson = data.value(forKey: Keys.loanedTools.rawValue) as! String
                
                if let data = loanedToolsJson.data(using: .utf8) {
                    do {
                        let decodedLoanedTools: [FriendLoanedTool] = try JSONDecoder().decode([FriendLoanedTool].self, from: data)
                        
                        let friend = Friend(name: name, borrowedTools: decodedLoanedTools)
                        
                        friendResult.append(friend)
                    }
                    catch {
                        print(error)
                    }
                }
            }
            
            return friendResult
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    static func updateFriendLoans(_ friend: Friend) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: friendLoansEntityName)
        
        request.predicate = NSPredicate(format: "\(Keys.name.rawValue) = %@", friend.name)
        
        let results = try? context.fetch(request)
        
        if results?.count != 0 {
            var friendLoanedToolDict: [[String:Any]] = []
            for tool in friend.borrowedTools {
                if let dict = tool.createDic() {
                    friendLoanedToolDict.append(dict)
                }
            }
            
            guard let loanedToolJson = json(from: friendLoanedToolDict) else {
                print(">> Loaned Tool JSON Error")
                return
            }
            
            let friendData = results?.first
            friendData?.setValue(friend.name, forKey: Keys.name.rawValue)
            friendData?.setValue(loanedToolJson, forKey: Keys.loanedTools.rawValue)
            
            do {
                try context.save()
            } catch {
                print(">> Failed Update Friend Loans \(error)")
            }
        }
    }
    
    static func deleteFriendData(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: friendLoansEntityName)
        
        request.predicate = NSPredicate(format: "\(Keys.name.rawValue) = %@", name)
        
        if let results = try? context.fetch(request) {
            for object in results {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
            print(">> friend loans deleted")
        } catch {
            print(">> Failed Update friend loans \(error)")
        }
    }
}

func json(from object:Any) -> String? {
    
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}

