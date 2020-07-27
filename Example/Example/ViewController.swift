//Created  on 2019/3/12 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */



import Foundation
import UIKit
import CaamDauForm


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var vm = VM_ViewController()
    var dea:FormXTableViewDelegateDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("交换 = viewDidLoad")
        tableView.cd.background(.red).estimatedAll()
        
        dea = FormXTableViewDelegateDataSource(vm.fff)
        tableView.cd.delegate(dea).dataSource(dea)
//        dea?.makeReloadData(tableView)
        
//        vm.makeForm()
        
        TTS().tts()
    }
}



class VM_ViewController {
    var fff:[FormXDataSource] = []
    init() {
        makeForm()
    }
    
    var forms: [[CellProtocol]] = []
    var reloadData: (() -> Void)?
}

extension VM_ViewController {
    func makeForm() {
        
        (0..<100).forEach {
           let data = RowTableViewCellBase.Model(title: "title-\($0)")
            let row = RowCell<RowTableViewCellBase>(data: data, frame: CGRect(h:50))
            fff.append(FormX(header: nil, footer: nil, rows: [row]))
        }
        
        
        
        
        /*
        var ff:[CellProtocol] = []
        (0..<100).forEach {
           let data = RowTableViewCellBase.Model(title: "title-\($0)")
            let row = RowCell<RowTableViewCellBase>(data: data, frame: CGRect(h:50))
            ff += [row]
        }
        
        forms = [ff]
        reloadData?()*/
    }
}


extension VM_ViewController: FormProtocol {
    var _forms: [[CellProtocol]] {
        return forms
    }
    var _reloadData: (() -> Void)? {
        set{
            reloadData = newValue
        }
        get{
            return reloadData
        }
    }
}


class TTS {
    dynamic func tts() {
        print("交换 = tts")
    }
}
extension TTS {
    @_dynamicReplacement(for: tts()) func s_tts() {
        print("交换 = s_tts")
        
        tts()
    }
}

extension TTS {
    @_dynamicReplacement(for: tts()) func ss_tts() {
        print("交换 = ss_tts")
        
        tts()
    }
}

extension UIViewController {
    
    @_dynamicReplacement(for: viewDidLoad())
    func s_viewDidLoad() {
        
        print("交换 = s_viewDidLoad")
        viewDidLoad()
    }
}
