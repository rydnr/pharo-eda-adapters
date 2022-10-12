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
			self includePharoEDAPorts: spec.
			self includePharoEDAErrors: spec.
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
			#(#'EDAA-Domain' #'EDAA-EventStore-InMemory' #'EDAA-EventStore-Voyage' #'EDAA-Messaging-Stomp' #'EDAA-Projections-Voyage' #'EDAA-SMTP');
		group: 'tests' with: #(#'EDAA-Domain-Tests');
		group: 'default' with: #('core' 'tests')
]

{ #category : #meta }
BaselineOfPharoEDAAdapters >> declarePackagesIn: spec [
	spec
		package: #'EDAA-Domain'
			with: [ spec requires: #('PharoEDACommon' 'PharoEDAPorts') ];
		package: #'EDAA-Domain-Tests'
			with: [ spec requires: #('EDAA-Domain') ];
		package: #'EDAA-EventStore-InMemory'
			with: [ spec requires: #('PharoEDACommon' 'PharoEDAPorts') ];
		package: #'EDAA-EventStore-Voyage'
			with: [ spec requires: #('VoyageMongo' 'PharoEDACommon' 'PharoEDAPorts') ];
		package: #'EDAA-Messaging-Stomp'
			with: [ spec requires: #('Stamp' 'PharoEDACommon' 'PharoEDAPorts') ];
		package: #'EDAA-Projections-Voyage'
			with: [ spec requires: #('VoyageMongo' 'PharoEDACommon' 'PharoEDAPorts') ];
		package: #'EDAA-SMTP' with: [ spec requires: #('PharoEDACommon') ]
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
BaselineOfPharoEDAAdapters >> includePharoEDAErrors: spec [
	spec
		baseline: 'PharoEDAErrors'
		with: [ spec repository: 'github://rydnr/pharo-eda-errors:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters >> includePharoEDACommon: spec [
       spec
               baseline: 'PharoEDACommon'
               with: [ spec repository: 'github://rydnr/pharo-eda-common:main' ].
       ^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters >> includePharoEDAPorts: spec [
	spec
		baseline: 'PharoEDAPorts'
		with: [ spec repository: 'github://rydnr/pharo-eda-ports:main' ].
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
		baseline: 'VoyageMongo'
		with: [ spec
				repository: 'github://pharo-nosql/voyage:pharo10-ready/mc' ].
	^ spec

]
