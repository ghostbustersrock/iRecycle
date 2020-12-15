//
//  AddProduct.swift
//  iRecycle
//
//  Created by Luca Santarelli on 31/01/2020.
//  Copyright © 2020 Luca Santarelli. All rights reserved.
//

/* This class was created and used to add new unidentified products to the database. Here the API is used to try and retrieve the name and image URLs of the unidentified product to save.
 
 
 display the 'how to recycle' and general information of an identified scanned product. This class is connected to the Display Recycling view. */

import UIKit
import RealmSwift

/*These structures are used as models to parse appropriately the JSON file, to retrieve the appropriate information about the product's data to save.*/
struct Root: Codable {
    let items: [Item]
}

struct Item: Codable {
    let pagemap: Pagemap
    let title: String?
}

struct Pagemap: Codable {
    let metatags: [Metatag]
}

struct Metatag: Codable {
    let ogImage: String?
    
    enum CodingKeys: String, CodingKey {
        /*Enumeration case with raw value (i.e. "og:image") of the same type (String). The enumeration will have a CodingKey protocol defined used for encoding and decocding data.
        This raw value is used to identify the field of the JSON file from which to retrieve the image URL of the product to save.*/
        case ogImage = "og:image"
    }
}

class AddProduct: UIViewController {
    
    /*IBAction outlet used for an unwind segue (to return directly here from another view).*/
    @IBAction func unwindToAddProduct(_ segue: UIStoryboardSegue) {
        
    }
    
    var savedBarcode: String? /*Where to save the unidentified product's barcode, passed from the segue done in the ScannerController or ManualBarcode class.*/
    
    var savedName: String? /*Where to save the unidentified product's name, retrieved by the API, to then display it on the 'nameInput' outlet text field, of the UI.*/
    var identifierForSegue: Int?
    //Where to sore the images URL retrieved by the API
    var retrievedImages: [String?] = []
    
    /*Where to save the image URL, once selected from the "SelectProductImage" class view and passed here with a segue. Default value given is an image URL displaying nothing, in the case the user saves the data without choosing an image for the product.*/
    var apiImageSelected: String = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ7w5CAI9hfYGs7FTYVEw3xsLtkLfVgGas7e3qMLvPgPkKm5xI1"
    
    /*Outlets respectively for the label where to display the barcode number, the Text Field of the product's name and the Text View of where the user will input the 'how to recycle' information of a product.*/
    @IBOutlet var barcodeInput: UILabel!
    @IBOutlet var nameInput: UITextField!
    @IBOutlet var informationInput: UITextView!
    
    /*Function invoked when the UI is launched for the first time by the user in the app.*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*URL used to make the API called. savedBarcode will be substituted by the barcode value stored in it after a segue was performed in the ScannerController or ManualBarcode class.*/
        let jsonURLString = "https://www.googleapis.com/customsearch/v1?q=\(savedBarcode!)&cx=011147667639126255805:0nf80kc8irs&key=AIzaSyCLmrIUIkQthSNJKO-0APYPjAtm-HwktUc"

        //Trying to identify the URL path of our jsonURLString model URL.
        guard let url = URL(string: jsonURLString) else { return }
        
        /*Retrieving the contents of the URL specified in 'jsonURLString', consequently calling a handler function to execute.*/
        URLSession.shared.dataTask(with: url) {(data, response, err) in

            /*Storing the data decoded from jsonURLString in the variable 'data' of type Data.*/
            guard let data = data else { return }

            do {
                //Parsing the data from the JSON file based on our model structures.
                let decoder = JSONDecoder()
                
                /*Changing the view format of the decoded JSON file key names from snake case names (names_written_like_this) to camel case names (namesWrittenLikeThis).*/
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                //Decodes the JSON file data based on the Root model structure
                let response = try decoder.decode(Root.self, from: data)
                
                /*Mapping the results of the images retrieved from the 'og:image' field, by the API, in an array of type optional String.*/
                let firstMap = response.items.map({$0.pagemap.metatags.first?.ogImage})
                
                //Store retrieved images URL in the class' property.
                self.retrievedImages = firstMap
                
                /*Mapping the results of the titles retrieved from the 'title' field, by the API, in an array of type optional String.*/
                let secondMap = response.items.map({$0.title})
                
                /*Iterating the mapped results of the product's name to store in a variable only a valid name (different than nil).*/
                for i in 0..<secondMap.count {
                    if(secondMap[i] != nil)
                    {
                        //Saving a valid name of the product retrieved by the API.
                        self.savedName = secondMap[i]
                        break //Terminate for-in loop once value is saved.
                    }
                }
                
            } catch let jsonErr {
                //Print the following error, in case of error.
                print("Error printing json data", jsonErr)
            }
            
        }.resume() //Resumes the API call if it gets suspended.
        
        /*Display the product's barcode in the UIs label, identified with the 'barcodeInput' outlet.*/
        barcodeInput.text = savedBarcode
    } //End of viewDidLoad.
    
    /*Outlet used as a function, of the 'click me' button in the 'Product's name' section of the UI. Clicking the button will display in the Text Field, as a placeholder, the name of the product to save.*/
    @IBAction func showProductName(_ sender: Any) {
        
        if (savedName != nil)
        {
            //Display product's name in the Text Field
            nameInput.placeholder = "\(String(describing: savedName!))"
        }
        else
        {
            //Display another text in the Text Field when no name is retrieved by the API.
            nameInput.placeholder = "NO NAME FOUND"
        }
    }
    
    /*Outlet connected to button on this class' view, which allows to select one of three images which best identifies the product to save onto the database. When the button is pressed a segue to the view displaying the three images will occur.*/
    @IBAction func selectAPIimage(_ sender: Any) {
        
        identifierForSegue = 2 //Identifier used to perform the correct segue.
        //Perform segue to the UI which has a segue identifier called 'selectImage'.
        self.performSegue(withIdentifier: "selectImage", sender: self)
    }
    
    /*The prepare() function is called whenever a segue is performed. This function is overridden, to take in values to be the passed to another view (UI).*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*If statement used make sure the segue with the 'selectImage' identifier is performed.*/
        if (identifierForSegue != 1) {
            let receiverVC = segue.destination as! SelectProductImage
            //Sending to the other view the image URLs retrieved by the API.
            receiverVC.imagesFromApi = retrievedImages
        }
    }
    
    /*Outlet connected to the button on this class' view to save the product's inputted data on the database.*/
    @IBAction func saveInputs(_ sender: Any) {
        
        let emptyString: String = "" /*String value compared with the possible cases of the switch-statement.
        
        Switch-statement used to check if all the necessary fields of the product have been filled, before saving the data (default case).*/
        switch emptyString {
        
        //Case where the name and/or information field have been left empty.
        case String(nameInput.text!), String(informationInput.text):
        
            //Checking if both the name and information field have been left empty.
            if(nameInput.text!.isEmpty && informationInput.text!.isEmpty)
            {
                //Display message relative to both fields being empty.
                let viewAlert = UIAlertController(title: "Nothing inputted", message: "Please fill in all the present fields before saving.", preferredStyle: .actionSheet)
            
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
                viewAlert.addAction(cancelAction)
                present(viewAlert, animated: true, completion: nil)
            }
            
            //Checking if only the name field has been left empty.
            else if (nameInput.text!.isEmpty)
            {
                let viewAlert: UIAlertController
                /*If the savedName has a valid product name, returned from the API, then display an alert showing this name.*/
                if (savedName != nil) {
                    viewAlert = UIAlertController(title: "No product name inputted", message: "Please make sure the name of the product is similar to '\(savedName!)' before saving.", preferredStyle: .actionSheet)
                }
                /*If the savedName doesn't have a valid product name, returned from the API, then display an alternative alert.*/
                else
                {
                    viewAlert = UIAlertController(title: "No product name inputted", message: "Please input the correct name of the product before saving.", preferredStyle: .actionSheet)
                }
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                
                viewAlert.addAction(cancelAction)
                present(viewAlert, animated: true, completion: nil)
            }
            
            /*Else statement executed if only the information field has been left empty.*/
            else
            {
                /*Alert displayed, asking the user to input something in the information field.*/
                let viewAlert = UIAlertController(title: "No information inputted", message: "Please input the information of the product before saving.", preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                
                viewAlert.addAction(cancelAction)
                
                present(viewAlert, animated: true, completion: nil)
            }
            
        //If none of the view's fields are empty than save the data.
        default:
            /*Pop-up telling the user it will redirect them back to the home view (unwind segue), alongside the data being saved to the database, if 'OK' is pressed, otherwise they can continue on editing the data.*/
            let viewAlert = UIAlertController(title: "Success!", message: "The data for \(String(nameInput.text!)) will be saved. Click 'OK' to be redirected home or cancel to make edits.", preferredStyle: .actionSheet)
            
            let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
    
                /*Creating an instance of Realm to add the new inputted data to the database.*/
                let realm = try! Realm()
                //Adding the new inputted product
                realm.beginWrite()
                //Creating new instance of Product class to add new product to database.
                let myProduct = Product()
                myProduct.name = String(self.nameInput.text!) //Saving name from text field.
                myProduct.barcode = self.savedBarcode! //Saving barcode passed from class segue.
                myProduct.information = String(self.informationInput.text!) /*Saving information from the text view.*/
                myProduct.image = self.apiImageSelected /*Saving the default or chosen product image (one chosen out of four)*/
                realm.add(myProduct) //Adding the product's object to Realm instance.
                try! realm.commitWrite() //Saving the objects to Realm database.
            
                /*Performing unwind segue to home page once the data has been saved successfully. A segue identifier of 1 has been given so there is no overwriting done in the 'prepare' function (only the segue with identifier 2 must overwrite the 'prepare' function).*/
                self.identifierForSegue = 1
                //Unwind segue back to the home page (ViewController).
                self.performSegue(withIdentifier: "goHome", sender: self)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            viewAlert.addAction(confirmAction)
            viewAlert.addAction(cancelAction)
            present(viewAlert, animated: true, completion: nil)
        
        }//End of switch statement.
    } //Eend of IBAction func saveInputs.
} //End of class AddProduct.
