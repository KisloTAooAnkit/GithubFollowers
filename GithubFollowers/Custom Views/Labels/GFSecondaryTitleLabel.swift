//
//  GFSecondaryTitleLabel.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 21/12/21.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(fontSize : CGFloat){
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize,weight: .medium)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }

}
