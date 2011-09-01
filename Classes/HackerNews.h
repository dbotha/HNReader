//
//  HackerNewsByRegex.h
//  HackerNewsReader
//
//  Created by Deon Botha on 04/09/2010.
//  Copyright 2010 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HackerNews : NSObject {
	
}

+ (NSArray/*<Story>*/ *)getStoriesFromHTML:(NSString *) html;
+ (NSString *)getNextPageURLStringFromHTML:(NSString *) html;
+ (NSArray/*<Comment>*/ *)getCommentsFromHTML:(NSString *) html;

@end
