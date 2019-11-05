//
//  AlunosViewController.swift
//  AppIOS
//
//  Created by FBM on 16/10/19.
//  Copyright © 2019 pos. All rights reserved.
//

import CoreData
import UIKit

class AlunosViewController : UITableViewController {
    
    @IBOutlet weak var alunosTableView: UITableView!
    
    var alunos = [Aluno]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        carregarAlunos()
    }
    
    func carregarAlunos() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchAlunos = NSFetchRequest<NSFetchRequestResult>(entityName: "Aluno")
        fetchAlunos.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        do {
            let result = try managedContext.fetch(fetchAlunos)
            alunos = result as! [Aluno]
        } catch {
            print("Failed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        carregarAlunos()
        alunosTableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alunos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celulaReuso", for: indexPath)
        let curso = alunos[indexPath.row]
        cell.textLabel?.text = curso.nome
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let aluno = alunos[indexPath.row]
        let alerta = UIAlertController(title: aluno.nome, message: aluno.dataNascimento.description, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alerta.addAction(ok)
        present(alerta, animated: true, completion: nil)
    }
    
}
