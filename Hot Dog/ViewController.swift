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
    
    @IBOutlet weak var hotdogIcon: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var ImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        //show camera as soon as the app launches
        present(imagePicker, animated: true, completion: nil)
        
        labelView.isHidden = true
        hotdogIcon.isHidden = true
        //make hotdogIcon circled
        hotdogIcon.layer.cornerRadius = hotdogIcon.frame.size.height/2
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            ImageView.image = pickedImage
            guard let ciImage = CIImage(image: pickedImage) else{
                fatalError("Taken image can't be converted to CIImage")
            }
            detect(image: ciImage)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect (image : CIImage){
        // loading Inceptionv3 model
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Couldn't load CoreML model")
        }
        //process the takken image
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model couldn't process Image")
            }
            //after processing image show the label and the hot dog icon
            self.labelView.isHidden = false
            self.hotdogIcon.isHidden = false
            
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.labelView.text = "Hotodg!"
                    self.labelView.backgroundColor = #colorLiteral(red: 0.2658653855, green: 0.7634820342, blue: 0.2576112449, alpha: 1)
                    self.hotdogIcon.image = #imageLiteral(resourceName: "HotDog")
                }else {
                    self.labelView.text = "Not Hotodg!"
                    self.labelView.backgroundColor = #colorLiteral(red: 0.9785731435, green: 0.06647058576, blue: 0, alpha: 1)
                    self.hotdogIcon.image = #imageLiteral(resourceName: "NotHotDog")
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
        
    }
    
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        //show camera
        present(imagePicker, animated: true, completion: nil)
    }
   
}

