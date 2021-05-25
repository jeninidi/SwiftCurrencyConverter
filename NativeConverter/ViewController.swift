//
//  ViewController.swift
//  NativeConverter
//
//  Created by Botond Ferencz on 23/05/2021.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //get all names of currency and push to array
    var myCurrency:[String] = []
    
    //get all ratio values for currency
    var myValues:[Double] = []
    
    //empty variable for selected currency
    var activeCurrency:Double = 0;

    //Objects
    
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var output: UILabel!
    
    //create picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = myValues[row]
    }
    
    //button
    
    @IBAction func action(_ sender: Any) {
        if(input.text != "") {
        output.text = String(Double(input.text!)! * activeCurrency)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get data from API
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=475ee19fa2b8d317e623c33843c7b1c2&format=1")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil
            {
                print("ERROR")
            }
            else{
                if let content = data {
                    do {
                        //serialise JSON data from API
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        //put ratio into a dictionary
                        if let rates = myJson["rates"] as? NSDictionary{
                            print(rates)
                            
                            for (key, value) in rates {
                                //push name of currency to array
                                self.myCurrency.append((key as? String)!)
                                //push ratio of currency to array
                                self.myValues.append((value as? Double)!)
                            }
                            
                            print(self.myCurrency)
                            print(self.myValues)
                        }
                        
                        print(myJson)
                    }
                    catch{
                        
                    }
                }
            }
            
            self.pickerView.reloadAllComponents()
        }
        
        task.resume()
        
    }


}

