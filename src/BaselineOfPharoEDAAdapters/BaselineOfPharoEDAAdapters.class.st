Class {
	#name : #BaselineOfPharoEDAAdapters,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoEDAAdapters
}

{ #category : #baselines }
BaselineOfPharoEDAAdapters >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec blessing: #baseline.
			self includePharoEDACommon: spec.
			self declarePackagesIn: spec.
			self declareGroupsIn: spec ]
]

{ #category : #meta }
BaselineOfPharoEDAAdapters >> declareGroupsIn: spec [
	spec
		group: 'core'
			with:
			#(#'EDAA-Domain');
		group: 'tests'
			with:
			#(#'EDAA-Domain-Tests');
		group: 'default' with: #('core' 'tests')
]

{ #category : #meta }
BaselineOfPharoEDAAdapters >> declarePackagesIn: spec [
	spec
		package: #'EDAA-Domain' with: [ spec requires: #('PharoEDACommon') ];
		package: #'EDAA-Domain-Tests'
			with: [ spec requires: #('EDAA-Domain') ]
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters >> includePharoEDACommon: spec [
	spec
		baseline: 'PharoEDACommon'
		with: [ spec repository: 'github://osoco/pharo-eda-common:main' ].
	^ spec
]
