//
//  DisplayRecycling.swift
//  iRecycle
//
//  Created by Luca Santarelli on 30/01/2020.
//  Copyright © 2020 Luca Santarelli. All rights reserved.
//

/* This class was created and used to display the 'how to recycle' and general information of an identified scanned product. This class is connected to the Display Recycling view. */

import UIKit

class DisplayRecycling: UIViewController {

    /*The below three properties will be used to store the values passed by the segue peformed in the ScannerController class.*/
    
    var nameProduct: String? //Stores name of identified product.
    var imageProduct: String? //Stores the image URL of the identified product.
    var recyclingInformation: String? /*Stores the 'how to recycle' information of the identified product.*/
    
    //IBOutlets of the two labels and image present on the class' view.
    @IBOutlet var productName: UILabel!
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productInformation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Displaying the segue's passed name of the product on the UIs label where the product's name should be displayed.*/
        productName.text = nameProduct
        productInformation.text = recyclingInformation
        
        //Making a URL request to display the image of the identified product.
        if let productImageUrl = URL(string: imageProduct!) {

            do {
                
                let data = try Data(contentsOf: productImageUrl)
                /*Assigning the decoded image metadata to the UIs image outlet property, to be displayed.*/
                productImage.image = UIImage(data: data)
                
            } catch let error {
                
                /*In case of error, display the default 'no image available' image if unable to display the product's image.*/
                let noImageSelected: String = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ7w5CAI9hfYGs7FTYVEw3xsLtkLfVgGas7e3qMLvPgPkKm5xI1"
                let productImageURL = URL(string: noImageSelected)
                let data = try! Data(contentsOf: productImageURL!)
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                productImage.image = UIImage(data: data)
            }
        }
    }
}
