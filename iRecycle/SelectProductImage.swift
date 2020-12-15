//
//  SelectProductImage.swift
//  iRecycle
//
//  Created by Luca Santarelli on 05/03/2020.
//  Copyright © 2020 Luca Santarelli. All rights reserved.
//

/* This class was created and used to implement the view allowing the user to choose one of the four images returned by the API, for the unidentified product, to then save on the database. */

import UIKit

class SelectProductImage: UIViewController {

    var identifiedChosenImage: Int? /*Identifier given to the chosen image, so to easily give it back to the previous view (via the overwritten prepare() function).
    
    Class property used to hold a image URL string of an image which doesn't display anything. This will be used to return to the previous view an image containing nothing, for the product, in the case no image is available from the four choices.*/
    var noImageSelected: String = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ7w5CAI9hfYGs7FTYVEw3xsLtkLfVgGas7e3qMLvPgPkKm5xI1"
    
    /*Array containing image URLs retrieved by the API and passed to this variable via a segue done in the AddProduct class.*/
    var imagesFromApi: [String?] = []
    
    //Array of optional string where to store the four displayed images or not.
    var noEmptyImages = [String?](repeating: nil, count: 15) /*Default size of 15 becuase it'll be unkown how many image URLs will be retrieved by the API.*/
    var index: Int = 0
    var imageIndex: Int = 0
    
    
    /*Outlets of the view's four buttons to show the image of the product and allow the user to select thus storing the image on the database.*/
    @IBOutlet var imageOne: UIButton!
    @IBOutlet var imageTwo: UIButton!
    @IBOutlet var imageThree: UIButton!
    @IBOutlet var imageFour: UIButton!
    
    /*When the view is launched the viewDidLoad function is called to display the images as the appropriate buttons background.*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prints successfully the values of the images. DEBUG USE ONLY!!!
        print(imagesFromApi)
        
        var countImagesRetrieved: Int = 0
        
        //Retrieving only valid links from the API, no 'nil' values.
        for i in 0..<imagesFromApi.count
        {
            if (imagesFromApi[i] != nil && (imagesFromApi[i]!.contains(".jpg") || imagesFromApi[i]!.contains(".png")) && !(imagesFromApi[i]!.contains("openfoodfacts-logo")))
            {
                /*If images have been found, store them in an appropriate array to then use their links to display them.*/
                noEmptyImages[index] = imagesFromApi[i]!
                countImagesRetrieved += 1 /*Keeping track of the number of valid image URLs saved.*/
                index += 1
            }
            if (index > 4) { /*When four images have been saved, break out of the for-in loop.*/
                break
            }
        }
        
        /*Switch-statement to check the number of elements in countImagesRetrieved because if it's less than 4, the other image fields will have a default "No image available" image displayed.*/
        switch countImagesRetrieved {
            
        case 0: //Case of no images retrieved.
            
            /*Display for all four button fields the default "No image available" image.*/
            imageIndex = 0
            displayNoImageOne(&imageIndex)
            
            imageIndex = 1
            displayNoImageTwo(&imageIndex)
            
            imageIndex = 2
            displayNoImageThree(&imageIndex)
            
            imageIndex = 3
            displayNoImageFour(&imageIndex)
            
        case 1: //One image is available to be displayed
            
            //call function to display image
            imageIndex = 0
            displayImageOne(&imageIndex)
            
            /*The other two non-available images will be substituted with the "No image available" image.*/
            imageIndex = 1
            displayNoImageTwo(&imageIndex)
            
            imageIndex = 2
            displayNoImageThree(&imageIndex)
            
            imageIndex = 3
            displayNoImageFour(&imageIndex)
            
        case 2: //Two images are available to be displayed
            
            //Call function to display image.
            imageIndex = 0
            displayImageOne(&imageIndex)
            
            //Call function to display image.
            imageIndex = 1
            displayImageTwo(&imageIndex)
            
            /*The other non-available images will be substituted with the "No image available" image.*/
            imageIndex = 2
            displayNoImageThree(&imageIndex)
            
            imageIndex = 3
            displayNoImageFour(&imageIndex)
        
        case 3: //Three images are available to be displayed
            
            //Call function to display image.
            imageIndex = 0
            displayImageOne(&imageIndex)
            
            //Call function to display image.
            imageIndex = 1
            displayImageTwo(&imageIndex)
            
            /*The other non-available images will be substituted with the "No image available" image.*/
            imageIndex = 2
            displayImageThree(&imageIndex)
            
            imageIndex = 3
            displayNoImageFour(&imageIndex)
            
            
        default: //All four images are available to be displayed
            
            //Call appropriate functions to display all four images retrieved.
            imageIndex = 0
            displayImageOne(&imageIndex)
            
            imageIndex = 1
            displayImageTwo(&imageIndex)
            
            imageIndex = 2
            displayImageThree(&imageIndex)
            
            imageIndex = 3
            displayImageFour(&imageIndex)
        }
    } //End viewDidLoad.
    
    /*The next six functions are used to display the images on the button (i.e. displayImageOne()) or display the default 'Not available' one (displayNoImageOne()).*/
    
    //Display appropriate image on first button.
    func displayImageOne(_ imageIndex: inout Int) {
        if let productImageUrl = URL(string: noEmptyImages[imageIndex]!) {
        
            do {
                //If the image's URL can be decoded display it.
                let data = try Data(contentsOf: productImageUrl)
                let newImageOne = UIImage(data: data)
                
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                self.imageOne.setBackgroundImage(newImageOne, for: .normal)
                
            } catch let error {
                /*In case of error when decoding the image to display, display the default 'not available' one.*/
                print("Error: \(error)")
                displayNoImageOne(&imageIndex)
            }
        }
    }
    
    //Display appropriate image on first button.
    func displayNoImageOne(_ imageIndex: inout Int) {
        if let productImageUrl = URL(string: noImageSelected) {
        
            do {
                //Display the default 'not available' image.
                noEmptyImages[imageIndex] = noImageSelected
                let data = try Data(contentsOf: productImageUrl)
                let newImageOne = UIImage(data: data)
                
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                self.imageOne.setBackgroundImage(newImageOne, for: .normal)
                
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    //Display appropriate image on second button.
    func displayImageTwo(_ imageIndex: inout Int) {
        if let productImageUrl = URL(string: noEmptyImages[imageIndex]!) {
        
            do {
                //If the image's URL can be decoded display it.
                let data = try Data(contentsOf: productImageUrl)
                let newImageTwo = UIImage(data: data)
                
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                self.imageTwo.setBackgroundImage(newImageTwo, for: .normal)
                
            } catch let error {
                /*In case of error when decoding the image to display, display the default 'not available' one.*/
                print("Error: \(error)")
                displayNoImageTwo(&imageIndex)
            }
        }
    }
    
    //Display appropriate image on second button.
    func displayNoImageTwo(_ imageIndex: inout Int) {
        if let productImageUrl = URL(string: noImageSelected) {
        
            do {
                //Display the default 'not available' image.
                noEmptyImages[imageIndex] = noImageSelected
                let data = try Data(contentsOf: productImageUrl)
                let newImageTwo = UIImage(data: data)
                
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                self.imageTwo.setBackgroundImage(newImageTwo, for: .normal)
                
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    //Display appropriate image on third button.
    func displayImageThree(_ imageIndex: inout Int) {
        if let productImageUrl = URL(string: noEmptyImages[imageIndex]!) {
        
            do {
                //If the image's URL can be decoded display it.
                let data = try Data(contentsOf: productImageUrl)
                let newImageThree = UIImage(data: data)
                
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                self.imageThree.setBackgroundImage(newImageThree, for: .normal)
                
            } catch let error {
                /*In case of error when decoding the image to display, display the default 'not available' one.*/
                print("Error: \(error)")
                displayNoImageThree(&imageIndex)
            }
        }
    }
    
    //Display appropriate image on third button.
    func displayNoImageThree(_ imageIndex: inout Int) {
        if let productImageUrl = URL(string: noImageSelected) {
        
            do {
                //Display the default 'not available' image.
                noEmptyImages[imageIndex] = noImageSelected
                let data = try Data(contentsOf: productImageUrl)
                let newImageThree = UIImage(data: data)
                
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                self.imageThree.setBackgroundImage(newImageThree, for: .normal)
                
            } catch let error {
                print("Error: \(error)")
            }
        }
    }

    //Display appropriate image on fourth button.
    func displayImageFour(_ imageIndex: inout Int) {
        if let productImageUrl = URL(string: noEmptyImages[imageIndex]!) {
        
            do {
                //If the image's URL can be decoded display it.
                let data = try Data(contentsOf: productImageUrl)
                let newImageFour = UIImage(data: data)
                
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                self.imageFour.setBackgroundImage(newImageFour, for: .normal)
                
            } catch let error {
                /*In case of error when decoding the image to display, display the default 'not available' one.*/
                print("Error: \(error)")
                displayNoImageThree(&imageIndex)
            }
        }
    }
    
    //Display appropriate image on fourth button.
    func displayNoImageFour(_ imageIndex: inout Int) {
        if let productImageUrl = URL(string: noImageSelected) {
        
            do {
                //Display the default 'not available' image.
                noEmptyImages[imageIndex] = noImageSelected
                let data = try Data(contentsOf: productImageUrl)
                let newImageFour = UIImage(data: data)
                
                /*Using the button's IBOutlet property to set its background image (setBackgroundImage).*/
                self.imageFour.setBackgroundImage(newImageFour, for: .normal)
                
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    /*The next four function outlets are used to select one of the four images available for the product or a 'not available' one (noMatchImage), to then save on the database.*/
    
    //Selecting image one.
    @IBAction func imageOneAction(_ sender: Any) {
        
        //Image one identifier for segue.
        identifiedChosenImage = 1
        //Display confirmation of selected image.
        let viewAlert = UIAlertController(title: "Thank you!", message: "Press 'OK' to confirm the choice of the first image and go back.", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
        
            /*Implement an Unwind segue in the OK button, to re-direct user to the AddProduct class view.*/
            self.performSegue(withIdentifier: "unwindToAddProduct", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        viewAlert.addAction(confirmAction)
        viewAlert.addAction(cancelAction)
        
        present(viewAlert, animated: true, completion: nil)
    }
    
    //Selecting image two.
    @IBAction func imageTwoAction(_ sender: Any) {
        
        //Image two identifier for segue.
        identifiedChosenImage = 2
        //Display confirmation of selected image.
        let viewAlert = UIAlertController(title: "Thank you!", message: "Press 'OK' to confirm the choice of the second image and go back.", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
        
            /*Implement an Unwind segue in the OK button, to re-direct user to the AddProduct class view.*/
            self.performSegue(withIdentifier: "unwindToAddProduct", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        viewAlert.addAction(confirmAction)
        viewAlert.addAction(cancelAction)
        
        present(viewAlert, animated: true, completion: nil)
    }
    
    //Selecting image three.
    @IBAction func imageThreeAction(_ sender: Any) {
        
        //Image three identifier for segue.
        identifiedChosenImage = 3
        //Display confirmation of selected image.
        let viewAlert = UIAlertController(title: "Thank you!", message: "Press 'OK' to confirm the choice of the third image and go back.", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
        
            /*Implement an Unwind segue in the OK button, to re-direct user to the AddProduct class view.*/
            self.performSegue(withIdentifier: "unwindToAddProduct", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        viewAlert.addAction(confirmAction)
        viewAlert.addAction(cancelAction)
        
        present(viewAlert, animated: true, completion: nil)
    }
    
    //Selecting image four.
    @IBAction func imageFourAction(_ sender: Any) {
        //Image three identifier for segue.
        identifiedChosenImage = 4
        //Display confirmation of selected image.
        let viewAlert = UIAlertController(title: "Thank you!", message: "Press 'OK' to confirm the choice of the fourth image and go back.", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
        
            /*Implement an Unwind segue in the OK button, to re-direct user to the AddProduct class view.*/
            self.performSegue(withIdentifier: "unwindToAddProduct", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        viewAlert.addAction(confirmAction)
        viewAlert.addAction(cancelAction)
        
        present(viewAlert, animated: true, completion: nil)
    }
    
    //Selecting 'not available' image.
    @IBAction func noMatchImage(_ sender: Any) {
        
        //Identifier for segue, when 'no match' for image button is pressed.
        identifiedChosenImage = 5
        //Display confirmation of no image being selected.
        let viewAlert = UIAlertController(title: "Sorry!", message: "Sorry an appropriate image could not be found. Press 'OK' to go back or 'Cancel' to choose an appropriate one.", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) -> Void in
        
            /*Implement an Unwind segue in the OK button, to re-direct user to the AddProduct class view.*/
            self.performSegue(withIdentifier: "unwindToAddProduct", sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        
        viewAlert.addAction(confirmAction)
        viewAlert.addAction(cancelAction)
        
        present(viewAlert, animated: true, completion: nil)
    }
    
    /*The prepare() function is called whenever a segue is performed. This function is overridden, to take in values to be the passed to another view (UI).*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if identifiedChosenImage == 1 {
            /*Perform segue to AddProduct class view by returning the image URL of the first image selected, to then be stored on the database.*/
            let receiverVC = segue.destination as! AddProduct
            receiverVC.apiImageSelected = noEmptyImages[0]!
        }
        else if identifiedChosenImage == 2 {
            /*Perform segue to AddProduct class view by returning the image URL of the second image selected, to then be stored on the database.*/
            let receiverVC = segue.destination as! AddProduct
            receiverVC.apiImageSelected = noEmptyImages[1]!
        }
        else if identifiedChosenImage == 3 {
            /*Perform segue to AddProduct class view by returning the image URL of the third image selected, to then be stored on the database.*/
            let receiverVC = segue.destination as! AddProduct
            receiverVC.apiImageSelected = noEmptyImages[2]!
        }
        else if identifiedChosenImage == 4 {
            /*Perform segue to AddProduct class view by returning the image URL of the fourth image selected, to then be stored on the database.*/
            let receiverVC = segue.destination as! AddProduct
            receiverVC.apiImageSelected = noEmptyImages[3]!
        }
        else {
            /*Perform segue to AddProduct class view by returning the image URL of the 'not available' image, to then be stored on the database.*/
            let receiverVC = segue.destination as! AddProduct
            receiverVC.apiImageSelected = noImageSelected
        }
    }
}
