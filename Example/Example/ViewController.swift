//Created  on 2019/3/12 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */



import Foundation
import UIKit
import CaamDauForm


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cd.background(.red).estimatedAll()
    }
}


class VM_ViewController {
    var forms: [[CD_CellProtocol]] = []
    
}

extension VM_ViewController {
    func makeForm() {
        do{
            let row = CD_RowCell<CD_TableViewCellBase>(frame: CGRect(h:80))
        }
    }
}


extension VM_ViewController: CD_FormProtocol {
    var _forms: [[CD_CellProtocol]] {
        return forms
    }
}


