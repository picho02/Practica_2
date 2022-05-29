//
//  PresentarViewController.swift
//  Practica_2
//
//  Created by Erendira Cruz Reyes on 28/05/22.
//

import UIKit
import WebKit
import Network
class PresentarViewController: UIViewController {
    var peticion = ""
    var internetStatus = false
    var internetType = ""
    var a_i = UIActivityIndicatorView()
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(peticion)
        a_i.style = .large
        a_i.color = .red
        a_i.hidesWhenStopped = true
        a_i.center = self.view.center
        self.view.addSubview(a_i)
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {
            path in
            if path.status != .satisfied{
                self.internetStatus = false
            }else{
                self.internetStatus = true
                if path.usesInterfaceType(.wifi){
                    self.internetType = "wifi"
                }
                else if path.usesInterfaceType(.cellular){
                    self.internetType = "Cellular"
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    override func viewDidAppear(_ animated: Bool) {
        if (cargaLocal(peticion)){
            print("texto cargado desde local")
        }else{
            if internetStatus{
            if let url = URL(string: "http://janzelaznog.com/DDAM/iOS/vim/\(peticion)") {
                let request = URLRequest(url: url)
                let sesion = URLSession.shared
                let tarea = sesion.dataTask(with: request) { bytes, response, error in
                    if error != nil {
                        print ("ocurrio un error \(error!.localizedDescription)")
                    }
                    else {
                        let image = UIImage(data: bytes!)
                        self.guardaLocal(bytes!, self.peticion)
                        DispatchQueue.main.async {
                            self.webView.load(request)
                            self.a_i.stopAnimating()
                        }
                    }
                }
                a_i.startAnimating()
                tarea.resume()
            }else{let alert = UIAlertController(title: "Error", message: "No hay internet", preferredStyle: .alert)
                let boton = UIAlertAction(title: "ok", style: .default)
                alert.addAction(boton)
                self.present(alert,animated: true)
                
            }
            }
            
        }

    }
    

    func cargaLocal(_ nombre: String)-> Bool{
        let urlAdocs = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        if (FileManager.default.fileExists(atPath: urlAlArchivo.path))
        {
            
                    let urlRequest = URLRequest(url: urlAlArchivo)
                    webView.load(urlRequest)
            return true
            
        }else {
            return false
        }
    }
    func guardaLocal(_ bytes:Data,_ nombre:String){
        let urlAdocs = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let urlAlArchivo = urlAdocs.appendingPathComponent(nombre)
        do{
            try bytes.write(to: urlAlArchivo)
        }catch{
            print("no se pudo salvar")
        }
    }
}
