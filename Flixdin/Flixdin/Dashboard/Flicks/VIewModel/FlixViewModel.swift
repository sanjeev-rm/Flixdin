//
//  FlixViewModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 24/04/2024.
//

import Foundation
import FirebaseAuth

class FlixViewModel: ObservableObject{
    @Published var allFlix: [FlixResponse] = [FlixResponse(flixid: "", ownerid: "", domain: "", caption: "", applicants: [""], location: "", likes: [""], flixurl: "", flixdate: "", comments: [""], banned: false, embedding: "")]
    
    init(){
        Task{
            await getAllFlix()
        }
    }
    
    func getAllFlix() async{
        let urlPath = URLPath.getAllFlix
        
        let requestBody = GetAllFlixRequest(flixid: "")
        
        do{
            let response: [FlixResponse] = try await
            NetworkRequest.request(urlPath: urlPath, method: .post, body: NetworkRequest.encodeRequestBody(requestBody))
            
            DispatchQueue.main.async { [weak self] in
                print("success all flix response \(response)")
                
                self?.allFlix = response
                print("----------------------------------")
                print("success all flix \(String(describing: self?.allFlix))")
            }
        }catch{
            print("error getting all flix \(error.localizedDescription)")
        }
        

    }
    
    func likeFlix(flixid: String) async{
        let urlPath = URLPath.likeFlix
        
        guard let userid = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            return
        }

        let requestBody = LikeOrDislikeFlixRequest(flixid: flixid, userid: userid)
        
//        do{
//            //let response:
//        }catch{
//            
//        }
        
    }
    
    func dislikeFlix(flixid: String) async{
        let urlPath = URLPath.dislikeFlix
        
        guard let userid = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            return
        }
        
        let requestBody = LikeOrDislikeFlixRequest(flixid: flixid, userid: userid)
        
    }
    

    

    
    
}


