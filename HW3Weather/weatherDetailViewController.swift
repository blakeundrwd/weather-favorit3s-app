//
//  weatherDetailViewController.swift
//  Test
//
//  Created by School on 3/3/21.
//

import UIKit

class weatherDetailViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherCond: UILabel!
    @IBOutlet weak var tempValue: UILabel!
    
    var city: String = ""
    var weath: String = ""
    var pic: UIImage? = nil
    var temp: Float!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        cityName.text = city
        tempValue.text = String(temp) + "°F"
        weatherCond.text = weath
        weatherImage.image = pic
    }
    
    func assignbackground(){
            let background = UIImage(named: "happydays.jpg")
            var imageView : UIImageView!
            imageView = UIImageView(frame: view.bounds)
            imageView.contentMode =  UIView.ContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = background
            imageView.center = view.center
            view.addSubview(imageView)
            self.view.sendSubviewToBack(imageView)
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
