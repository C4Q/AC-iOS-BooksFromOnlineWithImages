//
//  ImageAPIClient.swift
//  LoadingImagesBooks
//
//  Created by C4Q  on 11/28/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage) -> Void,
                  errorHandler: @escaping (AppError) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {
                errorHandler(.notAnImage)
                return
            }
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}
