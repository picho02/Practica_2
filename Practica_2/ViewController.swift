//
//  ViewController.swift
//  Practica_2
//
//  Created by Erendira Cruz Reyes on 28/05/22.
//

import UIKit


class ViewController: UIViewController {
    var peticion = ""

    @IBAction func Pdf(_ sender: Any) {
        peticion = "Articles.pdf"
        self.performSegue(withIdentifier: "presentar", sender: nil)
    }
    @IBAction func excel(_ sender: Any) {
        peticion = "localidades.xlsx"
        self.performSegue(withIdentifier: "presentar", sender: nil)
    }
    @IBAction func Imagen(_ sender: Any) {
        peticion = "geo_vertical.jpg"
        self.performSegue(withIdentifier: "presentar", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentar"{
            let vc = segue.destination as! PresentarViewController
            vc.peticion = peticion
            
        }
    }

}

