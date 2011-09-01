//
//  RootViewController.m
//  HackerNewsReader
//
//  Created by Deon Botha on 08/10/2010.
//  Copyright 2010 None. All rights reserved.
//

#import "RootViewController.h"

#import "StoryCell.h"

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle: style]) {
		
	}
	
	return self;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"StoryCell";
	StoryCell *cell = (StoryCell *) [super.tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if (cell == nil) {
		
	}
	
	return cell;
}

#pragma mark UITableViewDelegate methods

@end
