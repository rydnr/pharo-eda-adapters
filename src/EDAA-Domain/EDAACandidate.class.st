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
	| result valid |
	result := self adapterClassFromKey.
	valid := self isClassValid: result.
	valid
		ifFalse: [ result := self adapterClassFromPragma.
			valid := self isClassValid: result ].
	^ valid
		ifTrue: [ result ]
		ifFalse: [ nil ]
]

{ #category : #api }
EDAACandidate >> adapterClassFromKey [
	^ self key asSymbol
]

{ #category : #api }
EDAACandidate >> adapterClassFromPragma [
	| results annotatedClasses |
	annotatedClasses := EDAAPragmaBasedCandidateAdapterClassNameResolver
		traitUsers.
	annotatedClasses
		do: [ :annotatedClass | 
			| pragmas |
			pragmas := Pragma
				allNamed: #edaAdapterClass:
				inAndBelow: annotatedClass.
			results := pragmas
				select: [ :pragma | pragma method selector = self key ]
				thenCollect: [ :pragma | pragma argumentAt: 1 ] ].
	^ results
		ifNil: [ nil ]
		ifNotNil: [ :r | r ifEmpty: [ nil ] ifNotEmpty: [ :c | c first ] ]
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
