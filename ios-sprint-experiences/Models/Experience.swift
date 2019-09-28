//
//  Experience.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Experience: NSObject {
    let name: String
    let image: UIImage
    let audioURL: URL
    let videoURL: URL
    let geotag: CLLocationCoordinate2D
    
    init(name: String, image: UIImage, audioURL: URL, videoURL: URL, geotag: CLLocationCoordinate2D) {
        self.name = name
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.geotag = geotag
    }
}
