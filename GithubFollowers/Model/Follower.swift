//
//  Follower.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 18/12/21.
//

import Foundation

struct Follower : Codable , Hashable {
    var login : String
    var avatarUrl : String
    //var isFavourite : Bool = false
}
