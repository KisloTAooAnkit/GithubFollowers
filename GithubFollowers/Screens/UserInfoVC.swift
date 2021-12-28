//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 21/12/21.
//

import UIKit

protocol FollowerListVCDelegate : AnyObject {
    func didRequestFollowers(for username : String)
}

class UserInfoVC: UIViewController {
    
    
    var follower : Follower!
    var username : String!
    
    private var starFilled = UIImage(systemName: "star.fill")
    private var starEmpty = UIImage(systemName: "star")
    
    weak var delegate : FollowerListVCDelegate!
    
    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var itemViews = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        layoutUI()
        getUserInfo()
        
    }
    
    init(follower : Follower){
        super.init(nibName: nil, bundle: nil)
        self.username = follower.login
        self.follower = follower
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureVC(){
        
        let addToFollowersButton = UIBarButtonItem(image: starEmpty, style: .done, target: self, action: nil)
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = addToFollowersButton
    }
    
    
    func getUserInfo(){
    
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else {return}
            switch result {
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
                break
            case .success(let user):
                
                DispatchQueue.main.async {
                    self.configureUIElement(with: user)
                }
            
            }
        }
    }
    
    func configureUIElement(with user : User) {
        
        let repoItemVc = GFRepoItemVC(user: user)
        repoItemVc.delegate = self
        
        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self
        
        
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVc, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "Github since \(user.createdAt.convertToDisplayFormat())"
    }
    
    
    func layoutUI(){
        
        itemViews = [headerView,itemViewOne,itemViewTwo,dateLabel]
        
        let padding : CGFloat = 20
        let itemHeight : CGFloat = 180
        

        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
            
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant : padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -padding),
            
            ])
            
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor , constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor , constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor,constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childVC : UIViewController , to containerView :UIView){
        addChild(childVC)
        //childVC.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func updateFollowerStatus(){
        
    }
    
    @objc func dismissVC(){
        dismiss(animated: true, completion: nil)
    }
}

extension UserInfoVC : UserInfoVCDelegate {
    func didTapGithubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "Unable to fetch user's profile from github.", buttonTitle: "Ok")
            return
        }
        
        presentSafariVC(url: url)

    }
    
    func didTapGetFollowers(for user: User) {
        //
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers", message: "Unfortunately this user has no followers", buttonTitle: "Ok")
            return
            
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
    
    
    
}
