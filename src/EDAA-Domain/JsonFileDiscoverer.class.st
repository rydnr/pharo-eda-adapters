Class {
	#name : #JsonFileDiscoverer,
	#superclass : #Object,
	#instVars : [
		'jsonFile',
		'candidates'
	],
	#category : #'EDAA-Domain'
}

{ #category : #'instance creation' }
JsonFileDiscoverer class >> forJsonFile: aFile [
	^ self new jsonFile: aFile; yourself
]

{ #category : #accessing }
JsonFileDiscoverer >> candidates [
	^ candidates
		ifNil: [ self candidates: (self processJsonFile: self jsonFile).
						candidates ]
]

{ #category : #accessing }
JsonFileDiscoverer >> candidates: anObject [
	candidates := anObject
]

{ #category : #accessing }
JsonFileDiscoverer >> jsonFile [
	^ jsonFile
]

{ #category : #accessing }
JsonFileDiscoverer >> jsonFile: anObject [
	jsonFile := anObject
]

{ #category : #accessing }
JsonFileDiscoverer >> processJsonFile: aFile [
	| result map |
	result := OrderedCollection new.
	map := (NeoJSONReader on: aFile name readStream) parseMap.
	map
		keysAndValuesDo: [ :k :v | 
			result
				add:
					(Dictionary new
						at: k put: v;
						yourself) ].
	^ result
]
