//
//  NetworkDataFetch.swift
//  Navigation
//
//  Created by Александр on 31.03.2023.
//

import Foundation

final class NetworkDataFetcher {

    private let networkService = NetworkService()

    func fetchPost(urlString: String, response: @escaping (NewData?) -> Void) {

        networkService.request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(NewData?.self, from: data)
                    response(tracks)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
}

