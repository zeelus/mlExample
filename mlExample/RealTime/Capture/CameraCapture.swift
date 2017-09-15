//
//  CameraCapture.swift
//  mlExample
//
//  Created by Gilbert Gwizdała on 14/09/2017.
//  Copyright © 2017 Gilbert Gwizdała. All rights reserved.
//

import Foundation
import AVFoundation

protocol CameraCaptureDelegate {
    func capture(frame: CVImageBuffer)
}

class CameraCapture: NSObject{
    
    private let cameraQueue = DispatchQueue(label: "cameraQueue")
    private let captureSession = AVCaptureSession()
    
    public var delegate: CameraCaptureDelegate? = nil
    
    private var isPermission = false
    
    override init() {
        super.init()
        self.checkPermission()
        self.cameraQueue.sync {
            self.setupCameraCapture()
            self.captureSession.startRunning()
        }
        
    }
    
    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.isPermission = true
        case .notDetermined:
            //TODo show access requesst
            break
        default:
            self.isPermission = true
            //show information  to user about access denite
        }
    }
    
    private func askForPermission() {
        self.cameraQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) {[weak self] (isPermission) in
            self?.isPermission = isPermission
            self?.cameraQueue.resume()
        }
    }
    
    private func setupCameraCapture() {
        guard self.isPermission else { return }
        self.captureSession.sessionPreset = .medium
        
        guard let captureDevice = self.selectCaptureDevice() else { return }
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        self.captureSession.addInput(captureDeviceInput)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: self.cameraQueue)
        self.captureSession.addOutput(output)
        
        let connection = output.connection(with: .video)
        connection?.videoOrientation = .portrait
        
    }
    
    private func selectCaptureDevice() -> AVCaptureDevice? {
        let devices: [AVCaptureDevice] = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: .video, position: .back).devices
        return devices.first
    }
    
    func resume() {
        self.cameraQueue.sync {
            self.captureSession.startRunning()
        }
    }
    
    func stop() {
        self.cameraQueue.sync {
            self.captureSession.stopRunning()
        }
    }
    
}

extension CameraCapture : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let frame = self.transformToCVImageBuffer(sampleBuffer: sampleBuffer) {
            self.delegate?.capture(frame: frame)
        }
    }
    
    private func transformToCVImageBuffer(sampleBuffer: CMSampleBuffer) ->  CVImageBuffer? {
        return CMSampleBufferGetImageBuffer(sampleBuffer)
    }
    
}
