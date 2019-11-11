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
    var alunoSelecionado: Aluno!
    
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
    
    func remover(aluno: Aluno) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            managedContext.delete(aluno)
            try managedContext.save()
            self.carregarAlunos()
            self.alunosTableView.reloadData()
            let alert = UIAlertController(title: "Alerta", message: "Aluno removido com sucesso", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
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
        alunoSelecionado = alunos[indexPath.row]
        self.performSegue(withIdentifier: "editar", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let aluno = alunos[indexPath.row]
            remover(aluno: aluno)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editar") {
            let viewController = segue.destination as! AlunoViewController
            viewController.aluno = self.alunoSelecionado
        }
    }
    
}
