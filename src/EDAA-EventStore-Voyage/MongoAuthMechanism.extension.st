Extension { #name : #MongoAuthMechanism }

{ #category : #'*EDAA-EventStore-Voyage' }
MongoAuthMechanism class >> from: aString [


	^ self environment at: ('-' asRegexIgnoringCase
		  copy: aString
		  replacingMatchesWith: '') asSymbol ifAbsent: [ Mongo defaultAuthMechanismClass ]
]

{ #category : #'*EDAA-EventStore-Voyage' }
MongoAuthMechanism class >> textDescription [
	self subclassResponsibility
]
