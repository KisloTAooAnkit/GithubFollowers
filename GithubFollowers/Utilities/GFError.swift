//
//  ErrorMessage.swift
//  GithubFollowers
//
//  Created by Ankit Singh on 18/12/21.
//

import Foundation

enum GFError : String ,Error {
    case invalidUsername = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server please try again"
    case invalidData = "The data recieved from server is invalid please try again"
}
