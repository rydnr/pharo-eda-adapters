Class {
	#name : #EDAAMongoEventStore,
	#superclass : #EDAEventStore,
	#traits : 'EDACPrintOnHelper + EDACTMongoHelper',
	#classTraits : 'EDACPrintOnHelper classTrait + EDACTMongoHelper classTrait',
	#classInstVars : [
		'username',
		'password',
		'databaseName',
		'host',
		'port',
		'debug',
		'enableReplication',
		'enableSingleton',
		'ensuringCurrentOnSave',
		'ensuringCurrentReferencesOnQueries',
		'forceEager',
		'lazySynchronize',
		'wireProtocolEnabled',
		'authenticationMechanism',
		'urls',
		'tls'
	],
	#category : #'EDAA-EventStore-Voyage'
}

{ #category : #accessing }
EDAAMongoEventStore class >> authenticationMechanism [
	^ authenticationMechanism
]

{ #category : #accessing }
EDAAMongoEventStore class >> authenticationMechanism: anObject [
	authenticationMechanism := anObject
]

{ #category : #accessing }
EDAAMongoEventStore class >> databaseName [
	^ databaseName
]

{ #category : #accessing }
EDAAMongoEventStore class >> databaseName: anObject [
	databaseName := anObject
]

{ #category : #accessing }
EDAAMongoEventStore class >> debug [
	^ debug
]

{ #category : #accessing }
EDAAMongoEventStore class >> debug: aBoolean [
	debug = aBoolean
		ifTrue: [ ^ self ].
	debug := aBoolean.
	self refreshVoyageSettings
]

{ #category : #'class initialization' }
EDAAMongoEventStore class >> doInitialize [
	self urls: nil.
	self tls: nil.
	self databaseName: nil.
	self username: nil.
	self password: nil.
	self debug: nil.
	self enableReplication: nil.
	self enableSingleton: nil.
	self ensuringCurrentOnSave: nil.
	self ensuringCurrentReferencesOnQueries: nil.
	self forceEager: nil.
	self lazySynchronize: nil.
	self wireProtocolEnabled: nil
]

{ #category : #accessing }
EDAAMongoEventStore class >> enableReplication [
	^ enableReplication
]

{ #category : #accessing }
EDAAMongoEventStore class >> enableReplication: aBoolean [
	enableReplication = aBoolean
		ifTrue: [ ^ self ].
	enableReplication := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAMongoEventStore class >> enableSingleton [
	^ enableSingleton
]

{ #category : #accessing }
EDAAMongoEventStore class >> enableSingleton: aBoolean [
	enableSingleton = aBoolean
		ifTrue: [ ^ self ].
	enableSingleton := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAMongoEventStore class >> ensuringCurrentOnSave [
	^ ensuringCurrentOnSave
]

{ #category : #accessing }
EDAAMongoEventStore class >> ensuringCurrentOnSave: aBoolean [
	ensuringCurrentOnSave = aBoolean
		ifTrue: [ ^ self ].
	ensuringCurrentOnSave := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAMongoEventStore class >> ensuringCurrentReferencesOnQueries [
	^ ensuringCurrentReferencesOnQueries
]

{ #category : #accessing }
EDAAMongoEventStore class >> ensuringCurrentReferencesOnQueries: aBoolean [
	ensuringCurrentReferencesOnQueries = aBoolean
		ifTrue: [ ^ self ].
	ensuringCurrentReferencesOnQueries := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAMongoEventStore class >> forceEager [
	^ forceEager
]

{ #category : #accessing }
EDAAMongoEventStore class >> forceEager: aBoolean [
	forceEager = aBoolean
		ifTrue: [ ^ self ].
	forceEager := aBoolean.
	self refreshVoyageSettings
]

{ #category : #'class initialization' }
EDAAMongoEventStore class >> initialize [
	self doInitialize
]

{ #category : #accessing }
EDAAMongoEventStore class >> lazySynchronize [
	^ lazySynchronize
]

{ #category : #accessing }
EDAAMongoEventStore class >> lazySynchronize: aBoolean [
	lazySynchronize = aBoolean
		ifTrue: [ ^ self ].
	lazySynchronize := aBoolean.
	self refreshVoyageSettings
]

{ #category : #accessing }
EDAAMongoEventStore class >> password [
	^ password
]

{ #category : #accessing }
EDAAMongoEventStore class >> password: anObject [
	password := anObject
]

{ #category : #'refresh settings' }
EDAAMongoEventStore class >> refreshVoyageSettings [
	EDAAVOMongoRepository allInstancesDo: [ :repo | self refreshVoyageSettingsOn: repo ]
]

{ #category : #'refresh settings' }
EDAAMongoEventStore class >> refreshVoyageSettingsOn: aRepository [
	aRepository username: self username.
	aRepository password: self password.
	aRepository debug: self debug.
	self enableReplication
		ifTrue: [ aRepository enableReplication ]
		ifFalse: [ aRepository disableReplication ].
	aRepository ensuringCurrentOnSave: self ensuringCurrentOnSave.
	aRepository ensuringCurrentReferencesOnQueries: self ensuringCurrentReferencesOnQueries.
	aRepository lazySynchronize: self lazySynchronize.
	self enableSingleton
		ifTrue: [ aRepository enableSingleton ]
		ifFalse: [ aRepository disableSingleton ].
	aRepository wireProtocolEnabled: self wireProtocolEnabled
]

{ #category : #accessing }
EDAAMongoEventStore class >> tls [
	^ tls
]

{ #category : #accessing }
EDAAMongoEventStore class >> tls: aBoolean [
	tls := aBoolean
]

{ #category : #accessing }
EDAAMongoEventStore class >> urls [
	^ urls
]

{ #category : #accessing }
EDAAMongoEventStore class >> urls: aString [
	urls := aString
]

{ #category : #accessing }
EDAAMongoEventStore class >> username [
	^ username
]

{ #category : #accessing }
EDAAMongoEventStore class >> username: anObject [
	username := anObject
]

{ #category : #accessing }
EDAAMongoEventStore class >> wireProtocolEnabled [
	^ wireProtocolEnabled
]

{ #category : #accessing }
EDAAMongoEventStore class >> wireProtocolEnabled: aBoolean [
	wireProtocolEnabled = aBoolean
		ifTrue: [ ^ self ].
	wireProtocolEnabled := aBoolean.
	self refreshVoyageSettings
]

{ #category : #persistence }
EDAAMongoEventStore >> allEventsOfTenant: aTenant [
	| eventsCriteria |
	eventsCriteria := (OrderedCollection
		with: 'tenant' -> aTenant greaseString)
		asDictionary.
	^ EDAEventSourcingEvent
		selectMany: eventsCriteria
		sortBy: (OrderedCollection with: #timestamp -> VOOrder ascending with: #_id -> VOOrder ascending) asDictionary
]

{ #category : #persistence }
EDAAMongoEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass whereCriteria: aCriteriaDictionary [
	| eventsCriteria |
	eventsCriteria := Dictionary newFrom: aCriteriaDictionary.
	eventsCriteria at: 'tenant' put: aTenant greaseString.
	eventsCriteria at: 'aggregateRootClass' put: anAggregateRootClass greaseString.
	^ EDAEventSourcingEvent
		selectMany: eventsCriteria
		sortBy: (OrderedCollection with: #timestamp -> VOOrder ascending) asDictionary
]

{ #category : #persistence }
EDAAMongoEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass whereId: aNumber [
	^ self
		findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass
		whereCriteria: (OrderedCollection with: 'id' -> aNumber) asDictionary
]

{ #category : #persistence }
EDAAMongoEventStore >> initBackendRepository [
	| result |
	result := self mongoRepositoryClass
		mongoUrls: (self csvToCollection: self class urls)
		database: self class databaseName
		username: self class username
		password: self class password.
	"result cache: EDAMongoNoCache new."
	result debug: self class debug.
	self class enableReplication
		ifTrue: [ result enableReplication ]
		ifFalse: [ result disableReplication ].
	self class enableSingleton
		ifTrue: [ result enableSingleton ]
		ifFalse: [ result disableSingleton ].
	result ensuringCurrentOnSave: self class ensuringCurrentOnSave.
	result
		ensuringCurrentReferencesOnQueries: self class ensuringCurrentReferencesOnQueries.
	result
		ensuringCurrentReferencesOnQueries: self class ensuringCurrentReferencesOnQueries.
	result lazySynchronize: self class lazySynchronize.
"	result wireProtocolEnabled: self class wireProtocolEnabled."
	^ result
]

{ #category : #persistence }
EDAAMongoEventStore >> mongoRepositoryClass [
	^ EDAAVOMongoRepository
]

{ #category : #persistence }
EDAAMongoEventStore >> saveEvents: anEventCollection [
	anEventCollection do: [ :event | event save ]
]
