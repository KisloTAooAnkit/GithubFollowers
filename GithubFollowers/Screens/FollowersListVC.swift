 //
//  FollowersListVC.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 17/12/21.
//

import UIKit




class FollowersListVC: UIViewController {

    
    enum Section{
        case main
    }
    
    
    var username : String!
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    
    var lastPageTillDataFetched = 1
    var hasMoreFollowers = false
    var isSearching = false
    
    var collectionView : UICollectionView!
    var dataSource : UICollectionViewDiffableDataSource<Section,Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
        configureSearchController()
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    
    func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    

    func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    
    
    func getFollowers(){
        self.showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: lastPageTillDataFetched) { [weak self] result in
            
            
            guard let self = self else {return}
            self.dismissLoadingView()
            switch result {
                
            case .success(let followers):
                //print("followers count = \(followers.count) ")
                //print(followers)
                self.followers.append(contentsOf: followers)
                self.hasMoreFollowers = !(followers.count < 100)
                
                if self.followers.isEmpty {
                    let message = "Lmao what an unpopular person do some clout 🖕"
                    
                    
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, view: self.view)
                    }
                    return
                }
                
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Close")
            }

        }
    }
    
    func configureDataSource(){
        self.dataSource = UICollectionViewDiffableDataSource<Section,Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell in
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers : [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section,Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        dataSource.apply(snapshot,animatingDifferences: true)
    }
    
    
    @objc func addButtonTapped(){
        
        showLoadingView()
        
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            
            guard let self = self else {return}
            self.dismissLoadingView()
            
            switch result {
                
            case .success(let user):
                
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { error in
                    
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success", message: "\(user.login) has been added to your favorites", buttonTitle: "Ok")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Oops", message: error.rawValue, buttonTitle: "Ok")
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Oops", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        
    }
    
    
}


extension FollowersListVC : UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentScrollOffsetY = scrollView.contentOffset.y
        let totalScrollHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        
        if currentScrollOffsetY > totalScrollHeight - screenHeight{
            guard hasMoreFollowers else { return }
            lastPageTillDataFetched += 1
            getFollowers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = isSearching ? filteredFollowers[indexPath.item] : followers[indexPath.item]
        
        let destVC = UserInfoVC()
        
        destVC.delegate = self
        
        destVC.username = follower.login
        
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true, completion: nil)
        
    }
}

extension FollowersListVC : UISearchResultsUpdating , UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            return
        }
        isSearching = true
        self.filteredFollowers = followers.filter({ follower in
            return follower.login.lowercased().contains(filter.lowercased())
        })
        
        self.updateData(on: self.filteredFollowers)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        updateData(on: self.followers)
        
    }
    
}

extension FollowersListVC : FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        //getFollowers
        self.username = username
        title = username
        lastPageTillDataFetched = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers()
    }
    
    
}
