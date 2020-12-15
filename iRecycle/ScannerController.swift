//
//  ScannerController.swift
//  iRecycle
//
//  Created by Luca Santarelli on 16/12/2019.
//  Copyright © 2019 Luca Santarelli. All rights reserved.
//

/* NOTE: Not all code belongs to me (Luca Santarelli) within this class. All the code belonging to someone else other than me will be referenced in comments, accordingly. Comments throughout the code have been added by me. */

/* This class was created and used to implement the scanner feature, in one of the app's views, which is connected directly to the main view (HOME tab bar view).*/

import UIKit
import RealmSwift //Library for the Realm database to function.
/*Importing the AVFoundation framework so to have different types of codes (i.e. QR, barcode, etc), scanned (captured).*/
import AVFoundation

class ScannerController: UIViewController {
    
    let realm = try! Realm() //Creating an instance of Realm to work on the database.
    
    var resultFound: Bool? /*Boolean variable used to dinstinguish which type of overwriting segue to do in the prepare() function.*/
    
    /*The decodedMetadata property is used to store the value of the identified barcode number.*/
    var decodedMetadata: String?
    var productName: String? //Where to store name of identified product.
    var productImage: String? //Where to store image URL of identified product.
    var productInformation: String? //Where to store information of identified product.
    
    /*Outlets used to have the top bar and bottom bar of the scanner's view brought in front of the capture session. The bottomBar outlet will be the bottom bar view on the scanner.*/
    @IBOutlet var topbar: UIView!
    @IBOutlet var bottomBar: UIView!
    
//---------------------------------------------------------------------------
    /* Title: Barcode and QR code reader built in Swift (QRCodeReader)
    Author: simonng, StephenClarkApps and vinceyuan
    Date: 2019
    Code version: Latest commit 3 Oct. 2019
    Availability: https://github.com/appcoda/QRCodeReader.git */
    
    /* An instance of the class AVCaptureSession is declared to try and perform a real-time capture of the iPhone's video (retrieving the actual video footage).
     An input and output method (.addInput and .addOutput) of this object will need to be filled with identified data and decoded data, respectively, so to coordinate the flow of the data captured from our video's input (camera) to our output.*/
    var captureSession = AVCaptureSession()
    
    /*This property is used to display the video of what is being captured by the iPhone's camera.*/
    
    var previewOfVideo: AVCaptureVideoPreviewLayer?
    
    /*This variable is used to create a green rectangled shaped around the barcode being captured.*/
    var frameOfBarcode: UIView?
    
    /*In the array of type AVMetadataObject.ObjectType there are the formats of barcodes, QR codes, etc., which can be identified by the iPhone's camera.
    
    Only the ean13 format is necessary to be identified. The rest will be used for the app to display an alert, if the scanned barcode is not EAN 13.*/
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*The variable 'captureDevice' will be used to store the value of whether or not the iPhone's back facing camera has been activated (captured) or not (AVCaptureDevice). If the iPhone's camera hasn't been captured then the program returns an error on the command line (see print statement in 'else' expression). If the camera was retrieved successfully, then the successful identification of the retrieved camera is stored in the 'captureDevice' variable, and the program continues.
        
        The AVCaptureDevice class is used to find all available capture devices matching a specific device type (AVMediaType.video => retrieve device compatible of capturing videos).*/
        
        //Guard statement is used to assign the declared class instance to the constant 'captureDevice' if no error occurs. If an error does occur the guard statement executes another body printing an error on the command line and exiting the 'viewDidLoad' function.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Unable to launch the camera.")
            return
        }
        
        //MARK: - IDENTIFY AND PROCESS METADATA.
        /*This 'do' block is responsible of initially identifying the metadata and then create the input and output session necessary for the metadata to be identified and processed.*/
        do {
            /*Trying to capture the video (AVCaptureDeviceInput) of the accessed device stored in 'captureDevice' (iPhone back camera). If the video of the camera is captured, it is stored in the constant 'input' (used to show this video).*/
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            /*Performing a real time capture of our barcode, via our iPhone's camera, and adding the 'input' constant metadata (captured information), to the real time capture session.*/
            captureSession.addInput(input)
            
            /*Creating an instance of the AVCaptureMetadataOutput class to intercept any metadata found from the barcode captured by the camera and process it into a human readable content (in combination with the AVCaptureMetadataOutputObjectsDelegate protocol).*/
            let captureMetadataOutput = AVCaptureMetadataOutput()
            
            /*Setting the previous output decoded data (captureMetadataOutput) to our capture session ('captureSession' variable). */
            captureSession.addOutput(captureMetadataOutput)

            /*'.setMetadataObjectsDelegate()', is a  method of the 'AVCaptureMetadataOutput' class, conforming to the 'AVCaptureMetadataOutputObjectsDelegate' protocol, allowing to set a delegate object to which the captured metadata objects are sent to, for further processing. The delegate is set to 'self', such that the current instance of AVCaptureMetadataOutput() (captureMetadataOutput) is the delegate object. In the method, the dispatch queue (DispatchQueue.main) on which to execute the delegate’s methods is specified as a parameter, making sure the metadata objects are processed. The queue has to be serial (Apple default) ensuring the metadata objects are delivered in the order in which they were received. 'DispatchQueue.main' creates the main queue associated with the application's main thread (Apple's default serial dispatch queue). */
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            /* Setting the property 'metadataObjectTypes', of the AVCaptureMetadataOutput() class instance (captureMetadataOutput), to an array of type 'AVMetadataObject.ObjectType', containing all the possibile metadata objects identifiable (i.e. ean13). */
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            /*These lines of code are run if in the above 'do' block, an error occurs. This will print an error and block the working of the scanner.*/
            print(error)
            return
        }
        
        //MARK: - DISPLAY CAPTURED VIDEO.
        /*The video captured by the iPhone's camera, now has to be displayed on the UI created. The class 'AVCaptureVideoPreviewLayer' is used. The preview layer is used concurrently with an AV capture session to display the video on our created UI, using the preview layer as an additional sublayer of the UI's current view.
        
        Creating an instance of 'AVCaptureVideoPreviewLayer' and initializing the property 'session' with 'captureSession', the instance of the 'AVCaptureSession' class (necessary to manage the flow of data from input device to the output).*/
        previewOfVideo = AVCaptureVideoPreviewLayer(session: captureSession)
        
        /*Setting the property 'videoGravity' to display the captured video layer with specific bounds. The bounds are specified by setting the 'AVLayerVideoGravity' struct property to 'resizeAspectFill' (preserves the video’s aspect ratio and fills the layer’s bounds). */
        previewOfVideo?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        /*Constraining the bounds of the captured video to that of the device's main view.*/
        previewOfVideo?.frame = view.layer.bounds
        
        //Adding the preview layer into the main view's layer hierarchy.
        view.layer.addSublayer(previewOfVideo!)
        
        /*Start the capturing of the iPhone's video by calling the method 'startRunning' of the 'AVCaptureSession' class instance.*/
        captureSession.startRunning()
        
        /*This moves the message label and the top bar of the scanner UI (of our app) to the front so to see what they are displaying.*/
        view.bringSubviewToFront(bottomBar)
        view.bringSubviewToFront(topbar)
        
        /*Creating an instance (frameOfBarcode) of the UIView class to create a highlight on the identified barcode (rectangular box).*/
        frameOfBarcode = UIView()
        
        //Checking if any barcode is identified.
        if let frameOfBarcode = frameOfBarcode {
            /*Making the color of the border green (borderColor property) with a border width (borderWidth property) of 9.*/
            frameOfBarcode.layer.borderColor = UIColor.green.cgColor
            frameOfBarcode.layer.borderWidth = 9
            /*Adding the rectangular layer to the end of the subview's list (addSubview property) and then bringing the rectangular layer to the front so to be seen (bringSubviewToFront property).*/
            view.addSubview(frameOfBarcode)
            view.bringSubviewToFront(frameOfBarcode)
        }
    } //End viewDidLoad
    
//---------------------------------------------------------------------------
    
    /*This function is to display general and 'how to recycle' information of an identified scanned product or allow the user to be re-directed to a view to save an unidentified product on the database.
    
     The parameter taken in the function is the barcode's EAN13 digits.*/
    func recycleInfo(decoded_Barcode: String) {
        
        if presentedViewController != nil {
           /*Return from the function if no view of the current viewController we are on is shown.*/
            return
        }
        
        /*Checking if the identified metadata (barcode) is found on the Realm database: .filter("barcode = '\(String(describing: decoded_Barcode))'").*/
        let databaseResults = realm.objects(Product.self).filter("barcode = '\(String(describing: decoded_Barcode))'")
        
        //If a barcode is found on the database (!= 0) then display it.
        if (databaseResults.count != 0)
        {
            //Checking if the database's barcode is not nil (damaged).
            if ((databaseResults[0].barcode) != nil )
            {
                resultFound = true
        
                /*Alert displayed to the user stating the product of that barcode was found on the database.*/
                let viewProduct = UIAlertController(title: "Found: \(databaseResults[0].name!)", message: "View the recycling information of \(databaseResults[0].name!)?", preferredStyle: .actionSheet)
                
                /*Configuring an action (handler) that can be taken when the user taps the button, from the configured alert message displayed.
                The handler property is initialised with a closure. This inline closure has one parameter (action) and a return value of Void.*/
                let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
                    /*If 'Confirm' button is pressed than a segue to another view (UI) is executed to display data relative to the product.*/
                    self.decodedMetadata = decoded_Barcode
                    self.productName = databaseResults[0].name
                    self.productImage = databaseResults[0].image
                    self.productInformation = databaseResults[0].information
                    
                    /*Performing a segue to the UI to display the product's information.*/
                    self.performSegue(withIdentifier: "informationView", sender: self)
                })
        
                /*These two lines of code are used to create a secondary button (cancel) used to cancel the pop-up when the user doesn't want to view the product's data.*/
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
                //Adding the 'confirm' and 'cancel' button functionality.
                viewProduct.addAction(confirmAction)
                viewProduct.addAction(cancelAction)
        
                //Presenting the actionsheet (pop-up alert).
                present(viewProduct, animated: true, completion: nil)
            }
        }
            
        else //No product with the identified barcode is found on the database.
        {
            resultFound = false
            decodedMetadata = decoded_Barcode
            
            /*Ask user whether to add the unidentified product to the database (via a pop-up alert).*/
            let addProduct = UIAlertController(title: "No product found", message: "Add the unidentified product to the database?", preferredStyle: .actionSheet)
             
            let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
                //Perform a segue to the view (UI) to add the product.
                self.performSegue(withIdentifier: "addProductView", sender: self)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
             
            addProduct.addAction(confirmAction)
            addProduct.addAction(cancelAction)
            present(addProduct, animated: true, completion: nil)
        }
    }
    
    /*The prepare() function is called whenever a segue is performed. This function is overridden, to take in values to be the passed to another view (UI).*/
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
        {   /*Passing values to the AddProduct class, of this view, to add unidentified scanned products to the database.*/
            let receiverVC = segue.destination as! AddProduct
            receiverVC.savedBarcode = decodedMetadata //Passing barcode value inputted in the view's text field.
        }
    }
    
} //End of ScannerController class

//MARK: - DECODING BARCODE
//---------------------------------------------------------------------------
/* Title: Barcode and QR code reader built in Swift (QRCodeReader)
Author: simonng, StephenClarkApps and vinceyuan
Date: 2019
Code version: Latest commit 3 Oct. 2019
Availability: https://github.com/appcoda/QRCodeReader.git */


/*Adding a new functionality (extension) to our 'ScannerController' class. The new functionality addition is the metadataOutput() function and the protocol AVCaptureMetadataOutputObjectsDelegate.*/
extension ScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    /*Once the AVCaptureMetadataOutput object recognizes a barcode, the delegate method below (metadataOutput()), of the AVCaptureMetadataOutputObjectsDelegate protocol, will be called allowing further processing of the identified metadata objects, translating it into human readable characters.
    
    The function is called automatically whenever a barcode with appropriate processable metadata (ean13) is identified. The parameter 'metadataObjects' is the identified barcode's metadata .*/
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        /*Checking to see if the metadataObjects array is nil, containing no metadata at all.*/
        if metadataObjects.count == 0 {
            
            /*If the if-statement is true, no rectangle is displayed (CGRect.zero) when either a barcode is not detected or when a barcode does not contain processable metadata (ean13).*/
            frameOfBarcode?.frame = CGRect.zero
            
            //Return from this processing metadata function.
            return
        }
        
        /*The constant 'metadataObj' will have an array object, assigned to it, containing the metadata object that has been read, from a detected barcode. This array object will be casted to an 'AVMetadataMachineReadableCodeObject' class type.*/
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        /*Checking if from the 'supportedCodeTypes' array the current identified metadata of a barcode (metadataObj), matches the EAN13 type.*/
        if (metadataObj.type == AVMetadataObject.ObjectType.ean13) {
        /*If the detected metadata is found, a frame is created on the identified barcode. Otherwise, the size of frameOfBarcode is reset to zero.
        
            The detected barcode metadata (metadataObj) will be saved in the 'transformedMetadataObject(for:)' method of the AVCaptureVideoPreviewLayer class, such that the metadata object’s visual properties are converted to layer coordinates (stored in a constant 'barCodeObject'). From that, the bounds of the barcode are found (barCodeObject!.bounds) so to construct the green box (.frame).*/
            let barCodeObject = previewOfVideo?.transformedMetadataObject(for: metadataObj)
            frameOfBarcode?.frame = barCodeObject!.bounds
        
//---------------------------------------------------------------------------
            /*If the identified barcode has undamaged metadata (!= nil) we call the function 'recycleInfo()' to do some other things.*/
            if metadataObj.stringValue != nil {
                
                /*The called function has an argument of type metadataObj.stringValue, which is of type string (the human translated metadata object identified).*/
                recycleInfo(decoded_Barcode: metadataObj.stringValue!)
            }
            else {
                print("Nothing called BITCH!")
            }
        }
        else
        {
            //If the scanned barcode is not EAN 13 then display an alert to the user.
            let viewAlert = UIAlertController(title: "Not EAN 13", message: "Only EAN 13 (13 digit) barcodes can be scanned. Please scan a valid barcode.", preferredStyle: .alert)
            
            /*Configuring an action that can be taken when the user taps the button, from the configured alert message displayed.*/
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            //Adding the 'OK' button functionality.
            viewAlert.addAction(cancelAction)
            
            //Presenting the alert (pop-up alert).
            present(viewAlert, animated: true, completion: nil)
        }
    } //MARK: - END metadataOutput
} //MARK: - END extension
