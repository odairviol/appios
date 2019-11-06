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
    var cursoSelecionado: Curso!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        carregarCursos()
    }
    
    func carregarCursos() {
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
    
    func removerCurso(curso: Curso) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            managedContext.delete(curso)
            try managedContext.save()
            self.carregarCursos()
            self.cursosTableView.reloadData()
            let alert = UIAlertController(title: "Alerta", message: "Curso removido com sucesso", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } catch {
            print("Failed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        carregarCursos()
        self.cursosTableView.reloadData()
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
        cursoSelecionado = cursos[indexPath.row]
        self.performSegue(withIdentifier: "editar", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let curso = cursos[indexPath.row]
            removerCurso(curso: curso)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editar") {
            let cursoViewController = segue.destination as! CursoViewController
            cursoViewController.curso = self.cursoSelecionado
        }
    }
}
