//
//  ExperienceController.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ExperienceController {
    
    var experiences: [Experience] = []
    
    func createExperience(for title: String, image: UIImage, audioURL: URL, videoURL: URL, geotag: CLLocationCoordinate2D) {
        let experience = Experience(name: title, image: image, audioURL: audioURL, videoURL: videoURL, geotag: geotag)
        self.experiences.append(experience)
    }
}
