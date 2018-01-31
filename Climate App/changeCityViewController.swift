//
//  changeCityViewController.swift
//  Climate App
//
//  Created by Mohamed on 1/17/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit


//protocol declaration
protocol ChangeCityDelegate {
    func userEnterAnewCityName(city: String)
}

class changeCityViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    
    //declar variables
    var deledate: ChangeCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    
    @IBAction func changeCityTextField(_ sender: Any) {
        
        
    }
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        
        let cityName = cityNameTextField.text!  // we took data from textfield once the button pressed
        
        deledate?.userEnterAnewCityName(city: cityName)  // we create data here in delegate
        
        self.dismiss(animated: true, completion: nil)  // dismiss current view
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true , completion: nil)
    }
    
    
    
    
    

}
