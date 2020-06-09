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
    @IBOutlet weak var hotdogIconImageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        labelView.isHidden = true
        hotdogIconImageView.isHidden = true
        hotdogIconImageView.layer.cornerRadius = hotdogIconImageView.frame.size.height/2
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
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Couldn't load CoreML model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model couldn't process Image")
            }
            self.labelView.isHidden = false
            self.hotdogIconImageView.isHidden = false
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.labelView.text = "Hotodg!"
                    self.hotdogIconImageView.image = #imageLiteral(resourceName: "HotDog")                }else {
                    self.labelView.text = "Not Hotodg!"
                    self.hotdogIconImageView.image = #imageLiteral(resourceName: "NotHotDog")
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
        present(imagePicker, animated: true, completion: nil)
    }
    
}

