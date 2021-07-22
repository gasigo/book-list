.PHONY: export_tree
export_tree:
	@echo Exporting Composition Tree. Go to https://dreampuf.github.io/GraphvizOnline to visualise the diagram output 
	chmod +x DependencyTreeExporter.swift
	./DependencyTreeExporter.swift

.PHONY: xcodegen
xcodegen:
	@echo Generating Xcode Project
	xcodegen generate