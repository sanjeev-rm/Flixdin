//
//  AddFlicksViewModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 11/04/2024.
//

import FirebaseAuth
import Foundation

class AddFlicksViewModel: ObservableObject {
    @Published var isUploading: Bool = false
    @Published var caption: String = ""
    @Published var location: String = ""
    @Published var domain: String = ""

    @Published var newFlixResponse: String = ""
    @Published var status: Int = 0
    /// This makes a POST request to the backend and
    /// sends the caption, domain and locatin of the flix
    /// and gets the flix ID in return

    // MARK: Add-Flix

    func addFlix() async {
        guard let loggedInUserId = Auth.auth().currentUser?.uid else {
            print("Logged In UserId invalid - Updating User")
            return
        }

        let urlPath = URLPath.newFlix

        let requestBody = NewFlixRequest(ownerid: loggedInUserId, domain: domain, caption: caption, applicants: [""], location: location, likes: [""], flixurl: "", flixdate: "\(Date())", comments: [""])

        do {
            let response: NewFlixResponse = try await NetworkRequest.request(urlPath: urlPath, method: .post, body: NetworkRequest.encodeRequestBody(requestBody))

            DispatchQueue.main.async { [weak self] in

                print("add flix success \(response)")

                self?.newFlixResponse = response.new_flix
            }
        } catch {
            print("erorr adding flix \(error.localizedDescription)")
        }
    }

    // MARK: Upload video

    func uploadSelectedVideo(pickedVideoURL: URL?) {
        guard let videoURL = pickedVideoURL else {
            print("No video URL found")
            return
        }

        DispatchQueue.main.async {
            self.isUploading = true
        }

        let url = URL(string: "https://fixdin-encoder2.hf.space/transcode")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let token = "Bearer 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"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = NSMutableData()

        httpBody.append(convertFormField(named: "id", value: newFlixResponse, using: boundary))

        if let videoData = try? Data(contentsOf: videoURL) {
            httpBody.append(convertFileData(fieldName: "file",
                                            fileName: "lel.mkv",
                                            mimeType: "video/x-matroska",
                                            fileData: videoData,
                                            using: boundary))
        }

        httpBody.appendString("--\(boundary)--")

        request.httpBody = httpBody as Data

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading video: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isUploading = false
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode) else {
                print("Server error")
                DispatchQueue.main.async {
                    self.isUploading = false
                }
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "application/json",
               let data = data,
               let dataString = String(data: data, encoding: .utf8) {
                print("Uploaded video. Received response: \(dataString)")
                DispatchQueue.main.async {
                    self.isUploading = false
                }
            }

            if httpResponse.statusCode >= 200 || httpResponse.statusCode < 300 {
                print("video upload status code \(httpResponse.statusCode)")
                print("video upload response \(httpResponse)")
                DispatchQueue.main.async {
                    self.isUploading = false
                    self.status = httpResponse.statusCode
                }
            }
        }
        task.resume()
    }

    // MARK: Video Conversion

    private func convertFormField(named name: String, value: String, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        data.appendString("\(value)\r\n")
        return data as Data
    }

    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
}

// MARK: - Data Extension for Multipart/Form-Data

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
