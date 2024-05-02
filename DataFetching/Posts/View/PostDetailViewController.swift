//
//  ViewController.swift
//  DataFetching
//
//  Created by akshaygupta on 02/05/24.
//

import UIKit

class PostDetailViewController: UIViewController {
    var viewModel: PostDetailViewModel!
    var post: Post?
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bodyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = post else{return}
        viewModel = PostDetailViewModel(post: post)
        titleLabel.text = viewModel.camelCase(from: post.title)
        imageView.contentMode = .scaleAspectFill
        bodyLabel.text = post.body
        fetchImage()
    }
    
    private func fetchImage() {
        viewModel.fetchImageIfNeeded{ [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            case .failure(let error):
                print("Error fetching image: \(error.localizedDescription)")
            }
        }
    }
}

