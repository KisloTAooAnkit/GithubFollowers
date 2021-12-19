//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 19/12/21.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    
    let placeHolderImage = UIImage(named: "avatar-placeholder")! //forceunwrapping cuz we know we stored this image in xcassets
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
