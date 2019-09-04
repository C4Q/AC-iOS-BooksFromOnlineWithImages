import UIKit

class ImageAPIClient {
    static let manager = ImageAPIClient()
    
    func getImage(from urlStr: String,
                  completionHanlder: @escaping (Result<UIImage, AppError>) -> Void) {
        
        guard let url = URL(string: urlStr) else {
            completionHanlder(.failure(.badURL))
            return
        }
        
        NetworkHelper.manager.getData(from: url) { (result) in
            switch result {
            case let .failure(error):
                completionHanlder(.failure(error))
            case let .success(data):
                guard let onlineImage = UIImage(data: data) else {
                    completionHanlder(.failure(.notAnImage))
                    return
                }
                completionHanlder(.success(onlineImage))                
            }
        }
    }
    
    private init() {}
}
