//
//  BookDetailViewController.swift
//  LoadingImagesBooks
//
//  Created by C4Q  on 11/28/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

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
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            self.coverImageView.image = onlineImage
            self.coverImageView.setNeedsLayout()
        }
        ImageAPIClient.manager.getImage(from: imageURLStr,
                                        completionHandler: completion,
                                        errorHandler: {print($0)})
    }
}
