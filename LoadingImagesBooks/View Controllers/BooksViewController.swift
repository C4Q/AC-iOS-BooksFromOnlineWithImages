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

        BookAPIClient.manager.getBooks(from: urlStr) { (result) in
            switch result {
            case let .success(books):
                self.books = books
            case let .failure(error):
                switch error {
                //ToDo: - Add better error handling
                case .couldNotParseJSON(let error):
                    print("JSONError: \(error)")
                case .noInternetConnection:
                    print("No internet connection")
                default:
                    print("An error occurred: \(error)")
                }
            }
        }
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
        
        ImageAPIClient.manager.getImage(from: imageUrlStr) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(image):
                cell.imageView?.image = image
                cell.setNeedsLayout() //Makes the image load as soon as it's ready
            }
        }
        
        return cell
    }
}

extension BooksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTerm = searchBar.text ?? ""
        searchBar.resignFirstResponder()
    }
}
