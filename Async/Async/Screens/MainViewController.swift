//
//  MainViewController.swift
//  Async
//
//  Created by Tarun Verma on 24/12/2020.
//

import UIKit
import TinyConstraints

class MainViewController: UIViewController {

    let mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(mainView)
        mainView.edgesToSuperview()
        // Do any additional setup after loading the view.
    }

}
