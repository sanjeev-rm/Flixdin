//
//  FlixViewModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 24/04/2024.
//

import FirebaseAuth
import Foundation

class FlixViewModel: ObservableObject {
    @Published var allFlix: [FlixResponse] = [FlixResponse(flixid: "", ownerid: "", domain: "", caption: "", applicants: [""], location: "", likes: [""], flixurl: "", flixdate: "", comments: [""], banned: false, embedding: "")]

    init() {
        Task {
            await getAllFlix()
        }
    }

    // MARK: Get all flix

    func getAllFlix() async {
        let urlPath = URLPath.getAllFlix

        let requestBody = GetAllFlixRequest(flixid: "")

        do {
            let response: [FlixResponse] = try await
                NetworkRequest.request(urlPath: urlPath, method: .post, body: NetworkRequest.encodeRequestBody(requestBody))

            DispatchQueue.main.async { [weak self] in
                print("success all flix response \(response)")

                // MARK: change this later

                self?.allFlix = Array(response.dropFirst())
                print("----------------------------------")
                print("success all flix \(String(describing: self?.allFlix))")
            }
        } catch {
            print("error getting all flix \(error.localizedDescription)")
        }
    }

}
