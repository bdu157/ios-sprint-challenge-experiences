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

class CreateExperienceViewController: UIViewController {

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
    var audioURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let name = self.titleTextField.text,
            let audioURL = self.audioURL,
            let image = self.imageView.image else {return}
        
        
        
    }
    
    
    
    @IBAction func addPosterImageButtonTapped(_ sender: Any) {
        self.presentImagePickerController()
    }
    
    @IBAction func recordAudioButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: private methods
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
