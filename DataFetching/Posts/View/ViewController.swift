//
//  ViewController.swift
//  DataFetching
//
//  Created by akshaygupta on 02/05/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var viewModel = PostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Posts"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = spinner
        setupSpinner()
        fetchData()
    }
    
    private func setupSpinner() {
        spinner.hidesWhenStopped = true
    }
    private func fetchData() {
        viewModel.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
            }
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error): // Observing failure here if we want to update UI based on some specific error
                switch error{
                case .invalidURL:
                    print("Invalid url Detected")
                case .alreadyFetchingPosts:
                    // We can show some UI to the user
                    print("alreadyFetchingPosts")
                case .decodingError:
                    print("decodingError")
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postTableViewCell", for: indexPath)
        cell.textLabel?.text = "\(viewModel.posts[indexPath.row].id): \(viewModel.posts[indexPath.row].title)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // Added 100 condition as currently 100 records are coming and it will not call api after that
        // To make it dynamic total record of count needs to be present in api, then we can apply check accordingly
        if viewModel.posts.count<100 && indexPath.row == viewModel.posts.count - 1 {
            spinner.startAnimating()
            fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as? PostDetailViewController {
            detailVC.post = post  // Set the post
            navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
