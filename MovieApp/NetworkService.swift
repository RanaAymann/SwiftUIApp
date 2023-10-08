//
//  NetworkService.swift
//  MovieApp
//
//  Created by Rana Ayman on 04/10/2023.
//

import Foundation

class NetworkService {
 
    func fetchData(completion: @escaping ([User]?, Error?) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "YourAppErrorDomain", code: 1, userInfo: nil))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData, nil)
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }

    // Define the base URL for your API
    private var baseURL: String = "https://api.androidhive.info/json"
    var moviesArray : [MovieModel]?

//    
//    init(baseURL: String) {
//        self.baseURL = baseURL
//    }
//
    // Perform a GET request
    func getMoviesList(from endpoint: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        // Create the URL
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        moviesArray = [MovieModel]()
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // json serilization ( decoding the data )
            do {
                var json = try JSONSerialization.jsonObject(with: data!,options: .allowFragments) as! Array<Dictionary<String,Any>>
                for rawMoview in json {
                    let movieObj = MovieModel()
                    movieObj.title = rawMoview["title"] as! String
                    movieObj.image = rawMoview["image"] as! String
                    movieObj.rating = rawMoview["rating"] as! Double
                    movieObj.releaseYear = rawMoview["releaseYear"] as! Int
                    self.moviesArray?.append(movieObj)

                }
            } catch {
                print("Error")
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.noData))
            }
        }
        
        // Start the data task
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}

