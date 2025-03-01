import fXDObjC

open class FXDsceneTable: UIViewController, FXDscrollableCells, @unchecked Sendable {
	
	@IBOutlet public weak var mainTableview: UITableView?

	//MARK: FXDprotocolScrollable
	open weak var mainScrollview: UIScrollView? {
		return mainTableview
	}

	//MARK: FXDscrollableCells
    public lazy var cellOperationQueue: OperationQueue? = {
		return OperationQueue.newSerialQueue(withName: String(describing: self))
	}()
	public lazy var cellOperationDictionary: NSMutableDictionary? = {
		return NSMutableDictionary.init()
	}()

	open var mainDataSource: Array<Any>?

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
                Task {    @MainActor in
                    self?.cellOperationQueue?.removeOperation(forKey: indexPath.stringKey, with: self?.cellOperationDictionary)
                }
				return
			}

			fxd_todo()
		}

		cellOperationQueue?.enqueueOperation(operation, forKey: indexPath.stringKey, with: cellOperationDictionary)
	}
}

extension FXDsceneTable: UITableViewDataSource {
	open func numberOfSections(in tableView: UITableView) -> Int {
		return 1	//MARK: Assume it's often just one array
	}
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (mainDataSource != nil) ? (mainDataSource?.count)! : 0
	}

	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: mainCellIdentifier)

		if cell == nil {
			cell = FXDTableViewCell.init(style: .subtitle, reuseIdentifier: mainCellIdentifier)
		}

		configureCell(cell!, for: indexPath)
		enqueueCellOperation(for: cell!, indexPath: indexPath)

		return cell!
	}
}

extension FXDsceneTable: UITableViewDelegate {
	open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		_ = cellOperationQueue?.cancelOperation(forKey: indexPath.stringKey, with: cellOperationDictionary)
	}
}
