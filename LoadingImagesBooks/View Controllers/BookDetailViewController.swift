import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = book.volumeInfo.title
        subtitleLabel.text = book.volumeInfo.subtitle
        authorLabel.text = book.volumeInfo.authors?.joined(separator: ",")
        descriptionTextView.text = book.volumeInfo.description
        loadImage()
        
    }
    func loadImage() {
        guard let imageURLStr = book.volumeInfo.imageLinks?.thumbnail else {
            return
        }
        
        ImageAPIClient.manager.getImage(from: imageURLStr) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(image):
                self.coverImageView.image = image
                self.coverImageView.setNeedsLayout()
            }
        }
    }
}
