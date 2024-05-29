//
//  FlixCellViewModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 27/04/2024.
//

import Foundation
import FirebaseAuth

class FlixCellViewModel: ObservableObject{
    
    // MARK: Like Flix

    func likeFlix(flixid: String) async {
        let urlPath = URLPath.likeFlix

        guard let userid = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            return
        }

        let requestBody = LikeOrDislikeFlixRequest(flixid: flixid, userid: userid)

        do {
            let response: LikeFlixResponse = try await NetworkRequest.request(urlPath: urlPath, method: .put, body: NetworkRequest.encodeRequestBody(requestBody))

            DispatchQueue.main.async {
                print("like flix success \(response)")
            }

        } catch {
            print("like flix fail \(error)")
        }
    }

    // MARK: Dislike flix

    func dislikeFlix(flixid: String) async {
        let urlPath = URLPath.dislikeFlix

        guard let userid = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            return
        }

        let requestBody = LikeOrDislikeFlixRequest(flixid: flixid, userid: userid)

        do {
            let response: DislikeFlixResponse = try await NetworkRequest.request(urlPath: urlPath, method: .put, body: NetworkRequest.encodeRequestBody(requestBody))

            DispatchQueue.main.async {
                print("like flix success \(response)")
            }

        } catch {
            print("like flix fail \(error)")
        }
    }
}
