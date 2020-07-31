//Created  on 2020/7/29 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 * 代码来源于：Pircate：https://github.com/Pircate/RxSwiftX
 */




import RxSwift
import RxCocoa
import RxDataSources

open class RxCollectionViewSectionedReloadDataSourceX<Section: SectionModelType>: RxCollectionViewSectionedReloadDataSource<Section>, UICollectionViewDelegateFlowLayout {
    
    public typealias SizeForItemAtIndexPath = (RxCollectionViewSectionedReloadDataSourceX<Section>, UICollectionViewLayout, IndexPath) -> CGSize
    public typealias InsetForSectionAtSection = (RxCollectionViewSectionedReloadDataSourceX<Section>, UICollectionViewLayout, Int) -> UIEdgeInsets
    public typealias MinimumLineSpacingForSectionAtSection = (RxCollectionViewSectionedReloadDataSourceX<Section>, UICollectionViewLayout, Int) -> CGFloat
    public typealias MinimumInteritemSpacingForSectionAtSection = (RxCollectionViewSectionedReloadDataSourceX<Section>, UICollectionViewLayout, Int) -> CGFloat
    public typealias ReferenceSizeForHeaderInSection = (RxCollectionViewSectionedReloadDataSourceX<Section>, UICollectionViewLayout, Int) -> CGSize
    public typealias ReferenceSizeForFooterInSection = (RxCollectionViewSectionedReloadDataSourceX<Section>, UICollectionViewLayout, Int) -> CGSize
    
    open var sizeForItemAtIndexPath: SizeForItemAtIndexPath
    open var insetForSectionAtSection: InsetForSectionAtSection
    open var minimumLineSpacingForSectionAtSection: MinimumLineSpacingForSectionAtSection
    open var minimumInteritemSpacingForSectionAtSection: MinimumInteritemSpacingForSectionAtSection
    open var referenceSizeForHeaderInSection: ReferenceSizeForHeaderInSection
    open var referenceSizeForFooterInSection: ReferenceSizeForFooterInSection
    
    public init(configureCell: @escaping ConfigureCell,
                configureSupplementaryView: ConfigureSupplementaryView? = nil,
                moveItem: @escaping MoveItem = { _, _, _ in () },
                canMoveItemAtIndexPath: @escaping CanMoveItemAtIndexPath = { _, _ in false },
                sizeForItemAtIndexPath: @escaping SizeForItemAtIndexPath = { _, layout, _ in RxCollectionViewSectionedReloadDataSourceX.itemSize(for: layout)  },
                insetForSectionAtSection: @escaping InsetForSectionAtSection = { _, layout, _ in RxCollectionViewSectionedReloadDataSourceX.sectionInset(for: layout) },
                minimumLineSpacingForSectionAtSection: @escaping MinimumLineSpacingForSectionAtSection = { _, layout, _ in RxCollectionViewSectionedReloadDataSourceX.minimumLineSpacing(for: layout) },
                minimumInteritemSpacingForSectionAtSection: @escaping MinimumInteritemSpacingForSectionAtSection = { _, layout, _ in RxCollectionViewSectionedReloadDataSourceX.minimumInteritemSpacing(for: layout) },
                referenceSizeForHeaderInSection: @escaping ReferenceSizeForHeaderInSection = { _, layout, _ in RxCollectionViewSectionedReloadDataSourceX.headerReferenceSize(for: layout) },
                referenceSizeForFooterInSection: @escaping ReferenceSizeForFooterInSection = { _, layout, _ in RxCollectionViewSectionedReloadDataSourceX.footerReferenceSize(for: layout) }) {
        
        self.sizeForItemAtIndexPath = sizeForItemAtIndexPath
        self.insetForSectionAtSection = insetForSectionAtSection
        self.minimumLineSpacingForSectionAtSection = minimumLineSpacingForSectionAtSection
        self.minimumInteritemSpacingForSectionAtSection = minimumInteritemSpacingForSectionAtSection
        self.referenceSizeForHeaderInSection = referenceSizeForHeaderInSection
        self.referenceSizeForFooterInSection = referenceSizeForFooterInSection
        
        super.init(configureCell: configureCell,
                   configureSupplementaryView: configureSupplementaryView,
                   moveItem: moveItem,
                   canMoveItemAtIndexPath: canMoveItemAtIndexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItemAtIndexPath(self, collectionViewLayout, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSectionAtSection(self, collectionViewLayout, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSectionAtSection(self, collectionViewLayout, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacingForSectionAtSection(self, collectionViewLayout, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSizeForHeaderInSection(self, collectionViewLayout, section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSizeForFooterInSection(self, collectionViewLayout, section)
    }
}

public extension RxCollectionViewSectionedReloadDataSourceX {
    
    static func itemSize(for layout: UICollectionViewLayout) -> CGSize {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGSize.zero }
        return flowLayout.itemSize
    }
    
    static func sectionInset(for layout: UICollectionViewLayout) -> UIEdgeInsets {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return UIEdgeInsets.zero }
        return flowLayout.sectionInset
    }
    
    static func minimumLineSpacing(for layout: UICollectionViewLayout) -> CGFloat {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGFloat.leastNormalMagnitude }
        return flowLayout.minimumLineSpacing
    }
    
    static func minimumInteritemSpacing(for layout: UICollectionViewLayout) -> CGFloat {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGFloat.leastNormalMagnitude }
        return flowLayout.minimumInteritemSpacing
    }
    
    static func headerReferenceSize(for layout: UICollectionViewLayout) -> CGSize {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGSize.zero }
        return flowLayout.headerReferenceSize
    }
    
    static func footerReferenceSize(for layout: UICollectionViewLayout) -> CGSize {
        guard let flowLayout = layout as? UICollectionViewFlowLayout else { return CGSize.zero }
        return flowLayout.footerReferenceSize
    }
}

public extension Reactive where Base: UICollectionView {
    
    func items<Proxy: RxCollectionViewDataSourceType & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout, O: ObservableType>(proxy: Proxy)
        -> (_ source: O)
        -> Disposable
        where Proxy.Element == O.Element
    {
        return { source in
            return source.subscribeCollectionViewProxy(
                self.base,
                proxy: proxy as (UICollectionViewDataSource & UICollectionViewDelegateFlowLayout),
                retainProxy: true,
                binding: { [weak collectionView = self.base] (_, _, event) in
                    guard let collectionView = collectionView else { return }
                    proxy.collectionView(collectionView, observedEvent: event)
            })
        }
    }
}

extension ObservableType {
    
    func subscribeCollectionViewProxy(_ collectionView: UICollectionView, proxy: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout, retainProxy: Bool, binding: @escaping (RxCollectionViewDataSourceProxy, RxCollectionViewDelegateProxy, Event<Element>) -> Void)
        -> Disposable {
            let dataSourceProxy = RxCollectionViewDataSourceProxy.proxy(for: collectionView)
            let delegateProxy = RxCollectionViewDelegateProxy.proxy(for: collectionView)
            
            let unregisterDataSource = RxCollectionViewDataSourceProxy.installForwardDelegate(proxy, retainDelegate: retainProxy, onProxyForObject: collectionView)
            let unregisterDelegate = RxCollectionViewDelegateProxy.installForwardDelegate(proxy, retainDelegate: retainProxy, onProxyForObject: collectionView)
            
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            collectionView.layoutIfNeeded()
            
            let subscription = self.asObservable()
                .observeOn(MainScheduler())
                .catchError { error in
                    bindingError(error)
                    return Observable.empty()
                }
                // source can never end, otherwise it would release the subscriber, and deallocate the data source
                .concat(Observable.never())
                .takeUntil(collectionView.rx.deallocated)
                .subscribe { [weak collectionView] (event: Event<Element>) in
                    
                    if let collectionView = collectionView {
                        assert(dataSourceProxy === RxCollectionViewDataSourceProxy.currentDelegate(for: collectionView), "Proxy changed from the time it was first set.\nOriginal: \(dataSourceProxy)\nExisting: \(String(describing: RxCollectionViewDataSourceProxy.currentDelegate(for: collectionView)))")
                        assert(delegateProxy === RxCollectionViewDelegateProxy.currentDelegate(for: collectionView), "Proxy changed from the time it was first set.\nOriginal: \(delegateProxy)\nExisting: \(String(describing: RxCollectionViewDelegateProxy.currentDelegate(for: collectionView)))")
                    }
                    
                    binding(dataSourceProxy, delegateProxy, event)
                    
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
            
            return Disposables.create { [weak collectionView] in
                subscription.dispose()
                collectionView?.layoutIfNeeded()
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
