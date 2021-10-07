//
//  ViewController.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 30/09/21.
//

import UIKit

protocol LoanToolDelegate {
    func didLoaned(friendName: String, tool: Tool)
}

class DashboardViewController: UIViewController {

    // content
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        
        return tableView
    }()
    
    // variables
    private var toolList: [Tool] = []
    private var friendLoanList: [Friend] = []
    
    // picker view
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraint()
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraint() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        styleDefaultTabBar()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Dominic Tool Tracker"
        
        self.toolList = getDefaultTools()
        getFriendLoans()
        
    }

}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toolList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        if toolList.count != 0 {
            let toolData = toolList[indexPath.row]
            cell.textLabel?.text = toolData.name
            cell.detailTextLabel?.text = "Loaned: \(toolData.totalLoaned)/\(toolData.count)"
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tool = toolList[indexPath.row]
        
        if tool.totalLoaned == tool.count {
            self.showMaximumToolLoanedAlert()
        }
        else {
            showLoanAlert(with: tool)
        }
        
    }
    
    private func showMaximumToolLoanedAlert() {
        let alert = UIAlertController(title: "No Tool Available",
                                      message: "there are no tool left to loan",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showLoanAlert(with tool: Tool) {
        let  vc = LoanAlertViewController()
        
        vc.selectedTool = tool
        vc.delegate = self
        
        vc.modalPresentationStyle = .overFullScreen
        
        navigationController?.present(vc, animated: false)
    }
    
    private func getTotalLoanedPerItems(from friend: Friend) {
        for (index, tool) in toolList.enumerated() {
            if let loanedTool = friend.borrowedTools.first(where: {$0.name == tool.name}) {
                toolList[index].totalLoaned += loanedTool.totalLoaned
            }
        }
        
        self.tableView.reloadData()
    }
    
}

extension DashboardViewController: LoanToolDelegate {
    func didLoaned(friendName: String, tool: Tool) {
        if let index = toolList.firstIndex(where: {$0.name == tool.name}) {
            toolList[index] = tool
        }
        
        self.tableView.reloadData()
        
        self.doSaveLog(friendName: friendName, loanedTool: tool)
    }
    
}

// MARK: CORE DATA
extension DashboardViewController {
    private func getFriendLoans() {
        
        self.tableView.reloadData()
        
        if let friends = FriendLoansCoreData.fetchFriendLoans() {
            self.friendLoanList = friends
            
            if friends.count != 0 {
                friends.forEach { friend in
                    self.getTotalLoanedPerItems(from: friend)
                }
                
                self.tableView.reloadData()
            }
        }
        
//        FriendLoansCoreData.fetchFriendLoans { friends, error in
//            if let error = error {
//                print(error)
//            }
//            else {
//                if let friends = friends {
//                    self.friendLoanList = friends
//
//                    if self.friendLoanList.count != 0 {
//                        self.friendLoanList.forEach { friend in
//                            self.getTotalLoanedPerItems(from: friend)
//                        }
//
//                        self.tableView.reloadData()
//                    }
//
//                }
//            }
//        }
    }
    
    private func doSaveLog(friendName: String, loanedTool: Tool) {
        // check if friend already loan
        if let friendIndex = friendLoanList.firstIndex(where: {$0.name == friendName}) {
            // update data
            
            var friendData = friendLoanList[friendIndex]
            
            // check if tool exist
            if let toolIndex = friendData.borrowedTools.firstIndex(where: {$0.name == loanedTool.name}) {
                // tool exsist
                friendData.borrowedTools[toolIndex].totalLoaned += 1
                
            }
            else {
                // insert new tool
                friendData.borrowedTools.append(FriendLoanedTool(name: loanedTool.name, totalLoaned: 1))
            }
            
            FriendLoansCoreData.updateFriendLoans(friendData)
            self.friendLoanList[friendIndex] = friendData
            
        }
        else {
            // save as new data
            let friend = Friend(name: friendName,
                                borrowedTools: [FriendLoanedTool(name: loanedTool.name,
                                                                 totalLoaned: 1)])
            
            FriendLoansCoreData.saveFriendLoans(friend)
            self.friendLoanList.append(friend)
        }
    }
}
