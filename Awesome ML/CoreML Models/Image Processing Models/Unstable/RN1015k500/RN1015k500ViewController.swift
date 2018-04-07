//
//  RN1015k500ViewController.swift
//  Awesome ML
//
//  Created by Eugene Bokhan on 3/13/18.
//  Copyright © 2018 Eugene Bokhan. All rights reserved.
//

import UIKit
import Vision
import MapKit

class RN1015k500ViewController: RunCoreMLViewController {
    
    // MARK: - MapView
    
    let mapResult : MKMapView = {
        let map = MKMapView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .standard
        return map
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setUpCoreImage()
        setUpVision()
        setUpCamera()
    }
    
    func setupMapView() {
        
        inputWidthAndHeightLabel.removeFromSuperview()
        
        bottomBlurView.addSubview(mapResult)
        mapResult.bottomAnchor.constraint(equalTo: outputLabel.topAnchor, constant: -20).isActive = true
        mapResult.centerXAnchor.constraint(equalTo: bottomBlurView.centerXAnchor).isActive = true
        mapResult.leadingAnchor.constraint(equalTo: bottomBlurView.leadingAnchor, constant: 20).isActive = true
        mapResult.trailingAnchor.constraint(equalTo: bottomBlurView.trailingAnchor, constant: -20).isActive = true
        mapResult.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    override func visionRequestDidComplete(request: VNRequest, error: Error?) {
        
        guard let results = request.results as? [VNClassificationObservation] else { return }
        
        guard let firstResult = results.first else { return }
        
        DispatchQueue.main.async {
            
            let stringcoordinates = firstResult.identifier.components(separatedBy: "\t")
            let coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(stringcoordinates[1])!, longitude: CLLocationDegrees(stringcoordinates[2])!)
            let span = MKCoordinateSpan(latitudeDelta: 0.0043, longitudeDelta: 0.0034)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(stringcoordinates[1])!, longitude: CLLocationDegrees(stringcoordinates[2])!)
            self.mapResult.addAnnotation(annotation)
            self.mapResult.region = MKCoordinateRegion(center: coordinates, span: span)
            self.outputLabel.text = "LAT: \(stringcoordinates[1])\nLON:\(stringcoordinates[2])"
        }
    }
    
    
    
}
