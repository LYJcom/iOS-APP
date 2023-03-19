//
//  AddViewController.swift
//  Album
//
//  Created by apple on 2023/1/27.
//

import UIKit
import Vision

class AddViewController: UIViewController {

    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var photoButton: UIButton!
    var image: UIImage = UIImage()
    
    var resultLabel: UILabel = UILabel()
    var resultSort: String = ""
    
    //TODO: define a VNCoreMLRequest
    lazy var classificationRequest: VNCoreMLRequest = {
        do{
            // Task1: Snack
            // Task2: HealthySnack
            let snacks = Snack()
            let visionModel = try VNCoreMLModel(for: snacks.model)

            let request = VNCoreMLRequest(model: visionModel, completionHandler: {
                [weak self] request,error in
                self?.processObservations(for: request, error: error)
            })

            request.imageCropAndScaleOption = .centerCrop
            return request
              
        } catch {
            fatalError("Failed to create VNCoreMLModel: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.layer.cornerRadius = 10
        photoButton.layer.cornerRadius = 10

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func takePicture() {
        presentPhotoPicker(sourceType: .camera)
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddToImageView"{
            let ImageView = segue.destination as! ImageViewController
            ImageView.image = self.image
            ImageView.result = self.resultLabel
            print(self.resultLabel.text)
        }
        AlbumCollectionViewController.allImages.append(self.image)
        
        if AlbumCollectionViewController.classifyImages[self.resultSort] != nil {
            AlbumCollectionViewController.classifyImages[self.resultSort]!.append(self.image)
        } else {
            var Images = [UIImage]()
            Images.append(self.image)
            AlbumCollectionViewController.classifyImages[self.resultSort] = Images
        }
                
        
        print(AlbumCollectionViewController.allImages.count)
        print(AlbumCollectionViewController.classifyImages[self.resultSort]!.count)
    }
    
    func classify(image: UIImage) {
        //TODO: use VNImageRequestHandler to perform a classification request
        guard let ciImage = CIImage(image: image) else {
            print("Unable to create CIImage")
            return
        }
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let hander = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try hander.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification: \(error)")
            }
        }
        //self.performSegue(withIdentifier: "AddToImageView", sender: self)
    }
      
      //TODO: define a function like func processObservations(for request: VNRequest, error: Error?)  to process the results from the classification model
    func processObservations(for request: VNRequest, error: Error?) {
          DispatchQueue.main.async {
              if let results = request.results as? [VNClassificationObservation] {
                  if results.isEmpty {
                      self.resultLabel.text = "nothing found"
                  } else if results[0].confidence < 0.8 {
                      self.resultLabel.text = "not sure"
                      self.resultSort = "not sure"
                  } else {
                      self.resultLabel.text = String(format: "%@ %.1f%%", results[0].identifier, results[0].confidence * 100)
                      self.resultSort = results[0].identifier
                  }
              } else if let error = error {
                  self.resultLabel.text = "Error: \(error.localizedDescription)"
              } else {
                  self.resultLabel.text = "???"
              }
              print(self.resultLabel.text!)
              self.performSegue(withIdentifier: "AddToImageView", sender: self)
          }
      }


}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true)
      
      self.image = info[.originalImage] as! UIImage
      classify(image: self.image)
      
  }
}
