//
//  CasesMapVC.swift
//  CoGuard
//
//  Created by عمرو on 22.05.2023.
//

import UIKit
import MapKit

class CasesMapVC: UIViewController {
    
    // MARK: Subviews
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Properties
    private let locationManager = CLLocationManager()
    private var allLocations = [CaseLocation]()
    
    // MARK: Viewcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocations()
        mapView.delegate = self
        requestLocationAccess()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Helpers
    private func animateCenteringMap(location: CLLocationCoordinate2D){
        let span = MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
        let region = MKCoordinateRegion.init(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func addRadiusCircles(locations: [CaseLocation]){
        for location in locations {
            guard let latitude = location.latitude, let longitude = location.longitude else {continue}
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let circle = MKCircle(center: location.coordinate, radius: 0.05 * Double(10000))
            self.mapView.addOverlay(circle)
        }
    }
    
    private func requestLocationAccess(){
        
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            showLocationDisabeledAlert()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            break
        }
    }
    
    // MARK: Reqquests
    private func fetchLocations(){
        showLottieAnimation()
        
        CasesService.shared.fetchAllLocations {[weak self] locations in
            guard let self = self else {return}
            self.hideLottieAnimation()
            
            self.allLocations = locations
            self.addRadiusCircles(locations: locations)
        }
    }
}

// MARK: CLLocationManagerDelegate
extension CasesMapVC: CLLocationManagerDelegate {
    func locationManager(_ locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.delegate = nil
            self.animateCenteringMap(location: CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                      longitude: location.coordinate.longitude))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocationAccess()
    }
}

// MARK: MKMapViewDelegate
extension CasesMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centralLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude:  mapView.centerCoordinate.longitude)
        self.getRadius(centralLocation: centralLocation)
    }
        
    func getRadius(centralLocation: CLLocation){
        let topCentralLat: Double = centralLocation.coordinate.latitude -  (mapView?.region.span.latitudeDelta ?? 0.0) / 2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        self.mapView?.overlays.forEach {
            if !($0 is MKUserLocation) {
                self.mapView?.removeOverlay($0)
            }
        }
        addAnnotations(radius: radius * 0.05)
    }
    
    func addAnnotations(radius: Double) {
        let overlays = allLocations.map { MKCircle(center: $0.coordinates!, radius: radius) }
        mapView?.addOverlays(overlays)
    }
}
