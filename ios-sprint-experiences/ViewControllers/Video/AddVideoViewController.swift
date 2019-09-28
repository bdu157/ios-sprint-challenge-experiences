//
//  AddVideoViewController.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class AddVideoViewController: UIViewController {

    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    //datas from CreateExperienceVC
    var image: UIImage?
    var name: String?
    var audioURL: URL?
    var experienceController: ExperienceController?

    //MARK: videos outlets
    var captureSession: AVCaptureSession!
    var recordOutput: AVCaptureMovieFileOutput!
    var videoRecordingURL: URL?
    
    //MARK: location properties
    var cl2DLocation: CLLocationCoordinate2D?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkAuth()
        
        let captureSession = AVCaptureSession()
        let videoDevice = self.bestCamera()
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput) else {fatalError()}
        
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError()
        }
        captureSession.addOutput(fileOutput)
        self.recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        cameraPreviewView.videoPreviewLayer.session = captureSession
        
        
        //current location
        locationManager.requestWhenInUseAuthorization()
        let loc = locationManager.location
        guard let latitude = loc?.coordinate.latitude,
            let longitude = loc?.coordinate.longitude else {return}
        cl2DLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.captureSession.startRunning()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //add createExperience here using passed properties - name, audioURL, image and videoURL from here
        guard let names = self.name,
            let images = self.image,
            let audioURLs = self.audioURL,
            let videoURLs = self.videoRecordingURL,
            let geotags = self.cl2DLocation,
            let experienceControllers = self.experienceController else {return}
        experienceControllers.createExperience(for: names, image: images, audioURL: audioURLs, videoURL: videoURLs, geotag: geotags)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: self.newRecordingURL(), recordingDelegate: self)
        }
    }
    
    //MARK: video private methods
    //checking authorization on camera
    private func checkAuth() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granter) in
                if granter {
                    return
                }
            }
        case .denied:
            self.authAlert()
        case .restricted:
            self.authAlert()
        default:
            return
        }
    }
    private func authAlert() {
        let alert = UIAlertController(title: "it is denied or restricted", message: "please allow camera access", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    //bestCamera
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device")
        }
    }
    //recordingURL
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let document = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return document.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    //updateButton
    private func updateViewsButton() {
        guard isViewLoaded else {return}
        
        let isRecording = recordOutput?.isRecording ?? false
        let recordButtonImage: String = isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonImage), for: .normal)
    }
}

extension AddVideoViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViewsButton()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        defer {self.updateViewsButton()}
        self.videoRecordingURL = outputFileURL.absoluteURL
    }
}
