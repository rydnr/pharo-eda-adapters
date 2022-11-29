Extension { #name : #TStampFrameWithBody }

{ #category : #'*EDAA-Messaging-Stomp' }
TStampFrameWithBody >> contentType [

	^ self headerAt: #'content-type' ifAbsent: [ 
		  self
			  headerAt: #'Content-Type'
			  ifAbsent: [ self class defaultContentType ] ]
]

{ #category : #'*EDAA-Messaging-Stomp' }
TStampFrameWithBody classSide >> defaultContentType [

	^ 'application/json'
]

{ #category : #'*EDAA-Messaging-Stomp' }
TStampFrameWithBody >> text: string [

	self
		contentType: self contentType;
		body: string
]
