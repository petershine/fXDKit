

class FXDsceneCollection: FXDsceneTable {

	@IBOutlet override var mainScrollview: UIScrollView? {
		get {
			if mainCollectionview == nil {
				return super.mainScrollview
			}

			return mainCollectionview
		}
		set {
			super.mainScrollview = newValue
		}
	}

	@IBOutlet var mainCollectionview: UICollectionView?

	override func willMove(toParentViewController parent: UIViewController?) {
		if parent == nil {
			mainCollectionview?.delegate = nil
			mainCollectionview?.dataSource = nil
		}

		super.willMove(toParentViewController: parent)
	}
}

extension FXDsceneCollection {	//FXDsceneWithCells
	override func registerMainCellNib() {
		guard mainCollectionview != nil
			&& mainCellNib != nil
			&& mainCellIdentifier != nil else {
				super.registerMainCellNib()
				return
		}

		fxd_log_func()
		fxdPrint(mainCollectionview!)
		fxdPrint(mainCellIdentifier!)

		mainCollectionview?.register(mainCellNib!, forCellWithReuseIdentifier: mainCellIdentifier!)
	}
}

extension FXDsceneCollection: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		let sectionCount = numberOfSections(for: collectionView)

		return sectionCount
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		let itemCount = numberOfItems(for: collectionView, atSection: section)

		return itemCount
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		assert(mainCellIdentifier != nil, "MUST configure mainCellIdentifier")

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellIdentifier!, for: indexPath)

		let operation = BlockOperation()

		operation.addExecutionBlock {
			if operation.isCancelled == false {
				// Do something
			}

			OperationQueue.current?.addOperation({
				[weak self] in

				self?.cellOperationQueue.removeOperation(forKey: indexPath, with: self?.cellOperationDictionary)
			})
		}

		cellOperationQueue.enqueOperation(operation, forKey: indexPath, with: cellOperationDictionary)

		return cell
	}
}

extension FXDsceneCollection: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

		_ = cellOperationQueue.cancelOperation(forKey: indexPath, with: cellOperationDictionary)
	}
}
