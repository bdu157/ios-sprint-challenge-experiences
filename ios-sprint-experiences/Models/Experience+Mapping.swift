//
//  Experience+Mapping.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import MapKit

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return geotag
    }
    var title: String? {
        return name
    }
}


