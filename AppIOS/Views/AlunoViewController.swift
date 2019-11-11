//
//  AlunoViewController.swift
//  AppIOS
//
//  Created by FBM on 05/11/19.
//  Copyright © 2019 pos. All rights reserved.
//

import CoreData
import UIKit

class AlunoViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var nome: UITextField!
    @IBOutlet weak var dataNascimento: UIDatePicker!
    @IBOutlet weak var cursoPicker: UIPickerView!
    @IBOutlet weak var foto: UIImageView!
    var cursos = [Curso]()
    var curso: Curso!
    var imagePicker: ImagePicker!
    var aluno: Aluno!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carregarCursos()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.cursoPicker.delegate = self
        self.cursoPicker.dataSource = self
        
        if(aluno != nil) {
            nome.text = aluno.nome
            let indice = cursos.firstIndex(of: aluno.curso) ?? 0
            cursoPicker.selectRow(indice, inComponent: 0, animated: true)
            dataNascimento.date = aluno.dataNascimento as Date
            foto.image = UIImage(data: aluno.foto as Data)
        }
    }
    
    @IBAction func salvar(_ sender: Any) {
        if (nome.text!.isEmpty || foto.image == nil){
            let alert = UIAlertController(title: "Alerta", message: "Preencha todos os campos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let entity = NSEntityDescription.entity(forEntityName: "Aluno", in:  appDelegate.persistentContainer.viewContext)!
            if(aluno == nil){
                aluno = Aluno(entity: entity, insertInto: appDelegate.persistentContainer.viewContext)
            }
            aluno.nome = nome.text!
            aluno.curso = cursos[cursoPicker.selectedRow(inComponent: 0)]
            aluno.dataNascimento = dataNascimento.date as NSDate
            aluno.foto = foto.image!.pngData()! as NSData
            appDelegate.saveContext()
            let alert = UIAlertController(title: "Alerta", message: "Aluno salvo com sucesso", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in self.concluir()}))
            self.present(alert, animated: true)
        }
        
    }
    
    func concluir(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selecionarFoto(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cursos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cursos[row].nome
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        curso = cursos[row]
    }

}

extension AlunoViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.foto.image = image
    }
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
