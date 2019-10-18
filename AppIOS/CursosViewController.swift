//
//  CursosViewController.swift
//  AppIOS
//
//  Created by FBM on 16/10/19.
//  Copyright © 2019 pos. All rights reserved.
//

import UIKit
import CoreData

class CursosViewController : UIViewController {
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var ementaTextField: UITextField!
    @IBOutlet weak var inicioDatePicker: UIDatePicker!
    @IBOutlet weak var fimDatePicker: UIDatePicker!
    @IBOutlet weak var cursosTableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    var cursos = [Curso]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        title = "Cursos"
        
       
    }
    
    @IBAction func salvar(_ sender: Any) {
        
        
    }
}
