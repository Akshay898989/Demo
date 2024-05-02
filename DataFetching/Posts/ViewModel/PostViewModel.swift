//
//  PostViewModel.swift
//  DataFetching
//
//  Created by akshaygupta on 02/05/24.
//

import Foundation

class PostViewModel {
    private(set) var posts = [Post]()
    private var currentPage = 1
    private let limit = 10
    private var isFetching = false
    
    func fetchPosts(completion: @escaping(Result<Void, PostError>) -> Void) {
        guard !isFetching else {
            completion(.failure(PostError.alreadyFetchingPosts))
            return
        }
        isFetching = true
        
        let urlString = "https://jsonplaceholder.typicode.com/posts?_limit=\(limit)&_page=\(currentPage)"
        guard let url = URL(string: urlString) else {
            completion(.failure(PostError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            do {
                var backToString = String(data: data, encoding: String.Encoding.utf8) as String?
                print(backToString)
                let fetchedPosts = try JSONDecoder().decode([Post].self, from: data)
                dump(fetchedPosts)
                DispatchQueue.main.async{
                    self.posts += fetchedPosts
                    self.currentPage += 1
                    self.isFetching = false
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async{
                    self.isFetching = false
                    completion(.failure(PostError.decodingError))
                }
            }
        }.resume()
    }
    
}


enum PostError: Error, LocalizedError {
    case invalidURL
    case alreadyFetchingPosts
    case decodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .alreadyFetchingPosts:
            return "The system is already fetching posts."
        case .decodingError:
            return "There was an error decoding the data."
        }
    }
}
