//
//  ExtensionURLSession.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 29/09/23.
//

import Foundation

extension URLSession {
    func dataTask(with request: MultipartFormDataRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask {
        return dataTask(with: request.asURLRequest(), completionHandler: completionHandler)
    }
}
