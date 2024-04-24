//
//  FlixViewModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 24/04/2024.
//

import Foundation


class FlixViewModel: ObservableObject{
    @Published var getAllFlix: [FlixResponse] = [FlixResponse(flixid: "", ownerid: "", domain: "", caption: "", applicants: [""], location: "", likes: [""], flixurl: "", flixdate: "", comments: [""], banned: false, embedding: "")]
    
    func getAllFlix() async{
        let urlPath = URLPath.getAllFlix
        
        let requestBody = GetAllFlixRequest(flixid: "")
        
        do{
            let response: [FlixResponse] = try await
            NetworkRequest.request(urlPath: urlPath, method: .post, body: getAllFlixEncodeRequestBody(requestBody))
            
            DispatchQueue.main.async { [weak self] in
                print("success all flix response \(response)")
                
                self?.getAllFlix = response
                print("----------------------------------")
                print("success all flix \(String(describing: self?.getAllFlix))")
            }
        }catch{
            print("error getting all flix \(error.localizedDescription)")
        }
        

    }
    
    private func getAllFlixEncodeRequestBody(_ requestBody: GetAllFlixRequest) -> Data? {
        try? JSONEncoder().encode(requestBody)
    }
    
    
}


