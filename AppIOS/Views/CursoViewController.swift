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
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var ementaTextField: UITextField!
    @IBOutlet weak var inicioDatePicker: UIDatePicker!
    @IBOutlet weak var terminoDatePicker: UIDatePicker!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Cadastrar Curso"
    }
    
    @IBAction func salvar() {
        if (nomeTextField.text!.isEmpty || ementaTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Alerta", message: "Preencha todos os campos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let entity = NSEntityDescription.entity(forEntityName: "Curso", in:  appDelegate.persistentContainer.viewContext)!
            let curso = Curso(entity: entity, insertInto: appDelegate.persistentContainer.viewContext)
            curso.ementa = ementaTextField.text!
            curso.fim = terminoDatePicker.date as NSDate
            curso.inicio = inicioDatePicker.date as NSDate
            curso.nome = nomeTextField.text!
            appDelegate.saveContext()
            let alert = UIAlertController(title: "Alerta", message: "Curso inserido com sucesso", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.concluir()}))
            self.present(alert, animated: true)
        }
        
    }
    
    func concluir(){
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
