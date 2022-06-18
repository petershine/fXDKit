

import fXDObjC


class FXDcoredataBackup: FXDmoduleCoredata {
	static var shared: FXDcoredataBackup = FXDcoredataBackup()

	override var coredataName: String? {
		get {
			let lastComponent = Bundle.main.bundleIdentifier?.components(separatedBy: ".").last ?? ""

			let name = "Backup_\(lastComponent)"
			return name
		}
		set {
			super.coredataName = newValue
		}
	}

	override var ubiquitousContentName: String? {
		get {
			return self.coredataName
		}
		set {
			super.ubiquitousContentName = newValue
		}
	}
}
