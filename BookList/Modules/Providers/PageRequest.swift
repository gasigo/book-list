struct PageRequest {
	let size: Int
	let offset: Int
	let total: Int

	func nextPage() -> Self? {
		let nextOffset = offset + size

		if nextOffset > total {
			let missingItems = total - offset

			if missingItems > 0 {
				return PageRequest(size: size, offset: total - missingItems, total: total)
			}

			return nil
		} else {
			return PageRequest(size: size, offset: nextOffset, total: total)
		}
	}
}
