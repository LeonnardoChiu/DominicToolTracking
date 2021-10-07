//
//  FriendListViewController.swift
//  DominicToolTracking
//
//  Created by Leonnardo Hutama on 30/09/21.
//

import UIKit

class FriendListViewController: UIViewController {

    lazy var tableView: UITableView = {
       let tableView = UITableView()
        
        return tableView
    }()
    
    // variables
    private var friendList: [Friend] = []
    
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
        navigationItem.title = "Friend List"
        
        getFriendList()
    }
    
    private func getFriendList() {
        if let friendList = FriendLoansCoreData.fetchFriendLoans() {
            self.friendList = friendList
            self.tableView.reloadData()
        }
    }

}

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count == 0 ? 1 : friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if friendList.count == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "empty cell")
            
            cell.textLabel?.text = "No Friend Loaned Your Tools"
            cell.textLabel?.textAlignment = .center
            
            return cell
        }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        let friendData = friendList[indexPath.row]
        cell.textLabel?.text = friendData.name
        
        let count = friendData.borrowedTools.count
        let detailText = count == 1 ? "\(count) Tool Loaned" : "\(count) Tools Loaned"
        
        cell.detailTextLabel?.text = detailText
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let friendData = friendList[indexPath.row]
        
        pushToFriendDetailView(selectedFriend: friendData)
    }
    
    private func pushToFriendDetailView(selectedFriend: Friend) {
        let vc = FriendDetailViewController()
        
        vc.selectedFriend = selectedFriend
        
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
