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
			self includeStamp: spec.
			self includeVoyage: spec.
			self declarePackagesIn: spec.
			self declareGroupsIn: spec ]
]

{ #category : #meta }
BaselineOfPharoEDAAdapters >> declareGroupsIn: spec [
	spec
		group: 'core'
			with:
			#(#'EDAA-Domain' #'PharoEDACommon' #'Stamp');
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
BaselineOfPharoEDAAdapters >> includeMongotalk: spec [
	spec
		baseline: 'MongoTalk'
		with: [ spec
				repository: 'github://pharo-nosql/mongotalk:1.22/mc' ].
	^ spec

]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters >> includePharoEDACommon: spec [
	spec
		baseline: 'PharoEDACommon'
		with: [ spec repository: 'github://osoco/pharo-eda-common:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters >> includeStamp: spec [
	spec baseline: 'Stamp' with: [ spec repository: 'github://svenvc/stamp/repository' ].
	^ spec

]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters >> includeVoyage: spec [
	spec
		baseline: 'Voyage'
		with: [ spec
				repository: 'github://pharo-nosql/voyage:1.7/mc' ].
	^ spec

]
