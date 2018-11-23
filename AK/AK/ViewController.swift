//
//  ViewController.swift
//  AK
//
//  Created by SHANI SHAH on 22/11/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(AK.appDisplayName)
        nameLabel.text = "welcome".localized()
        showButton.setTitle("login".localized(), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    }
    @objc func setText() {
        nameLabel.text = "welcome".localized()
        showButton.setTitle("login".localized(), for: .normal)
    }

    @IBAction func showSecondScreen(_ sender: UIButton){
        let controller = storyboard?.instantiateViewController(withIdentifier: "SeondController") as! SeondController
        navigationController?.pushViewController(controller, animated: true)
    }
}


class SeondController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var showButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(AK.appDisplayName)
        nameLabel.text = "welcome".localized()
        showButton.setTitle("login".localized(), for: .normal)
    }
    
}


