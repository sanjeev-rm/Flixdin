//
//  HomeAPIService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/03/24.
//

import Foundation

class HomeAPIService {
    
    enum HomeError: Error {
        case custom(message: String)
    }
    
    static let GET_DATA_URL = "https://api.flixdin.com/getdata"
    
    struct DataResponseBody: Codable {
        var postid: String
        var ownerid: String
        var domain: String
        var caption: String
        var applicants: [String]
        var location: String
        var likes: [String]
        var image: String
        var time_of_post: String
        var comments: String
        var fullname: String
        var profilepic: String
        var username: String
    }
    
    static func getData(completion: @escaping(Result<[DataResponseBody], HomeError>) -> Void) {
        
        guard let url = URL(string: HomeAPIService.GET_DATA_URL) else {
            completion(.failure(.custom(message: "Invalid URL - Get data home")))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(.custom(message: "No Internet - Get Data home")))
                    return
                }
                
                guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
                    completion(.failure(.custom(message: "Unable to get data home")))
                    return
                }
                
                guard let dataArray = try? JSONDecoder().decode([DataResponseBody].self, from: data) else {
                    completion(.failure(.custom(message: "Unable to decode response - Get Data home")))
                    return
                }
                
                completion(.success(dataArray))
            }.resume()
        }
    }
}
