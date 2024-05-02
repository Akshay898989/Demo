//
//  Post.swift
//  DataFetching
//
//  Created by akshaygupta on 02/05/24.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let userId: Int
    let body: String
}
