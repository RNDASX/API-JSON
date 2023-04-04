//
//  ViewController.swift
//  123
//
//  Created by Александр on 31.03.2023.
//

import UIKit


struct NewData: Decodable {

    var resultCount: Int
    var results: [Track]

}
struct Track: Decodable {

    var trackName: String?
    var artistName: String? // author
    var collectionId: Int? // likes
    var trackId: Int? // views
    var artworkUrl60: String? // image
    var collectionCensoredName: String? // description

}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://itunes.apple.com/search?term=jack+johnson&limit=95"
//        request(urlString: urlString) { newData, error in
//            newData?.results.map({ (track) in
//                print(track.trackName)
//            })
//        }

        request(urlString: urlString) { result in
            switch result {

            case .success(let newData):
                newData.results.map { track in
                    print(track)
                }
            case .failure(let error):
                print("Error")
            }
        }

    }

//  https://www.youtube.com/watch?v=7H287JaSERk&t=4509s&ab_channel=SwiftBook



    func request(urlString: String, completion: @escaping (Result<NewData, Error>) -> Void) {

        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}

                do {
                    let tracks = try JSONDecoder().decode(NewData.self, from: data)
                    completion(.success(tracks))

                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}

//    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
//
//        guard let url = URL(string: urlString) else {return}
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error)
//                    completion(nil, error)
//                    return
//                }
//                guard let data = data else {return}
//                let someString = String(data: data, encoding: .utf8)
//                print(someString ?? "no data")
//            }
//        }.resume()









//func fetchingAPIData(URL url: String, completion: @escaping ([NewData]) -> Void) {
//
//        let url = URL(string: url)
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: url!) { data, response, error in
//            do {
//                let parsingData = try JSONDecoder().decode([NewData].self, from: data!)
//                completion(parsingData)
//            } catch {
//                print("Parsing error")
//            }
//        }
//        .resume()
//    }






//    let urlString = "https://itunes.apple.com/lookup?amgArtistId=468749,5723&entity=album&limit=5"
//    guard let url = URL(string: urlString) else {return}
//    URLSession.shared.dataTask(with: url) { data, responce, error in
//        if let error = error {
//            print(error)
//            return
//        }
//
//        guard let data = data else {return}
//        //            let jsunString = String(data: data, encoding: .utf8)
//        //            print(jsunString)
//        do {
//            let newData = try JSONDecoder().decode(NewData.self, from: data)
//            print(newData.first?.resultCount)
//
//        } catch {
//            print(error)
//
//        }
//
//
//    }
//}.resume()
