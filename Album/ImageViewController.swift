//
//  ImageViewController.swift
//  Album
//
//  Created by apple on 2023/1/27.
//

import UIKit

class ImageViewController: UIViewController {

    var result: UILabel = UILabel()
    @IBOutlet weak var resultLabel: UILabel!
    var image: UIImage = UIImage()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
        resultLabel.text = result.text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
