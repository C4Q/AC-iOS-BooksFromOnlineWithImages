//
//  BooksViewController.swift
//  LoadingImagesBooks
//
//  Created by C4Q  on 11/28/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BooksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var books = [Book]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var searchTerm = "" {
        didSet {
            loadNewBooks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    func loadNewBooks() {
        let urlStr = "https://www.googleapis.com/books/v1/volumes?q=\(searchTerm)&maxResults=40"
        let completion: ([Book]) -> Void = {(onlineBooks: [Book]) in
            self.books = onlineBooks
        }
        let errorHandler: (AppError) -> Void = {(error: AppError) in
            switch error {
            //To Do - Don't load errors into search bar
            case .couldNotParseJSON(let error):
                self.searchBar.text = "JSONError: \(error)"
            case .noInternetConnection:
                self.searchBar.text = "No internet connection"
            default:
                self.searchBar.text = "Other error"
            }
        }
        BookAPIClient.manager.getBooks(from: urlStr,
                                       completionHandler: completion,
                                       errorHandler: errorHandler)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BookDetailViewController {
            destination.book = books[self.tableView.indexPathForSelectedRow!.row]
        }
    }
}

extension BooksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Book Cell", for: indexPath)
        let book = books[indexPath.row]
        cell.textLabel?.text = book.volumeInfo.title
        cell.detailTextLabel?.text = book.volumeInfo.subtitle
        cell.imageView?.image = nil //Gets rid of flickering
        guard let imageUrlStr = book.volumeInfo.imageLinks?.smallThumbnail else {
            return cell
        }
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            cell.imageView?.image = onlineImage
            cell.setNeedsLayout() //Makes the image load as soon as it's ready
        }
        ImageAPIClient.manager.getImage(from: imageUrlStr,
                                        completionHandler: completion,
                                        errorHandler: {print($0)})
        return cell
    }
}

extension BooksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTerm = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}
