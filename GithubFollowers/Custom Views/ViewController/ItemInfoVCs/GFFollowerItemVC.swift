//
//  GFFollowerItemVC.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 21/12/21.
//

import Foundation


class GFFollowerItemVC : GFItemInfoVC {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoView1.set(iteminfoType: .following, withCount: user.following)
        itemInfoView2.set(iteminfoType: .followers, withCount: user.followers)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
    }
}
