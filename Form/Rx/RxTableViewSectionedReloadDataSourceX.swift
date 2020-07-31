//Created  on 2020/7/29 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 * 代码来源于：Pircate：https://github.com/Pircate/RxSwiftX
 */

import RxSwift
import RxCocoa
import RxDataSources

open class RxTableViewSectionedReloadDataSourceX<Section: SectionModelType>: RxTableViewSectionedReloadDataSource<Section>, UITableViewDelegate {
    
    public typealias HeightForRowAtIndexPath = (RxTableViewSectionedReloadDataSourceX<Section>, UITableView, IndexPath, Item) -> CGFloat
    public typealias HeightForHeaderInSection = (RxTableViewSectionedReloadDataSourceX<Section>, UITableView, Int) -> CGFloat
    public typealias HeightForFooterInSection = (RxTableViewSectionedReloadDataSourceX<Section>, UITableView, Int) -> CGFloat
    public typealias ViewForHeaderInSection = (RxTableViewSectionedReloadDataSourceX<Section>, UITableView, Int) -> UIView?
    public typealias ViewForFooterInSection = (RxTableViewSectionedReloadDataSourceX<Section>, UITableView, Int) -> UIView?
    
    open var heightForRowAtIndexPath: HeightForRowAtIndexPath
    open var heightForHeaderInSection: HeightForHeaderInSection
    open var heightForFooterInSection: HeightForFooterInSection
    open var viewForHeaderInSection: ViewForHeaderInSection
    open var viewForFooterInSection: ViewForFooterInSection
    
    public init(configureCell: @escaping ConfigureCell,
                titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
                sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
                sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index },
                heightForRowAtIndexPath: @escaping HeightForRowAtIndexPath = { _, tableView, _, _ in tableView.rowHeight },
                heightForHeaderInSection: @escaping HeightForHeaderInSection = { _, tableView, _  in tableView.sectionHeaderHeight },
                heightForFooterInSection: @escaping HeightForFooterInSection = { _, tableView, _  in tableView.sectionFooterHeight },
                viewForHeaderInSection: @escaping ViewForHeaderInSection = { _, _, _ in nil },
                viewForFooterInSection: @escaping ViewForFooterInSection = { _, _, _ in nil }) {
        
        self.heightForRowAtIndexPath = heightForRowAtIndexPath
        self.heightForHeaderInSection = heightForHeaderInSection
        self.heightForFooterInSection = heightForFooterInSection
        self.viewForHeaderInSection = viewForHeaderInSection
        self.viewForFooterInSection = viewForFooterInSection
        
        super.init(configureCell: configureCell,
                   titleForHeaderInSection: titleForHeaderInSection,
                   titleForFooterInSection: titleForFooterInSection,
                   canEditRowAtIndexPath: canEditRowAtIndexPath,
                   canMoveRowAtIndexPath: canMoveRowAtIndexPath,
                   sectionIndexTitles: sectionIndexTitles,
                   sectionForSectionIndexTitle: sectionForSectionIndexTitle)
        
        
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAtIndexPath(self, tableView, indexPath, self[indexPath])
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeaderInSection(self, tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooterInSection(self, tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeaderInSection(self, tableView, section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooterInSection(self, tableView, section)
    }
}



public extension Reactive where Base: UITableView {
    func items<Proxy: RxTableViewDataSourceType & UITableViewDataSource & UITableViewDelegate, O: ObservableType>(proxy: Proxy)
        -> (_ source: O)
        -> Disposable
        where Proxy.Element == O.Element
    {
        return { source in
            _ = self.delegate
            return source.subscribeTableViewProxy(
                self.base,
                proxy: proxy as (UITableViewDataSource & UITableViewDelegate),
                retainDelegate: true,
                binding: { [weak tableView = self.base] (event) in
                    guard let tableView = tableView else { return }
                    proxy.tableView(tableView, observedEvent: event)
            })
        }
    }
}

fileprivate extension ObservableType {
    func subscribeTableViewProxy(_ tableView: UITableView,
                                 proxy: UITableViewDataSource & UITableViewDelegate,
                                 retainDelegate: Bool,
                                 binding: @escaping (Event<Element>) -> Void)
        -> Disposable {
            let dataSourceProxy = RxTableViewDataSourceProxy.proxy(for: tableView)
            let delegateProxy = RxTableViewDelegateProxy.proxy(for: tableView)
            
            let unregisterDataSource = RxTableViewDataSourceProxy.installForwardDelegate(proxy, retainDelegate: retainDelegate, onProxyForObject: tableView)
            let unregisterDelegate = RxTableViewDelegateProxy.installForwardDelegate(proxy, retainDelegate: retainDelegate, onProxyForObject: tableView)
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            tableView.layoutIfNeeded()
            
            let subscription = self.asObservable()
                .observeOn(MainScheduler())
                .catchError { error in
                    bindingError(error)
                    return Observable.empty()
                }
                // source can never end, otherwise it would release the subscriber, and deallocate the data source
                .concat(Observable.never())
                .takeUntil(tableView.rx.deallocated)
                .subscribe { [weak tableView] (event: Event<Element>) in
                    
                    if let tableView = tableView {
                        assert(dataSourceProxy === RxTableViewDataSourceProxy.currentDelegate(for: tableView), "Proxy changed from the time it was first set.\nOriginal: \(dataSourceProxy)\nExisting: \(String(describing: RxTableViewDataSourceProxy.currentDelegate(for: tableView)))")
                        assert(delegateProxy === RxTableViewDelegateProxy.currentDelegate(for: tableView), "Proxy changed from the time it was first set.\nOriginal: \(delegateProxy)\nExisting: \(String(describing: RxTableViewDelegateProxy.currentDelegate(for: tableView)))")
                    }
                    
                    binding(event)
                    
                    switch event {
                    case .error(let error):
                        bindingError(error)
                        unregisterDataSource.dispose()
                        unregisterDelegate.dispose()
                    case .completed:
                        unregisterDataSource.dispose()
                        unregisterDelegate.dispose()
                    default:
                        break
                    }
            }
            
            return Disposables.create { [weak tableView] in
                subscription.dispose()
                tableView?.layoutIfNeeded()
                unregisterDataSource.dispose()
                unregisterDelegate.dispose()
            }
    }
}

fileprivate func bindingError(_ error: Swift.Error) {
    let error = "Binding error: \(error)"
    #if DEBUG
    fatalError(error)
    #else
    print(error)
    #endif
}
