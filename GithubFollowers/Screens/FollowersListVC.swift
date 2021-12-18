 //
//  FollowersListVC.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 17/12/21.
//

import UIKit

class FollowersListVC: UIViewController {

    var username : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            
            
            switch result {
                
            case .success(let followers):
                print("followers count = \(followers.count) ")
                print(followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Close")
            }

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
