//
//  CursosViewController.swift
//  AppIOS
//
//  Created by FBM on 16/10/19.
//  Copyright © 2019 pos. All rights reserved.
//

import UIKit
import CoreData

class CursosViewController : UITableViewController {
    
    @IBOutlet var cursosTableView: UITableView!
    var cursos = [Curso]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "Cursos"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Novo", style: .plain, target: self, action: #selector(novo))
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchCursos = NSFetchRequest<NSFetchRequestResult>(entityName: "Curso")
        fetchCursos.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        do {
            let result = try managedContext.fetch(fetchCursos)
            cursos = result as! [Curso]
        } catch {
            print("Failed")
        }
        
    }
    
    @IBAction func novo(){
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cursos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        let curso = cursos[indexPath.row]
        cell.textLabel?.text = curso.nome
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let curso = cursos[indexPath.row]
        let alerta = UIAlertController(title: curso.nome, message: curso.ementa, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alerta.addAction(ok)
        present(alerta, animated: true, completion: nil)
    }
}
