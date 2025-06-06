import UIKit

open class FXDsceneCollection: UIViewController, FXDscrollableCells, @unchecked Sendable {

	@IBOutlet public weak var mainCollectionview: UICollectionView?

	// MARK: FXDprotocolScrollable
	open weak var mainScrollview: UIScrollView? {
		return mainCollectionview
	}

	// MARK: FXDscrollableCells
    public lazy var cellOperationQueue: OperationQueue? = {
		return OperationQueue.newSerialQueue(withName: String(describing: self))
	}()
    public lazy var cellOperationDictionary: NSMutableDictionary? = {
		return NSMutableDictionary.init()
	}()

	open var mainDataSource: [Any]?

	open var mainCellIdentifier: String {
		fxd_overridable()
		return "CELL_\(String(describing: type(of: self)))"
	}
	open func configureCell(_ cell: UIView, for indexPath: IndexPath) {
		fxd_overridable()
	}
	open func enqueueCellOperation(for cell: UIView, indexPath: IndexPath) {
		fxd_overridable()

		let operation = BlockOperation()

		operation.addExecutionBlock {
			[weak self] in

			guard operation.isCancelled == false else {
                Task {	@MainActor in
                    self?.cellOperationQueue?.removeOperation(forKey: indexPath.stringKey, with: self?.cellOperationDictionary)
                }
				return
			}

			fxd_todo()
		}

		cellOperationQueue?.enqueueOperation(operation, forKey: indexPath.stringKey, with: cellOperationDictionary)
	}
}

extension FXDsceneCollection: UICollectionViewDataSource {
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1	// MARK: Assume it's often just one array
	}
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (mainDataSource != nil) ? (mainDataSource?.count)! : 0
	}

	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellIdentifier, for: indexPath)

		configureCell(cell, for: indexPath)
		enqueueCellOperation(for: cell, indexPath: indexPath)

		return cell
	}
}

extension FXDsceneCollection: UICollectionViewDelegate {
	public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		_ = cellOperationQueue?.cancelOperation(forKey: indexPath.stringKey, with: cellOperationDictionary)
	}
}
