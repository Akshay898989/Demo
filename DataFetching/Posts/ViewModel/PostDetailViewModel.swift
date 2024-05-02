//
//  PostDetailViewModel.swift
//  DataFetching
//
//  Created by akshaygupta on 02/05/24.
//

import Foundation
import UIKit
import os

// MARK: In this i have passed post and on the basis of id i am getting random image using url. So, in future when we will have api in which we can get data based on id, we can implement that(As in assignment no detail was mentioned)
class PostDetailViewModel {
    private let logger = os.Logger(subsystem: "com.yourdomain.yourapp", category: "ImageProcessing")
    
    var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    // Here image is cached. If image will be available already it will not download it
    func fetchImageIfNeeded(completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = CacheManager.shared.getCachedImage(forId: post.id) {
            completion(.success(cachedImage))
            return
        }
        
        // Start timing the image fetch process
        let startTime = CFAbsoluteTimeGetCurrent()
        
        loadImageFromSource { [weak self] result in
            let endTime = CFAbsoluteTimeGetCurrent()
            let timeElapsed = endTime - startTime
            self?.logger.log("Time taken to process the image: \(String(format: "%.3f", timeElapsed)) seconds")
            
            switch result {
            case .success(let image):
                CacheManager.shared.cacheImage(image, forId: self?.post.id ?? 0)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // this used to download image asynchronously without blocking main thread
    private func loadImageFromSource(completion: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global().async {
            let imageUrlString = "https://picsum.photos/id/\(self.post.id)/200/300"
            guard let url = URL(string: imageUrlString),
                  let imageData = try? Data(contentsOf: url),
                  let image = UIImage(data: imageData) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"])))
                }
                return
            }
            
            let processedImage = self.processImage(image)
            DispatchQueue.main.async {
                completion(.success(processedImage))
            }
        }
    }
    
    private func processImage(_ image: UIImage) -> UIImage {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let processedImage = image
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let processingTime = endTime - startTime
        self.logger.log("Time taken to process the image: \(String(format: "%.3f", processingTime)) seconds")
        
        return processedImage
    }
    
    func camelCase(from string: String) -> String {
        var result = ""
        let words = string.components(separatedBy: .whitespacesAndNewlines)
        
        for (index, word) in words.enumerated() {
            let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
            if index == 0 {
                result += trimmedWord.lowercased()
            } else {
                result += trimmedWord.prefix(1).uppercased() + trimmedWord.dropFirst().lowercased()
            }
        }
        
        return result
    }
}



