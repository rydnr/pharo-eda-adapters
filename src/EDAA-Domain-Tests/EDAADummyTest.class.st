Class {
	#name : #EDAADummyTest,
	#superclass : #TestCase,
	#instVars : [
		'a',
		'b'
	],
	#category : #'EDAA-Domain-Tests'
}

{ #category : #tests }
EDAADummyTest >> testTautology [
	self assert: true
]
