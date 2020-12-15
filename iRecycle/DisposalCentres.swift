//
//  DisposalCentres.swift
//  iRecycle
//
//  Created by Luca Santarelli on 16/01/2020.
//  Copyright © 2020 Luca Santarelli. All rights reserved.
//

/* This class file (DisposalCentres.swift) was created and is used for to implement any additional features in the D. CENTRES tab bar view easily. */

import UIKit
import MapKit //Imported library to use the maps element in our app.

class DisposalCentres: UIViewController {
    
    //Outlet of the MKMapView
    @IBOutlet var pinPoint: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*Creating an instance of the map pin's class (MKPointAnnotation) to modify its attributes.*/
        let pinLocation = MKPointAnnotation()
        
        /*Setting the latitudinal and longitudinal coordinates of the pin point on our map, so to be viewed once launched.*/
        pinLocation.coordinate = CLLocationCoordinate2D(latitude: 51.505088, longitude: -0.006088)
        
        //Giving the pin point a title.
        pinLocation.title = "Tower Hamlets Reuse & Recycling Centre"
        
        //Creating the pin, to be displayed on the map, using the map's outlet.
        pinPoint?.addAnnotation(pinLocation)
        
        /*The below lines of code are used to have the map zoom in on our pin, automatically, once it launches.*/
        let zoomRegion = MKCoordinateRegion(center: pinLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        //Creating the zoomed in region.
        pinPoint?.setRegion(zoomRegion, animated: false)
    }
}
