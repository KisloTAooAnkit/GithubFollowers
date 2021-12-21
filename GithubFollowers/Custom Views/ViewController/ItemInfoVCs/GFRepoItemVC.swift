//
//  GFRepoItemVC.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 21/12/21.
//

import Foundation

class GFRepoItemVC : GFItemInfoVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoView1.set(iteminfoType: .repos, withCount: user.publicRepos)
        itemInfoView2.set(iteminfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Github Profile")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGithubProfile(for: user)
    }
}
