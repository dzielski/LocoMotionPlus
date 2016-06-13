//
//  MappingViewController.swift
//  LocoMotion
//
//  Created by David Zielski on 6/11/16.
//  Copyright © 2016 mobiledez. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MappingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
  
    @IBOutlet weak var theMapView: MKMapView!
    @IBOutlet weak var labelView: UILabel!

    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    var zoomArray = [0.001, 0.01, 0.05, 0.1, 0.2, 0.5, 1.0, 10.0, 50.0, 100.0]
    
    var zoomIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        //Setup our Map View
        theMapView.delegate = self
        theMapView.mapType = MKMapType.Satellite
        theMapView.showsUserLocation = true
        
        let mapDragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MappingViewController.didDragMap(_:)))
        mapDragRecognizer.delegate = self
        self.theMapView.addGestureRecognizer(mapDragRecognizer)
    }
    
    @IBAction func mapStyleTapped(sender: AnyObject) {
        if theMapView.mapType == MKMapType.Standard {
            theMapView.mapType = MKMapType.Satellite
        } else {
            theMapView.mapType = MKMapType.Standard
        }
    }
    
    
    @IBAction func homeTapped(sender: AnyObject) {
        
        // when home is tapped we are going to clear out locations and overlay
        myLocations.removeAll()
        let overlays = theMapView.overlays
        theMapView.removeOverlays(overlays)
        
        manager.startUpdatingLocation();

        let newRegion = MKCoordinateRegion(center: theMapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
        
        theMapView.setRegion(newRegion, animated: true)
    }
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        labelView.text = "\(locations[0])"
        myLocations.append(locations[0])
        
        let newRegion = MKCoordinateRegion(center: theMapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.005, 0.005))
        theMapView.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            theMapView.addOverlay(polyline)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didDragMap(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            manager.stopUpdatingLocation();
//            print("Map drag began")
        }
        
        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
//            print("Map drag ended")
        }
    }
    
}


