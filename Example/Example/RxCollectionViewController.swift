//Created  on 2020/7/27 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import UIKit

class RxCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var vm = VM_RxCollectionViewController()
    let disposeBag = DisposeBag()
    var deleDa:FormRxCollectionViewDelegateDataSource?
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleDa = FormRxCollectionViewDelegateDataSource(forms: vm.forms, collectionView: collectionView)
        
        Time.after(3) {
            self.vm.input(.refresh(true))
        }
    }
}


class VM_RxCollectionViewController {
    var forms = BehaviorRelay<[FormRx]>(value: (0..<Section.end.rawValue).map{ _ in FormRx(items: []) })
    var output: ((OutputType) -> Void)?
    enum Section:Int {
        case one = 0
        case two
        case end
    }
    
}

extension VM_RxCollectionViewController {
    func makeForm() {
        
        do{
            let rows = (0..<50).map {
                RowCell<Item_Title>(data: "title-\($0)", frame: CGRect(x:5, y:10, w:80, h: 45), insets: UIEdgeInsets(t: 5, l: 5, b: 5, r: 5)) {
                    print_cd("点击了")
                }
            }
            forms.accept([FormRx(header:nil, footer: nil, items: rows)])
        }
    }
}

extension VM_RxCollectionViewController {
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

extension VM_RxCollectionViewController: FormViewModelProtocol {
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






class Item_Title: UICollectionViewCell {
    
    @IBOutlet weak var lab_title: UILabel!
}
extension Item_Title: RowCellUpdateProtocol {
    typealias DataSource = String
    
    typealias ConfigModel = Any
    
    func row_update(dataSource data: String) {
        lab_title.cd.text(data)
    }
}
