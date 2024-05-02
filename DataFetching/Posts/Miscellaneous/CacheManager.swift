//
//  CacheManager.swift
//  DataFetching
//
//  Created by akshaygupta on 02/05/24.
//

import Foundation
import UIKit

class CacheManager {
    static let shared = CacheManager()
    private init() {} // Private initialization to ensure singleton instance

    var computationCache: [Int: UIImage] = [:]

    func cacheImage(_ image: UIImage, forId id: Int) {
        computationCache[id] = image
    }

    func getCachedImage(forId id: Int) -> UIImage? {
        return computationCache[id]
    }
}
