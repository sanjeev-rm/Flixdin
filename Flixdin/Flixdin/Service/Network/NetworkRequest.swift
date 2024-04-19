//
//  NetworkRequest.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 19/04/2024.
//

import Foundation

struct NetworkRequest {
    static func request<T: Decodable>(urlPath: URLPath, method: HTTPMethod, body: Data? = nil) async throws -> T {
        guard let url = URL(string: "\(Constants.shared.baseURL)\(urlPath.rawValue)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        if method == .post {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            
            print("Error occurred while performing \(urlPath.rawValue)")
            print("error: \(response.description)")

            throw URLError(.unknown)
        }

        let decodeResponse = try JSONDecoder().decode(T.self, from: data)

        return decodeResponse
    }
}
