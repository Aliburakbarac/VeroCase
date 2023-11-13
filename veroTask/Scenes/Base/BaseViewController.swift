//
//  BaseViewController.swift
//  veroTask
//
//  Created by Ali Burak Baraç on 13.11.2023.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray.withAlphaComponent(1)
        navigationController?.navigationBar.backgroundColor = .darkGray.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
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
