//
//  ExperienceDetailView.swift
//  ios-sprint-experiences
//
//  Created by Dongwoo Pae on 9/28/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class ExperienceDetailView: UIView {
    
    var experience: Experience? {
        didSet {
            self.updateSubViews()
        }
    }
    
    private func updateSubViews() {
        guard let experience = self.experience else {return}
        addSubview(self.imageView)
        self.imageView.image = experience.image
        
        //constraints
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 55).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        imageView.contentMode = .scaleAspectFill
    }
    
    private var imageView = UIImageView()
}
