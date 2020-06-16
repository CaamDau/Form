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
    var forms: [[CellProtocol]] = []
    
}

extension VM_ViewController {
    func makeForm() {
        do{
            let row = RowCell<RowTableViewCellBase>(frame: CGRect(h:80))
        }
    }
}


extension VM_ViewController: FormProtocol {
    var _forms: [[CellProtocol]] {
        return forms
    }
}


