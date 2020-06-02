//
//  ViewController.swift
//  Hot Dog
//
//  Created by Esraa Gamal on 6/2/20.
//  Copyright © 2020 Esraa. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var ImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        ImageView.image = pickedImage
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

