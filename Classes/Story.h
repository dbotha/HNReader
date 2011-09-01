//
//  Story.h
//  HackerNewsReader
//
//  Created by Deon Botha on 04/09/2010.
//  Copyright 2010 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject {
	NSString *_title;
	NSString *_urlStr;
	NSString *_domain;
	NSString *_submitterUsername;
	NSString *_submissionTime;
	NSString *_submitterProfileURLStr;
	NSString *_commentsURLStr;
	NSUInteger _numComments, _numPoints; 
	BOOL _visited;
}

@property (nonatomic, readonly) NSString *title, *urlStr, *domain, *submissionTime, *submitterUsername, *submitterProfileURLStr, *commentsURLStr;
@property (nonatomic, readonly) NSUInteger numComments, numPoints;
@property (nonatomic) BOOL visited;

-(id) initWithTitle: (NSString *) title 
			 urlStr: (NSString *) urlStr 
	   domain: (NSString *) domain 
		  submitter: (NSString *) submitterUsername 
submitterProfileURLStr: (NSString *) submitterProfileURLStr
	 submissionTime: (NSString *) submissionTime
	 commentsURLStr: (NSString *) commentsURLStr
		  numPoints: (NSUInteger) numPoints 
		numComments: (NSUInteger) numComments;
@end
