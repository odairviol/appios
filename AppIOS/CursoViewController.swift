//
//  CursoViewController.swift
//  AppIOS
//
//  Created by FBM on 24/10/19.
//  Copyright © 2019 pos. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CursoViewController : UIViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        title = "Cadastrar Curso"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar", style: .plain, target: self, action: #selector(salvar))
        
    }
    
    @IBAction func salvar() {
        
        
    }
    
}
