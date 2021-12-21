//
//  GFButton.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 17/12/21.
//

import UIKit

class GFButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor : UIColor , title : String){
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    
    private func configure(){
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    
    func set(backgroundColor : UIColor , title : String ){
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
}
