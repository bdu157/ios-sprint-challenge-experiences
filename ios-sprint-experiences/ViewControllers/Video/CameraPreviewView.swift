//
//  CameraPreviewView.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

}
