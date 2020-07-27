//Created  on 2020/7/27 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import Foundation
import RxCocoa
import RxSwift
import RxDataSources

open class FormRxTableViewDelegateDataSource: NSObject {
    public let dataSource = RxTableViewSectionedReloadDataSource<FormRx>(
        configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let row = item
            let cell = tableView.cd.cell(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") ?? UITableViewCell()
            row.bind(cell)
            return cell
            
    })
    let disposeBag = DisposeBag()
    
    public init(forms:BehaviorRelay<[FormRx]>, tableView:UITableView) {
        super.init()
        forms
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(FormRx.Item.self)
            .subscribe(onNext: { item in
                item.tapBlock?()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension FormRxTableViewDelegateDataSource: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].header?.h ?? 0.001
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource[section].footer?.h ?? 0.001
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource[indexPath.section].items[indexPath.row].h
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let row = dataSource[section].header else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let row = dataSource[section].header else {
            return nil
        }
        guard let v = tableView.cd.view(row.cellClass, id:row.cellId, bundleFrom:row.bundleFrom ?? "") else {
            return nil
        }
        row.bind(v)
        return v
    }
}


open class FormRxCollectionViewDelegateDataSource: NSObject {
    public let dataSource = RxCollectionViewSectionedReloadDataSource<FormRx>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
        let row = item
        let cell = collectionView.cd.cell(row.cellId, indexPath)
        row.bind(cell)
        return cell
    }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
        switch kind {
        case CaamDau<UICollectionView>.Kind.tHeader.stringValue:
            guard let row = dataSource[indexPath.section].header else {
                return collectionView.cd.view(RowCollectionReusableViewNone.id, kind, indexPath)
            }
            let v = collectionView.cd.view(row.cellId, kind, indexPath)
            row.bind(v)
            return v
        default:
            guard let row = dataSource[indexPath.section].footer else {
                return collectionView.cd.view(RowCollectionReusableViewNone.id, kind, indexPath)
            }
            let v = collectionView.cd.view(row.cellId, kind, indexPath)
            row.bind(v)
            return v
        }
    })
    
    let disposeBag = DisposeBag()
    
    public init(forms:BehaviorRelay<[FormRx]>, collectionView:UICollectionView) {
        super.init()
        forms
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(FormRx.Item.self)
            .subscribe(onNext: { item in
                item.tapBlock?()
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension FormRxCollectionViewDelegateDataSource: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dataSource[indexPath.section].items[indexPath.row].size
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return dataSource[section].footer?.size ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return dataSource[section].header?.size ?? .zero
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let header = dataSource[section].header {
            return header.insets
        }
        else if let footer = dataSource[section].footer {
            return footer.insets
        }
        else{
            return dataSource[section].items.first?.insets ?? .zero
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let header = dataSource[section].header  {
            return header.y
        }else{
            return dataSource[section].items.first?.x ?? 0
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let header = dataSource[section].header  {
            return header.x
        }else{
            return dataSource[section].items.first?.x ?? 0
        }
    }
}
