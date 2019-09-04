//
//  BookAPIClient.swift
//  LoadingImagesBooks
//
//  Created by C4Q  on 11/28/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BookAPIClient {
    static let manager = BookAPIClient()
    
    func getBooks(from urlStr: String,
                  completionHandler: @escaping (Result<[Book], AppError>) -> Void) {
        guard let url = URL(string: urlStr) else {
            completionHandler(.failure(.badURL))
            return
        }

        NetworkHelper.manager.getData(from: url) { (result) in
            switch result {
            case let .failure(error):
                completionHandler(.failure(error))
                return
            case let .success(data):
                do {
                    let bookInfo = try JSONDecoder().decode(BookInfo.self, from: data)
                    let books = bookInfo.items
                    completionHandler(.success(books))
                }
                catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
    
    private init() {}
}
