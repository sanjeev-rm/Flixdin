//
//  CameraService.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 01/08/23.
//

import Foundation
import AVFoundation

class CameraService {
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    var output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let session = AVCaptureSession()
            if let device = AVCaptureDevice.default(for: .video) {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                    
                    if session.canAddOutput(self.output) {
                        session.addOutput(self.output)
                    }
                    
                    DispatchQueue.main.async {
                        self.previewLayer.videoGravity = .resizeAspectFill
                        self.previewLayer.session = session
                    }
                    
                    session.startRunning()
                    self.session = session
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }
        }
    }
    
    func switchCamera(completion: @escaping (Error?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session?.stopRunning()
            
            if let currentInput = self.session?.inputs.first as? AVCaptureDeviceInput,
               let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentInput.device.position.toggle) {
                do {
                    let newInput = try AVCaptureDeviceInput(device: newDevice)
                    
                    self.session?.beginConfiguration()
                    self.session?.removeInput(currentInput)
                    if self.session!.canAddInput(newInput) {
                        self.session?.addInput(newInput)
                    }
                    self.session?.commitConfiguration()
                    
                    self.session?.startRunning()

                } catch {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }
        }
    }

    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()) {
        output.capturePhoto(with: settings, delegate: delegate!)
    }
    
    // Toggle flash mode
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if device.torchMode == .off {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Error toggling flash: \(error)")
            }
        }
    }
}

extension AVCaptureDevice.Position {
    var toggle: AVCaptureDevice.Position {
        return self == .back ? .front : .back
    }
}
