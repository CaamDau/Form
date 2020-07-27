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
        tableView.cd.estimatedAll()
        
        dea = FormXTableViewDelegateDataSource(nil)
        tableView.cd.delegate(dea).dataSource(dea)
        
        vm.output = { [weak self]put in
            switch put {
            case .reload:
                self?.dea?.form = self!.vm.fff
                self?.tableView.reloadData()
            default:
                break
            }
        }
        
        Time.after(3) {
            self.vm.input(.refresh(true))
        }
        
        
        
        //TTS().tts()
    }
}



class VM_ViewController {
    var fff:[FormX] = []
    init() {
        
    }
    var output: ((OutputType) -> Void)?
    
    //var forms: [[CellProtocol]] = []
    //var reloadData: (() -> Void)?
}

extension VM_ViewController {
    func makeForm() {
        do{
            let rows = (0..<3).map {
                RowCell<RowTableViewCellBase>(data: RowTableViewCellBase.Model(title: "title-\($0)"), frame: CGRect(h:50))
            }
            fff.append(FormX(header: nil, footer: nil, rows: rows))
        }
        
        do{ // 随机混排
            let header = RowCell<Header_Rx>(data: "组头2", config: .red, frame: CGRect(h:40))
            let footer:CellProtocol = RowCell<Header_Rx>(data: "组尾2", config: .gray, frame: CGRect(h:30))
            let rows = (0..<100).map { (i) -> CellProtocol in
                switch Int(arc4random() % 2) {
                case 0:
                    return RowCell<RowTableViewCellBase>(data: RowTableViewCellBase.Model(title: "title-\(i)"), frame: CGRect(h:50))
                default:
                    return RowCell<Cell_Image>(data: ("title-\(i)", "2020.1.\(i)"), frame: CGRect(h:CGFloat(60)))
                }
            }
            fff.append(FormX(header: header, footer: footer, rows: rows))
        }
        
        do{
            let rows = (10..<13).map {
                RowCell<RowTableViewCellBase>(data: RowTableViewCellBase.Model(title: "title-\($0)"), frame: CGRect(h:50))
            }
            fff[0] = fff[0].append(rows: rows)
        }
        output?(.reload)
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
extension VM_ViewController {
    enum InputType {
        case refresh(Bool)
    }
    
    enum OutputType {
        case reload
        case endRefresh
        case endRefreshNodata
        case resetNoMoreData
    }
}

extension VM_ViewController: FormViewModelProtocol {
    func input(_ input: InputType) {
        switch input {
        case .refresh(_):
            makeForm()
        default:
            break
        }
    }
    
    typealias Input = InputType
    
    typealias Output = OutputType
}


/*
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
*/









































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
