//
//  SignUpViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import Foundation
import SwiftUI

@MainActor
final class SignUpViewModel: ObservableObject {
    
    @Published var user : User = User()
    
    @Published var email: String = ""
    @Published var navigateToMobileView: Bool = false // navigateToMobileView
    
    @Published var mobile: String = ""
    @Published var navigateToMobileVerificationView: Bool = false // navigateToMobileVerificationView
    
    @Published var otp: String = ""
    @Published var navigateToNameView: Bool = false // navigateToNameViews
    
    @Published var name: String = ""
    @Published var navigateToCreatePasswordView: Bool = false
    
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var navigateToBirthdayView: Bool = false // navigateToBirthdayView
    
    @Published var dob: Date = Date()
    @Published var navigateToCreateUsernameView: Bool = false
    
    @Published var username: String = "" {
        didSet {
            // testing availability of username
            isUsernameAvailable = (username == "paris")
        }
    }
    @Published var isUsernameAvailable: Bool = false
    @Published var navigateToTermsAndConditionsView: Bool = false
    
    @Published var userAcceptedTermsAndConditions: Bool = false
    @Published var navigateToAddProfilePictureView: Bool = false
    @Published var showSigningUpProgress: Bool = false
    
    @Published var profileImage: UIImage = UIImage(flixImage: .defaultProfilePicture)!
    @Published var navigateToGenderView: Bool = false
    @Published var showUploadingPfpProgress: Bool = false
    
    @Published var gender: Gender = .preferNotToSay
    @Published var navigateToBioView: Bool = false
    @Published var showUpdatingGenderProgress: Bool = false
    
    @Published var bio: String = "Film enthusiast 🎥"
    @Published var navigateToAddDomain: Bool = false
    @Published var showUpdatingBioProgress: Bool = false
    
    @Published var primaryDomain: Domain = .cinematographer
    @Published var navigateToProductionHouse: Bool = false
    @Published var navigateToOtherSkillsFromAddDomain: Bool = false
    @Published var showUpdatingDomainProgress: Bool = false
    
    // Production House view values
    @Published var navigateToSaveLoginInfoViewFromProductionHouse: Bool = false // navigateToSaveLoginInfoViewFromProductionHouse
    
    @Published var otherSkill1: Domain = .editor
    @Published var otherSkill2: Domain = .filmCritic
    @Published var navigateToSaveLoginInfoViewFromOtherSkills: Bool = false // navigateToSaveLoginInfoViewFromOtherSkills
    @Published var showUpdatingOtherSkillsProgress: Bool = false
    
    @Published var saveLoginInfo: Bool = false
    @Published var navigateToWelcomeView: Bool = false // navigateToWelcomeView
    
    /// The common Error Message that is used throught the signup process
    /// This is the message thaty contains the current issue in the signup process if any
    @Published var errorMessage: String = ""
    
    
    // Domains and OtherSkills as Strings
    var primaryDomainString: String {
        return primaryDomain.title
    }
    
    var otherSkill1String: String {
        return otherSkill1.title
    }
    
    var otherSkill2String: String {
        return otherSkill2.title
    }
}

extension SignUpViewModel {
    
    //MARK: - Signup Process
    func signUp (completion: @escaping(Bool) -> Void) {
        
        showSigningUpProgress = true
        
        user = User(fullName: name, username: username, mobileNo: mobile, mailID: email, password: password, birthday: dob.formatted(date: .numeric, time: .omitted))
        
        Task{
            
            do{
                // Creating user in firebase
                let firebaseUser = try await AuthenticationManager.shared.createUser(email: user.mailID, password: confirmPassword)
                print("DEBUG: Created User - Firebase")
                try AuthenticationManager.shared.sendEmailVerification()
                
                // Updating UserID
                user.id = firebaseUser.uid
                
                // Creating user in the backend
                AuthenticationAPIService().createUser(user: user) { [unowned self] result in
                    switch result {
                    case .success(let success):
                        print("DEBUG: \(success)")
                        DispatchQueue.main.async {
                            Storage.loggedInUserId = self.user.id
                        }
                        completion(true)
                    case .failure(let failure):
                        switch failure {
                        case .userAlreadyExists:
                            print("DEBUG: [\(user.mailID)] User Already Exists, please Login")
                            DispatchQueue.main.async {
                                self.errorMessage = "User already exists, please Login"
                            }
                        case .custom(let message):
                            print("DEBUG: \(message)")
                            DispatchQueue.main.async {
                                self.errorMessage = message
                            }
                        }
                        completion(false)
                    }
                }
                
                showSigningUpProgress = false
            } catch {
                print("DEBUG: Error while signing in - \(error.localizedDescription)\nEmail : \(user.mailID)")
                self.errorMessage = error.localizedDescription
                showSigningUpProgress = false
                completion(false)
            }
        }
    }
    
    ///Verifying whether the user has verified the email.
    func checkVerificationStatus() -> Bool {
        do {
            _ = try AuthenticationManager.shared.checkEmailVerification()
            return true
        } catch {
            print("Error Verifying the Email.")
            return false
        }
    }
    
    
    //MARK: - Uploading the Profile Picture
    func uploadPfp(completion: @escaping(Bool) -> Void) {
        
        showUploadingPfpProgress = true
        
        user.profilePic = profileImage.toJpegString(compressionQuality: 1.0)
        
        AuthenticationAPIService().uploadProfilePicture(userImage: user.profilePic?.toImage()) { result in
         
            switch result {
            case .success(let success):
                print("Image Uploaded Successfully. \(success)")
                completion(true)
            case .failure(_):
                print("Error Occurred While Uploading the profile picture.")
                completion(false)
            }
        }
        
        showUploadingPfpProgress = false
    }
    
    //MARK: - Update User Gender
    func updateUserGender(completion: @escaping(Bool) -> Void) {
        
        showUpdatingGenderProgress = true
        
        user.sex = gender.rawValue
        
        ProfileAPIService().updateUserGender(userid: user.id, newGender: gender) { [unowned self] result in
            DispatchQueue.main.async  { self.showUpdatingGenderProgress = false }
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                completion(true)
            case .failure(let failure):
                switch failure {
                case .custom(let message):
                    print("DEBUG: \(message)")
                    DispatchQueue.main.async {
                        self.errorMessage = message
                    }
                }
                completion(false)
            }
        }
    }
    
    //MARK: - Update User Gender
    func updateUserBio(completion: @escaping(Bool) -> Void) {
        
        showUpdatingBioProgress = true
        
        user.bio = bio
        
        ProfileAPIService().updateUserBio(userid: user.id, newBio: bio) { [unowned self] result in
            DispatchQueue.main.async  { self.showUpdatingBioProgress = false }
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                completion(true)
            case .failure(let failure):
                switch failure {
                case .custom(let message):
                    print("DEBUG: \(message)")
                    DispatchQueue.main.async {
                        self.errorMessage = message
                    }
                }
                completion(false)
            }
        }
    }
    
    //MARK: - Update User Domain
    func updateUserDomain(completion: @escaping(Bool) -> Void) {
        
        showUpdatingDomainProgress = true
        
        user.domain = primaryDomain.title
        
        ProfileAPIService().updateUserDomain(userId: user.id, newDomain: primaryDomain) { [unowned self] result in
            DispatchQueue.main.async  { self.showUpdatingDomainProgress = false }
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                completion(true)
            case .failure(let failure):
                switch failure {
                case .custom(let message):
                    print("DEBUG: \(message)")
                    DispatchQueue.main.async {
                        self.errorMessage = message
                    }
                }
                completion(false)
            }
        }
    }
    
    //MARK: - Add Other Skills
    func addUserOtherSkills(completion: @escaping(Bool) -> Void) {
        
        showUpdatingOtherSkillsProgress = true
        
        user.otherSkills = [otherSkill1.title, otherSkill2.title]
        
        ProfileAPIService().addArrayInfoTo(userId: user.id, infoType: .otherSkills, newValues: user.otherSkills) { result in
            DispatchQueue.main.async { self.showUpdatingOtherSkillsProgress = false }
            switch result {
            case .success(let success):
                print("DEBUG: \(success)")
                completion(true)
            case .failure(let failure):
                switch failure {
                case .custom(let message):
                    print("DEBUG: \(message)")
                    DispatchQueue.main.async {
                        self.errorMessage = message
                    }
                }
                completion(false)
            }
        }
    }
    
    //MARK: - Update
}
