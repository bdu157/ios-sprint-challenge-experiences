//
//  MapViewController.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let experienceController = ExperienceController()
    
    var experiences: [Experience] = [] {
        didSet {
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.experiences)
            }
        }
    }
    
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "annotationID")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        self.experiences = self.experienceController.experiences
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCreateNewExperience" {
            let navigationController = segue.destination as! UINavigationController
            let destVC = navigationController.topViewController as! CreateExperienceViewController
            destVC.experienceController = self.experienceController
            
        }
    }
}
    extension MapViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            //add annotaionView
            
            guard let experience = annotation as? Experience else {return nil}
            
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationID", for: experience) as! MKMarkerAnnotationView
            annotationView.glyphTintColor = .white
            annotationView.animatesWhenAdded = true
            annotationView.titleVisibility = .adaptive
            return annotationView
    }
}

