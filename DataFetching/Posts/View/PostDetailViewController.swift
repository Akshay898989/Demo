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
    //private let imageView = UIImageView()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bodyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setupImageView()
        imageView.contentMode = .scaleAspectFill
        bodyLabel.text = post?.body
        fetchImage()
    }
    
//    private func setupImageView() {
//        imageView.frame = view.bounds  // Example setup, adjust as needed
//        imageView.contentMode = .scaleAspectFit
//        view.addSubview(imageView)
//    }
//
    private func fetchImage() {
        guard let post = post else{return}
        viewModel = PostDetailViewModel(post: post)
        viewModel.fetchImageIfNeeded{ [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            case .failure(let error):
                print("Error fetching image: \(error.localizedDescription)")
                // Optionally handle the error by showing an alert or a placeholder image
            }
        }
    }
}

