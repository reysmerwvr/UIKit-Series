//
//  ViewController.swift
//  CapitalCities
//
//  Created by Reysmer Valle on 8/5/21.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    var mapTypes: [String: MKMapType] = ["hybrid": .hybrid, "hybridFlyover": .hybridFlyover, "standard": .standard, "satellite": .satellite, "mutedStandard": .mutedStandard]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Capital Cities"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectMapType))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.50722, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the city of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        let bogota = Capital(title: "Bogota", coordinate: CLLocationCoordinate2D(latitude: 4.7110, longitude: -74.0721), info: "Named the coldest one.")
        
        mapView.mapType = .standard
        mapView.addAnnotations([london, oslo, paris, rome, washington, bogota])
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else {
            return nil
        }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = UIColor.green
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else {
            return
        }
        
        if let vc = storyboard?.instantiateViewController(identifier: "Webview") as? WebViewController {
            vc.selectedCity = capital.title
            navigationController?.pushViewController(vc, animated: true)
        }
//        let placeName = capital.title
//        let placeInfo = capital.info
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
    }
    
    @objc func selectMapType() {
        let ac = UIAlertController(title: "Choose Map Type", message: nil, preferredStyle: .actionSheet)
        for (key, _) in mapTypes {
            ac.addAction(UIAlertAction(title: key, style: .default, handler: setMapType))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setMapType(action: UIAlertAction) -> Void {
        guard let actionTitle = action.title else {
            return
        }
        
        mapView.mapType = mapTypes[actionTitle] ?? .standard
    }
}

