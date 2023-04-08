//
//  ViewController.swift
//  Project2_Krishna
//
//  Created by Krishna Priya on 2023-04-06.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var list: [listoflocation] = []
    
    private  let locationmanager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMap()
        addAnotation(location: getFanshaweLocation())
        
        locationmanager.requestWhenInUseAuthorization()
        
        locationmanager.startUpdatingLocation()
        
        loadDefault()
        tableView.dataSource = self
        
        tableView.delegate = self
        
        
    }
    
    
//    @IBAction func addlocationTapped(_ sender: UIButton) {
//
//        performSegue(withIdentifier: "locationScreen", sender: self)
//    }
//
//    @IBAction func addlocationTapped(_ sender: UIBarButtonItem) {
//        
//        performSegue(withIdentifier: "locationScreen", sender: self)
//    }
    
//    
    
    @IBAction func addLocationTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "locationScreen", sender: self)
    }
    
    
    private func getFanshaweLocation() -> CLLocation{
        
        return CLLocation(latitude: 43.0130, longitude: -81.1994)
    }
    
    
    //annotation
    private func addAnotation(location:CLLocation){
        let annotation = MyAnnotation(coordinate: location.coordinate, title: "My title", subtitle: "Lovely subtitle")
        mapView.addAnnotation(annotation)
    }
    
    //mapkit view
    private func setupMap(){
        //set delegate
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        
        let location = CLLocation(latitude: 43.0130, longitude: -81.1994)
        let radiusInmeters: CLLocationDistance = 1000
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radiusInmeters, longitudinalMeters: radiusInmeters)
        
        mapView.setRegion (region, animated: true)
        
        //boundaries
        
        let cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        mapView.setCameraBoundary(cameraBoundary, animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 100000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        
    }
    
    private func loadDefault(){
        list.append(listoflocation(title: "location1", description: "1",icon:UIImage (systemName:
                                                                                        "drop" )))
    }
}

//extension ViewController: CLLocationManagerDelegate{
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        guard let location = locations.last
//                else
//        {
//            return
//        }
//    }
//    
//}



// struct of list

struct listoflocation{
    
    let title: String
    let description: String
    let icon: UIImage?
    
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listoflocations", for: indexPath)
        let item = list[indexPath.row]
        var content = cell.defaultContentConfiguration ()
            
        content.text = item.title
        content.secondaryText = item.description
        // image
        content.image = UIImage(systemName: "drop")
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

//
    extension ViewController: MKMapViewDelegate{
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "WHAT is that?"
            
            let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            
            //set the position of the callout
            view.calloutOffset = CGPoint(x:0,y:0)
            
            //add a button
            let button = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = button
            
            button.tag = 100
            
            
            
            //set image to leftside of callout
            let image = UIImage(systemName: "graduationcap.circle.fill")
            view.leftCalloutAccessoryView = UIImageView(image: image)
            
            //change color of pin
            view.markerTintColor = UIColor.blue
            
            //change colour of accessories
            view.tintColor = UIColor.systemRed
            
            return view
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            
            print("Button Clicked\(control.tag)")
            
            performSegue(withIdentifier: "detaildisclosure", sender: self)
            
            guard let coordinates = view.annotation?.coordinate else{
                return
            }
            
            let launchOptions = [
                MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
            
            
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
            mapItem.openInMaps(launchOptions: launchOptions)
            
        }
        
        
    }
    
    class MyAnnotation: NSObject, MKAnnotation{
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        
        
        init (coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
            
            super .init()
        }
    }
    
   


