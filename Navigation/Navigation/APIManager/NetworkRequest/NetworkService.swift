//
//  NetworkService.swift
//  Navigation
//
//  Created by Александр on 31.03.2023.
//

import Foundation

final class NetworkService {

    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {

        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                completion(.success(data))
            }
        }.resume()
    }
}
