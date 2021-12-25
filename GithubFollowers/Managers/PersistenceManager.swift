//
//  PersistenceManager.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 22/12/21.
//

import Foundation

enum PersistenceActionType {
    case add
    case remove
}


enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    
    static func updateWith(favorite : Follower ,actionType : PersistenceActionType ,completion : @escaping(GFError?)->Void){
        
        retrieveFavorites { result in
            switch result {
                
                
            case .success(let favorites):
                var tempFavorites = favorites
                
                switch actionType {
                case .add:
                    
                    guard !tempFavorites.contains(where: { follower in
                        follower.login == favorite.login
                    }) else {
                        completion(.alreadyAddedInFav)
                        return
                    }
                    tempFavorites.append(favorite)
                    
                    
                case .remove:
                   tempFavorites.removeAll { follower in
                        follower.login == favorite.login
                    }
                }
                
                
                let updateStatus = saveFavorites(favorites: tempFavorites)
                completion(updateStatus)
                
                
                
                
            case .failure(let error):
                completion(error)
            }
        }
        
    }
    
    
    static func retrieveFavorites(completed : @escaping(Result<[Follower],GFError>)->Void){
        
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data  else {
            completed(.success([]))
            return
        }
        do {
            
            let decoder = JSONDecoder()
            let favorites = try! decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
            
        } catch {
            completed(.failure(.unableToFavorite))
        }
        
    }
    
    static func saveFavorites(favorites : [Follower]) -> GFError? {
        
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try! encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
            
        } catch {
            return .unableToFavorite
        }
    }
}
