//Created  on 2020/7/27 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import Foundation
import RxCocoa
import RxSwift
import RxDataSources

//@IBDesignable
/// TableViewController 组装基类，Form 协议 下的普通 MVVM 模式
/// 继承自FormViewController，StackView内包含一个 TableView
open class FormRxTableViewController: FormViewController {
    open var delegateData: FormRxTableViewDelegateDataSource?
    open var forms: BehaviorRelay<[FormRx]>?
    
    open lazy var tableView: UITableView = {
        return UITableView(frame: CGRect.zero, style: style)
    }()
    open var style:UITableView.Style = .grouped
    public let disposeBag = DisposeBag()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
    }
}

extension FormRxTableViewController {
    @objc open func makeTableView() {
        stackView.addArrangedSubview(tableView)
        guard let forms = forms else {
            assertionFailure("👉👉👉 - forms 未初始化,可重写 makeTableView 初始化在此之前  👻")
            return
        }
        delegateData = FormRxTableViewDelegateDataSource(forms: forms, tableView: tableView)
    }
}


//@IBDesignable
/// CollectionViewController 组装基类，Form 协议 下的普通 MVVM 模式
/// 继承自FormViewController，StackView内包含一个 CollectionView
open class FormRxCollectionViewController: FormViewController {
    open var delegateData: FormRxCollectionViewDelegateDataSource?
    open var forms: BehaviorRelay<[FormRx]>?
    
    open lazy var flowLayout: UICollectionViewLayout = {
        return UICollectionViewFlowLayout()
    }()
    
    open lazy var collectionView: UICollectionView = {
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }()
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        makeCollectionView()
    }
}

extension FormRxCollectionViewController {
    @objc open func makeCollectionView() {
        stackView.addArrangedSubview(collectionView)
        forms = nil
        guard let forms = forms else {
            assertionFailure("👉👉👉 - forms 未初始化,可重写 makeCollectionView 初始化在此之前  👻")
            return
        }
        delegateData = FormRxCollectionViewDelegateDataSource(forms: forms, collectionView: collectionView)
    }
}
