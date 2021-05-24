Class {
	#name : #EDAVOMongoRepository,
	#superclass : #VOMongoRepository,
	#traits : 'EDAPrintOnHelper',
	#classTraits : 'EDAPrintOnHelper classTrait',
	#category : #'EDAA-EventStore-Voyage'
}

{ #category : #voyage }
EDAVOMongoRepository class >> voyageCollectionName [
	^ 'EventSourcingEvent'
]

{ #category : #voyage }
EDAVOMongoRepository >> collectionNameFor: aClass [
	^ aClass voyageCollectionName
]

{ #category : #persistence }
EDAVOMongoRepository >> selectMany: aClass where: aBlock sortBy: sortBlock [
	^ self selectManyOperation
		queryClass: aClass;
		where: aBlock;
		sortBlock: sortBlock;
		execute

]
