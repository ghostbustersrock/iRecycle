//
//  HazardousCentres.swift
//  iRecycle
//
//  Created by Luca Santarelli on 16/01/2020.
//  Copyright © 2020 Luca Santarelli. All rights reserved.
//

/* This class was created to be used to implement any additional features in the H. CENTRES tab bar view easily. */

import UIKit

class HazardousCentres: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*The below IBAction outlets are implemented and configured so that both their corresponding buttons on the app's view re-direct to a web page in Safari, if pressed.*/
    
    //Outlet to open information regarding products that can and cannot be collected.
    @IBAction func PDF_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.cityoflondon.gov.uk/services/environment-and-planning/waste-and-recycling/household-waste-and-recycling/Documents/Chemical-information-sheet.pdf")! as URL, options: [:], completionHandler: nil)
    }
    
    //Outlet to open The Corporation of London webpage.
    @IBAction func COLsite_URL(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.cityoflondon.gov.uk/services/environment-and-planning/waste-and-recycling/household-waste-and-recycling/Pages/Hazardous-Waste.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
}
