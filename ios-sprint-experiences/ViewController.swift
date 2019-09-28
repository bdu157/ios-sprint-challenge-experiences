//
//  MapViewController.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

