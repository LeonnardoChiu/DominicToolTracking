//
//  FriendDetailViewController.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 01/10/21.
//

import UIKit

class FriendDetailViewController: UIViewController {

    // passed variables
    var selectedFriend: Friend!
    
    // content
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        
        return tableView
    }()
    
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
        navigationItem.title = "\(selectedFriend.name) Loaned Tools"
        
    }
    
}

extension FriendDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedFriend.borrowedTools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        if selectedFriend.borrowedTools.count != 0 {
            let toolData = selectedFriend.borrowedTools[indexPath.row]
            cell.textLabel?.text = toolData.name
            cell.detailTextLabel?.text = "\(toolData.totalLoaned) Loaned"
            
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let toolData = selectedFriend.borrowedTools[indexPath.row]
        showReturnedToolAlert(tool: toolData)
    }
    
    private func showReturnedToolAlert(tool: FriendLoanedTool) {
        let alert = UIAlertController(title: "Return Tool",
                                      message: "Has this tool (\(tool.name)) returned?",
                                      preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.updateFriendLog(with: tool)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true)
    }
    
    private func updateFriendLog(with tool: FriendLoanedTool) {
        if let index = selectedFriend.borrowedTools.firstIndex(where: {$0.name == tool.name}) {
            selectedFriend.borrowedTools[index].totalLoaned -= 1
            
            if selectedFriend.borrowedTools[index].totalLoaned == 0 {
                
                selectedFriend.borrowedTools.remove(at: index)
                
                // check if friend still loan any tools
                if selectedFriend.borrowedTools.count == 0 {
                    // not loans any tools
                    // delete entity
                    doDeleteFriendLogData()
                    
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    // still have loans tools
                    self.doUpdateFriendLogData()
                }
            }
            else {
                // update entity
                self.doUpdateFriendLogData()
            }
            
            self.tableView.reloadData()
        }
    }
}


// MARK: CORE DATA
extension FriendDetailViewController {
    private func doUpdateFriendLogData() {
        FriendLoansCoreData.updateFriendLoans(selectedFriend)
    }
    
    private func doDeleteFriendLogData() {
        FriendLoansCoreData.deleteFriendData(name: selectedFriend.name)
    }
}
