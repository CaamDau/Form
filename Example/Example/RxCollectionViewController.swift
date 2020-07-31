//Created  on 2020/7/27 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import UIKit

class RxCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var vm = VM_RxCollectionViewController()
    var proxy:FormRxCollectionViewDelegateDataSource?
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proxy = FormRxCollectionViewDelegateDataSource(forms: vm.forms, collectionView: collectionView)
        
        self.vm.output = { [weak self]put in
            switch put {
            case .register(let items):
                self?.collectionView.cd.register(items)
            default:
                break
            }
        }
        
        Time.after(2) {
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
            let header = RowCell<CollectionReusableViewHeader>(data: "组头", config: .red, frame: CGRect(x:1, y:1, h: 45), insets: UIEdgeInsets(t: 1, l: 1, b: 1, r: 1))
            let footer = RowCell<CollectionReusableViewHeader>(data: "组尾", frame: CGRect(h: 45))
            // 发送 CollectionView注册元素指令
            output?(.register([
                .tView(CollectionReusableViewHeader.self, nil, .tHeader, nil),
                .tView(CollectionReusableViewHeader.self, nil, .tFooter, nil)
            ]))
            
            let w = (CD.screenW-6)/4
            let rows = (0..<12).map {
                RowCell<Item_Title>(data: "title-\($0)", frame: CGRect(w:w, h: 60)) {
                    print_cd("点击了")
                }
            }
            forms.accept([FormRx(items: rows, header:header, footer: footer)])
        }
        
        do{
            let rows = (110..<150).map {
                RowCell<Item_Title>(data: "title-\($0)", frame: CGRect(x:15, y:15, w:100, h: 45), insets: UIEdgeInsets(t: 15, l: 15, b: 15, r: 15))
            }
            forms.accept(forms.value + [FormRx(items: rows, header:nil, footer: nil)])
        }
    }
}

extension VM_RxCollectionViewController {
    enum InputType {
        case refresh(Bool)
    }
    
    enum OutputType {
        case endRefresh
        case endRefreshNodata
        case resetNoMoreData
        case register([CaamDau<UICollectionView>.View])
    }
}

extension VM_RxCollectionViewController: ViewModelProtocol {
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
