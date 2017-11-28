//
//  BookAPIClient.swift
//  LoadingImagesBooks
//
//  Created by C4Q  on 11/28/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BookAPIClient {
    private init() {}
    static let manager = BookAPIClient()
    func getBooks(from urlStr: String,
                  completionHandler: @escaping ([Book]) -> Void,
                  errorHandler: @escaping (AppError) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let bookInfo = try JSONDecoder().decode(BookInfo.self, from: data)
                let books = bookInfo.items
                completionHandler(books)
            }
            catch {
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}
