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
	^ self key asSymbol
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
