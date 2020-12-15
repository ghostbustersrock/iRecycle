//
//  TowerHamlets.swift
//  iRecycle
//
//  Created by Luca Santarelli on 16/01/2020.
//  Copyright © 2020 Luca Santarelli. All rights reserved.
//

/* This class was created and used to implement any additional features in the T. HAMLETS tab bar view easily. */

import UIKit

class TowerHamlets: UIViewController, UIScrollViewDelegate {

    /*The below two IBOutlets are relative to the secondary scroll view embedded in the Tower Hamlets tab bar primary scroll view and the image we want to zoom in on, respectively.*/
    @IBOutlet var subScroll: UIScrollView! //Outlet for the secondary scroll view.
    @IBOutlet var imageZoom: UIImageView!  //Outlet for the image to zoom in on.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Making the outlet of the secondary scroll view a delegate of the UIScrollViewDelegate class, thus enabling the zoom in gesture to work properly (via the viewForZooming function).*/
        subScroll?.delegate = self
    }
    
    /*Function implemented to return the image, of the products that can be recycled, zoomed in based on whether the user uses the zoom in gestures.*/
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        //Returnig the zoomed image.
        return imageZoom
    }
    
    
    /*All of the below IBAction outlets are being implemented so to have their corresponding buttons be hyperlinks to web pages, which Safari will open, once the buttons on the app's view are pressed.*/
    
    /*Opens the web page to check the time and date for waste collection from a property or neighborhood.*/
    @IBAction func CollectionInfo_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/lgnl/environment_and_waste/recycling_and_waste/waste_collections.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
    //Opens the web page to check the time for daily collection in streets.
    @IBAction func DailyCollinfo_URL(_ sender: Any) {
         UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/lgnl/environment_and_waste/recycling_and_waste/Timed_recycling_and_waste_collections.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
    //Opens the webpage to contact the Tower Hamlets council.
    @IBAction func Contact_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/content_pages/contact_us/contact_us.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
    //Opens the webpage to report recycling related queries/issues.
    @IBAction func Report_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/lgnl/environment_and_waste/recycling_and_waste/Report-waste-and-street-cleaning.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
    //Opens the webpage to check for locations of reycling banks.
    @IBAction func Banks_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/Documents/Waste-management/Waste-reduction/Recycling/Recycling_Centre_Location_List_for_Web_Page_updated_June_2018.pdf")! as URL, options: [:], completionHandler: nil)
    }
    
    //Opens the webage to have information on bulky waste.
    @IBAction func Bulky_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/lgnl/environment_and_waste/recycling_and_waste/Bulky_waste/bulky_waste.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
    //Opens the webpage PDF for information on food waste doorstep collection.
    @IBAction func Doorstep_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/Documents/Waste-management/Waste-reduction/Recycling/food-leaflet-lowrise-and-doorstep.pdf")! as URL, options: [:], completionHandler: nil)
    }
    
    //Opens the webpage PDF for information on food waste communal collection.
    @IBAction func Communal_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/Documents/Waste-management/Waste-reduction/Recycling/food-leaflet-estates.pdf")! as URL, options: [:], completionHandler: nil)
    }
    
    //Opens the webpage PDF for extra information on Tower Hamlets waste strategy.
    @IBAction func PDF_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.towerhamlets.gov.uk/Documents/WasteStrategy_final.pdf")! as URL, options: [:], completionHandler: nil)
    }
}
