//
//  FavouritesListVC.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 16/12/21.
//

import UIKit

class FavouritesListVC: UIViewController {

    let tableView = UITableView()
    var favorites = [Follower]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    func getFavorites(){
        PersistenceManager.retrieveFavorites { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
                
            case .success(let favorites):
                
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No favorites\n Add one from follower screen", view: self.view)
                }
                self.favorites = favorites
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
                
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func configureVC(){
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.reuseID)
    }

}

extension FavouritesListVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.reuseID) as! FavoritesCell
        cell.set(favourite: favorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowersListVC()
        destVC.username = favorite.login
        destVC.title = favorite.login
        //navigationController?.pushViewController(destVC, animated: true)
        present(destVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        let favorite = favorites[indexPath.row]
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else {return}
            guard let error = error else {return}
            
            self.presentGFAlertOnMainThread(title: "Unable to delete", message: error.rawValue, buttonTitle: "Ok")
        }
        
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        

        
    }
    
    
    
}
