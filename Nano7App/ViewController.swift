//
//  ViewController.swift
//  Nano7App
//
//  Created by Igor Samoel da Silva on 16/11/21.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate {
    let annotion = MKPointAnnotation()
    lazy var map : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContraints()
        changeMapButton()
        // Do any additional setup after loading the view.
    }
    
    
    //Function to adding custom pin
    private func addCustomPin(){
        let pin = MKPointAnnotation()
        pin.title = "ISS here"
        map.addAnnotation(pin)
    }
    
    
    
    //function to show custom pin at map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            
            annotationView?.canShowCallout = true
        }
        else{
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "IssIcon")
        
        return annotationView
    }
    
    @objc func buttonAction(button: UIButton){
        if map.mapType == .hybridFlyover {
            map.mapType = .standard
        }else{
            map.mapType = .hybridFlyover
        }
        
    }
    
    func changeMapButton(){
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.setTitle("🌎", for: .normal)
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        //Button constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    }
    
    
    
    func setupContraints() {
        self.view.addSubview(self.map)
        
        map.translatesAutoresizingMaskIntoConstraints = false
        
        map.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        map.delegate = self
    
        
        

        
        
        let coordinate = CLLocationCoordinate2D(latitude: -42.618332, longitude: 168.68759)
        annotion.coordinate = coordinate
        
        
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { timer in
            IssAPI.shared.request { iss in
                let latitude = Double(iss.latitude)
                let longitude = Double(iss.longitude)
                DispatchQueue.main.async {
                    self.annotion.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                   
                
                }
        }
        


            
        }
        
        
        map.addAnnotation(annotion)
        
        
        
        
        
    }
    
    
    
    
    
    
    
}

