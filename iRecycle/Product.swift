//
//  Product.swift
//  iRecycle
//
//  Created by Luca Santarelli on 24/01/2020.
//  Copyright © 2020 Luca Santarelli. All rights reserved.
//

/* Class with the properties to where to save the product's data, when needing to save it on the Realm database.*/

import Foundation
import RealmSwift //Library imported to use the Realm database.

//Creates the objects for the Realm database.
class Product: Object {
    //Properties (fields) of our Realm database.
    @objc dynamic var name: String? //Product's name
    @objc dynamic var barcode: String? //Product's barcode.
    @objc dynamic var image: String? //Product's image URL.
    @objc dynamic var information: String? //Product's recycling information.
}
