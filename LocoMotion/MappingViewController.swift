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

class MappingViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  
    @IBOutlet weak var theMapView: MKMapView!
    @IBOutlet weak var labelView: UILabel!

    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    
    var zoomIndex = 2
    
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
    }
    
    @IBAction func zoomPlusTapped(sender: AnyObject) {
        zoomIndex = zoomIndex - 1;
        
        if zoomIndex < 0
        {
            zoomIndex = 0
        }
    }
    
    @IBAction func zoomMinusTapped(sender: AnyObject) {
        zoomIndex = zoomIndex + 1;
        
        if zoomIndex > 9
        {
            zoomIndex = 9
        }
    }
    
    
    @IBAction func mapStyleTapped(sender: AnyObject) {
        if theMapView.mapType == MKMapType.Standard {
            theMapView.mapType = MKMapType.Satellite
        } else {
            theMapView.mapType = MKMapType.Standard
        }
    }
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        var zoomArray = [0.001, 0.01, 0.05, 0.1, 0.2, 0.5, 1.0, 10.0, 50.0, 100.0]
        
        labelView.text = "\(locations[0])"
        myLocations.append(locations[0])
        
        let newRegion = MKCoordinateRegion(center: theMapView.userLocation.coordinate, span: MKCoordinateSpanMake(zoomArray[zoomIndex], zoomArray[zoomIndex]))
        theMapView.setRegion(newRegion, animated: true)
        
//       print("Mapping data : coount=\(myLocations.count) - zoomIndex=\(zoomIndex) = zoomArray=\(zoomArray[zoomIndex])")
        
        
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
    
    
}


