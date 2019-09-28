//
//  CreateExperienceViewController.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class CreateExperienceViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPosterImageButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    
    //MARK: filter outlets
    private let filter = CIFilter(name: "CIColorInvert")!
    private let context = CIContext(options: nil)
    var originalImage: UIImage? {
        didSet {
            self.updateImage()
        }
    }
    
    //MARK: audio outlets
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    var audioURL: URL?
    private var isRecording: Bool {
        return recorder?.isRecording ?? false
    }
    
    var experienceController: ExperienceController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCreateVideo" {
        guard let destVC = segue.destination as? AddVideoViewController,
            let names = self.titleTextField.text,
            let audioURLs = self.audioURL,
            let images = self.imageView.image else {return}
            destVC.name = names
            destVC.audioURL = audioURLs
            destVC.image = images
            destVC.experienceController = self.experienceController
        }
    }

    
    @IBAction func addPosterImageButtonTapped(_ sender: Any) {
        if self.titleTextField.text != "" {
            self.presentImagePickerController()
        } else {
            self.checkingTitleText()
        }
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
        defer {self.updateRecordButton()}
        
        guard !isRecording else {
            recorder?.stop()
            return
        }
        
        do {
            let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)!
            recorder = try AVAudioRecorder(url: self.newRecordingURL(), format: format)
            recorder?.delegate = self
            recorder?.record()
        } catch {
            NSLog("Unable to start recording: \(error)")
        }
    }
    
    
    //MARK: private methods for image and image filter
    //present imagePicker
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            NSLog("no library")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    //updateImage
    private func updateImage() {
        guard let originalImage = self.originalImage else {return}
        self.imageView.image = self.image(byFiltering: originalImage)  //private method below
    }
    //filter the image
    private func image(byFiltering image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else {return image}
        let ciImage = CIImage(cgImage: cgImage)
        
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter.outputImage else {return image}
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {return image}
        return UIImage(cgImage: outputCGImage)
    }
    
    
    //MARK: private methods for audioRecorder
    //updateButton for recorder
    private func updateRecordButton() {
        let recordButtonString = self.isRecording ? "Stop Recording": "Record Audio"
        let recordButtonTintColor: UIColor = self.isRecording ? .blue : .red
        self.recordAudioButton.setTitle(recordButtonString, for: .normal)
        self.recordAudioButton.tintColor = recordButtonTintColor
    }
    //audioURL
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDirectory = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
    }
    //setting url to audioURL
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.audioURL = recorder.url
        self.updateRecordButton()
        self.recorder = nil
    }
    
    
    //MARK: alert method for text
    private func checkingTitleText() {
        let alert = UIAlertController(title: "Title field above is missing", message: "it is required 😀", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CreateExperienceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.originalImage = image
            self.addPosterImageButton.isHidden = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
