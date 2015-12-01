//
//  LocationDetailViewController.swift
//  shifTrack
//
//  Created by Leonid Rusnac on 01/12/15.
//  Copyright © 2015 Leonid Rusnac. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class LocationDetailViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet weak var locationName: UITextField! {
        didSet {
            locationName.delegate = self
        }
    }
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "mapTabGestureHandler:"))
            
            if let loc = location {
                locationName.text = loc.name
                
                let location2D = CLLocationCoordinate2D(latitude: loc.latitude as! CLLocationDegrees, longitude: loc.longitude as! CLLocationDegrees)
                mapView.setCenterCoordinate(location2D, animated: true)
                mapView.setRegion(MKCoordinateRegion(center: location2D, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
                //mapView.setVisibleMapRect(MKMapRect(origin: MKMapPoint(x: , y: <#T##Double#>), size: <#T##MKMapSize#>), animated: <#T##Bool#>)
                
                mapView.addOverlay(MKCircle(centerCoordinate: location2D, radius: 100 as CLLocationDistance))
                let annotation = LocationPin(coordinate: location2D)
                mapView.addAnnotation(annotation)
            } else {
                print("location is not set")
            }
        }
    }
    
    var location: Location? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func mapTabGestureHandler(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            if mapView.annotations.count > 0 && mapView.overlays.count > 0 {
                mapView.removeAnnotations(mapView.annotations)
                mapView.removeOverlays(mapView.overlays)
            }
            
            let newPinLocation = mapView.convertPoint(gesture.locationInView(mapView), toCoordinateFromView: mapView)
            
            mapView.addOverlay(MKCircle(centerCoordinate: newPinLocation, radius: 100 as CLLocationDistance))
            
            let annotation = LocationPin(coordinate: newPinLocation)
            mapView.addAnnotation(annotation)
            
            validatePossibilityToSaveLocation()
        default: break
        }
    }

    
    private class LocationPin: NSObject, MKAnnotation {
        @objc var coordinate: CLLocationCoordinate2D
        
        init(coordinate: CLLocationCoordinate2D) {
            self.coordinate = coordinate
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.redColor()
        circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
        circle.lineWidth = 1
        return circle
    }
    
    func saveLocation() {
        var tempLocation: Location
        if let finalLocation = location {
            tempLocation = finalLocation
        } else {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            tempLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedContext) as! Location
        }
        
        tempLocation.name = locationName.text
        
        let annotations = mapView.annotations as [MKAnnotation]
        if annotations.count == 1 {
            tempLocation.latitude = annotations[0].coordinate.latitude
            tempLocation.longitude = annotations[0].coordinate.longitude
        } else {
            print("something is wrong in getting the position of the pin")
            return
        }
        
        // save content and go back
        let managedObjectContext = tempLocation.managedObjectContext
        if let _ = try? managedObjectContext?.save() {
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func validatePossibilityToSaveLocation() {
        if mapView.annotations.count == 1 && locationName.text != "" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveLocation")
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        validatePossibilityToSaveLocation()
        return true
    }
}
