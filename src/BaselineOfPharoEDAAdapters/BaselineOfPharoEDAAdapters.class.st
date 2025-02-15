"
**Class**

I'm a baseline to load PharoEDA Adapters.

**Responsibilities**

Guide Metacello to load PharoEDA-Adapters with its dependencies.

**Collaborators**

Metacello
"
Class {
	#name : #BaselineOfPharoEDAAdapters,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoEDAAdapters
}

{ #category : #meta }
BaselineOfPharoEDAAdapters class >> declareGroupsIn: spec [
	spec
		group: 'core'
			with:
			#(#'EDAA-Domain' #'EDAA-EventStore-InMemory' #'EDAA-EventStore-Voyage' #'EDAA-Messaging-Stomp' #'EDAA-Projections-Voyage' #'EDAA-SMTP');
		group: 'tests' with: #(#'EDAA-Domain-Tests');
		group: 'default' with: #('core' 'tests')
]

{ #category : #meta }
BaselineOfPharoEDAAdapters class >> declarePackagesIn: spec [

	spec
		package: #'EDAA-Domain'
		with: [ spec requires: #( 'PharoEDACommon' 'PharoEDAPorts' ) ];
		package: #'EDAA-EventStore-InMemory'
		with: [ spec requires: #( 'PharoEDACommon' 'PharoEDAPorts' ) ];
		package: #'EDAA-EventStore-Voyage'
		with: [ 
			spec requires: #( 'Voyage' 'PharoEDACommon' 'PharoEDAPorts' ) ];
		package: #'EDAA-Messaging-Stomp' with: [ 
			spec requires:
					#( 'Stamp' 'PharoEDACommon' 'PharoEDAPorts' 'EDAA-Domain' ) ];
		package: #'EDAA-Projections-Voyage'
		with: [ 
			spec requires: #( 'Voyage' 'PharoEDACommon' 'PharoEDAPorts' ) ];
		package: #'EDAA-SMTP'
		with: [ spec requires: #( 'PharoEDACommon' ) ];
		package: #'EDAA-Domain-Tests'
		with: [ spec requires: #( 'EDAA-Domain' 'EDAA-Messaging-Stomp' ) ]
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters class >> includeMongotalk: spec [
	spec
		baseline: 'MongoTalk'
		with: [ spec
				repository: 'github://pharo-nosql/mongotalk:1.22/mc' ].
	^ spec

]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters class >> includePharoEDACommon: spec [
       spec
               baseline: 'PharoEDACommon'
               with: [ spec repository: 'github://rydnr/pharo-eda-common:main' ].
       ^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters class >> includePharoEDAErrors: spec [
	spec
		baseline: 'PharoEDAErrors'
		with: [ spec repository: 'github://rydnr/pharo-eda-errors:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters class >> includePharoEDAPorts: spec [
	spec
		baseline: 'PharoEDAPorts'
		with: [ spec repository: 'github://rydnr/pharo-eda-ports:main' ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters class >> includeStamp: spec [
	spec baseline: 'Stamp' with: [ spec repository: 'github://svenvc/stamp/repository' ].
	^ spec

]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters class >> includeVoyage: spec [

	spec baseline: 'Voyage' with: [
		(self environment hasClassNamed: #GtImage) ifTrue: [ 
		spec repository:
			'github://rydnr/voyage:' , self voyageReleaseForPharoVersion
			, '/mc'
			
			 ] ifFalse: [ 
		spec repository:
			'github://pharo-nosql/voyage:' , self voyageReleaseForPharoVersion
			, '/mc' ] ].
	^ spec
]

{ #category : #dependencies }
BaselineOfPharoEDAAdapters class >> voyageReleaseForPharoVersion [

	^ SystemVersion current major = 8
		  ifTrue: [ '1.7' ]
		  ifFalse: [ 
			  SystemVersion current major = 9
				  ifTrue: [ '1.7.1' ]
				  ifFalse: [ 'pharo10-ready' ] ]
]

{ #category : #baselines }
BaselineOfPharoEDAAdapters >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec blessing: #baseline.
		spec postLoadDoIt: #postload:package:.
		self class includePharoEDACommon: spec;
		 includePharoEDAPorts: spec;
		 includePharoEDAErrors: spec;
		 includeStamp: spec;
		 includeVoyage: spec;
		 declarePackagesIn: spec;
		 declareGroupsIn: spec ]
]

{ #category : #hooks }
BaselineOfPharoEDAAdapters >> postload: loader package: packageSpec [

	| location |
	location := (IceRepository registry detect: [ :each | 
		             each name = 'pharo-eda-adapters' ]) location.
	EDACIconProvider addDefaultLocation: location / 'resources' / 'icons'.
	EDACTranslationProvider addDefaultLocation:
		location / 'resources' / 'l10n'
]
