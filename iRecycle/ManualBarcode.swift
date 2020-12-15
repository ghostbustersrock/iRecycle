//
//  ManualBarcode.swift
//  iRecycle
//
//  Created by Luca Santarelli on 06/02/2020.
//  Copyright © 2020 Luca Santarelli. All rights reserved.
//

/* This class was created and used to manually input the EAN13 barcode identifier of a product, allowing for its data to be displayed, if identified, or added to the database, if not. */

import UIKit
import RealmSwift //Library for the Realm database to function.

class ManualBarcode: UIViewController {
    
    var resultFound: Bool? /*Boolean variable used to dinstinguish which type of overwriting segue to do in the prepare() function.*/
    var productName: String? //Where to store name of identified product.
    var productImage: String? //Where to store image URL of identified product.
    var productInformation: String? /*Where to store information of identified
    
    Outlet of the view's text field, where the user will input the EAN13 identifier of the barcode.*/
    @IBOutlet weak var barcodeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*Outlet of the view's button, pressed once the EAN13 identifier has been inputted, to search for the product with that specific barcode identifier.*/
    @IBAction func searchProduct(_ sender: UIButton) {
        
        //Checking if the text field is empty.
        if (barcodeField.text!.isEmpty)
        {
            //Pop-up asking to write something if nothing has been entered.
            let noValue = UIAlertController(title: "Nothing typed", message: "Please insert a EAN13 barcode number.", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
             
            noValue.addAction(cancelAction)
            present(noValue, animated: true, completion: nil)
        }
        
        //Checking if the inputted barcode has less than 13 digits.
        else if (barcodeField.text!.count < 13)
        {
            //Checking inputted digits are numbers or not.
            if (barcodeField.text!.toInt == false)
            {
                //If the digits aren't numbers than display appropriate alert.
                let notInt = UIAlertController(title: "Not a number", message: "Please insert only numerical digits.", preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                 
                notInt.addAction(cancelAction)
                present(notInt, animated: true, completion: nil)
            }
            else
            {
                /*If the digits are numbers than display alert regarding inputted number having too little digits.*/
                let lowerInput = UIAlertController(title: "Too little digits", message: "The inputted barcode has lesser digits than 13 expected ones.", preferredStyle: .actionSheet)
            
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
             
                lowerInput.addAction(cancelAction)
                present(lowerInput, animated: true, completion: nil)
            }
        }
           
        //Checking if the inputted barcode has more than 13 digits.
        else if (barcodeField.text!.count > 13)
        {
             //Checking inputted digits are numbers or not.
            if (barcodeField.text!.toInt == false)
            {
                //If the digits aren't numbers than display appropriate alert.
                let notInt = UIAlertController(title: "Not a number", message: "Please insert only numerical digits.", preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                 
                notInt.addAction(cancelAction)
                present(notInt, animated: true, completion: nil)
            }
            else
            {
                /*If the digits are numbers than display alert regarding inputted number having too many digits.*/
                let biggerInput = UIAlertController(title: "Too many digits", message: "The inputted barcode has more digits than 13 expected ones.", preferredStyle: .actionSheet)
            
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
             
                biggerInput.addAction(cancelAction)
                present(biggerInput, animated: true, completion: nil)
            }
        }
        
        //Statement to execute if a correct 13 digit EAN13 identifier has been inputted.
        else
        {
            //Checking inputted digits are numbers or not.
            if (barcodeField.text!.toInt == false)
            {
                //If the digits aren't numbers than display appropriate alert.
                let notInt = UIAlertController(title: "Not a number", message: "Please insert only numerical digits.", preferredStyle: .actionSheet)
                           
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                            
                notInt.addAction(cancelAction)
                present(notInt, animated: true, completion: nil)
            }
            //Search for the product.
            else
            {
                let realm = try! Realm() /*Creating an instance of Realm to work on the database.
            
                 Checking if the inputted EAN13 identifier is found on the Realm database: .filter("barcode = '\(String(describing: barcodeField.text!))'").*/
                let databaseResults = realm.objects(Product.self).filter("barcode = '\(String(barcodeField.text!))'")
            
                //If a barcode is found on the database (!= 0) then display it.
                if (databaseResults.count != 0)
                {
                    if ((databaseResults[0].barcode) != nil)
                    {
                        resultFound = true
                    
                        /*Alert displayed to the user stating the product of that barcode was found on the database.*/
                        let viewProduct = UIAlertController(title: "Found: \(databaseResults[0].name!)", message: "View \(databaseResults[0].name!) recycling information?", preferredStyle: .actionSheet)
            
                        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                        
                            /*If 'Confirm' button is pressed than a segue to another view (UI) is executed to display data related to the product.*/
                            self.productName = databaseResults[0].name
                            self.productImage = databaseResults[0].image
                            self.productInformation = databaseResults[0].information
                         
                            /*Performing a segue to the UI to display the product's information.*/
                            self.performSegue(withIdentifier: "viewProduct", sender: self)
                        })
                   
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
                        viewProduct.addAction(confirmAction)
                        viewProduct.addAction(cancelAction)
            
                        present(viewProduct, animated: true, completion: nil)
                    }
                }
                
                else //No product with the inputted barcode is found on the database.
                {
                    resultFound = false
                
                    /*Ask user whether to add the unidentified product to the database (via a pop-up alert).*/
                    let addProduct = UIAlertController(title: "No product found", message: "Add the unidentified product to the database?", preferredStyle: .actionSheet)
                 
                    let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
                        self.performSegue(withIdentifier: "addProduct", sender: self)
                    })
                
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
                 
                    addProduct.addAction(confirmAction)
                    addProduct.addAction(cancelAction)
                    present(addProduct, animated: true, completion: nil)
                }
            }
        }
        
    } //END of button action.
    
    /*The prepare() function is called whenever a segue is performed. This function is overridden, to take in values to be passed to another view (UI).*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Checking which overwriting segue to perform.
        if (resultFound!)
        {
            /*Passing values to the DisplayRecycling class, of this view, to display 'how to recycle' information of identified scanned products.*/
            let receiverVC = segue.destination as! DisplayRecycling
            receiverVC.nameProduct = productName
            receiverVC.imageProduct = productImage
            receiverVC.recyclingInformation = productInformation
        }
        else
        {
            /*Passing values to the AddProduct class, of this view, to add unidentified products to the database.*/
            let receiverVC = segue.destination as! AddProduct
            receiverVC.savedBarcode = barcodeField.text /*Passing barcode value inputted in the view's text field.*/
        }
    }
} //End of class ManualBarcode

/*Adding an extension to the String type to check if the user's inputted barcode digits are numbers rather than characters.*/
extension String {
    
    var toInt: Bool {
        return Int(self) != nil
    }
}
