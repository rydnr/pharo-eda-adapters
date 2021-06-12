Class {
	#name : #EDAACandidate,
	#superclass : #Object,
	#instVars : [
		'key',
		'value'
	],
	#category : #'EDAA-Domain'
}

{ #category : #'instance creation' }
EDAACandidate class >> withKey: aKey value: aValue [
	^ self new key: aKey; value: aValue; yourself
]

{ #category : #api }
EDAACandidate >> adapterClass [
	| result fromKey potentialAdapterClasses |
	fromKey := self adapterClassFromKey.
	result := (self isClassValid: fromKey)
		ifTrue: [ fromKey ]
		ifFalse: [ potentialAdapterClasses := self adapterClassesFromPragma
				select: [ :cls | self isClassValid: cls ].
			potentialAdapterClasses
				ifEmpty: [ nil ]
				ifNotEmpty: [ :c | c first ] ].
	^ result
]

{ #category : #api }
EDAACandidate >> adapterClassFromKey [
	^ self key asSymbol
]

{ #category : #api }
EDAACandidate >> adapterClasses [
	| results |
	results := self adapterClassesFromPragma.
	self adapterClassFromKey ifNotNil: [ :k | results addFirst: k ].
	^ results select: [ :cls | self isClassValid: cls ]
]

{ #category : #api }
EDAACandidate >> adapterClassesFromPragma [
	| results annotatedClasses |
	results := OrderedCollection new.
	annotatedClasses := EDAAPragmaBasedCandidateAdapterClassNameResolver
		traitUsers.
	annotatedClasses
		do:
			[ :annotatedClass | results addAll: (self adapterClassesFromPragmaIn: annotatedClass) ].
	^ results
]

{ #category : #api }
EDAACandidate >> adapterClassesFromPragmaIn: annotatedClass [
	| pragmas |
	pragmas := (Pragma
		allNamed: #edaAdapterClass:priority:
		inAndBelow: annotatedClass) asOrderedCollection.
	pragmas
		addAll: (Pragma allNamed: #edaAdapterClass:priority: inAndBelow: annotatedClass class).
	^ pragmas
		select: [ :pragma | pragma method selector = self key asSymbol ]
		thenCollect: [ :pragma | pragma argumentAt: 1 ]
]

{ #category : #api }
EDAACandidate >> isClassValid: aSymbol [
	^ (Smalltalk environment at: aSymbol ifAbsent: [ nil ]) isNotNil
]

{ #category : #accessing }
EDAACandidate >> key [
	^ key
]

{ #category : #accessing }
EDAACandidate >> key: anObject [
	key := anObject
]

{ #category : #accessing }
EDAACandidate >> value [
	^ value
]

{ #category : #accessing }
EDAACandidate >> value: anObject [
	value := anObject
]
