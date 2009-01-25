//
//  PerformanceStats.h
//  Retorted
//
//  Created by B.J. Ray on 1/24/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Statistic;

@interface PerformanceStats : NSObject {
	NSString *dbFilePath;
	BOOL isDBAvailable;
	
	//current instance...
	Statistic *parserStat;
	Statistic *downloadStat;
	
	// Historical Data - ReadOnly?
//	NSUInteger totalRunCount;
//	double avgDownloadTime;
//	double avgParseTime;
//	double avgTotalTime;			//sum of two above
//	
//	double meanDownloadTime;
//	double meanParseTime;
//	double meanTotalTime;			//sum of two above
//	
//	double minParseTime;
//	double maxParseTime;
//	double minDownloadTime;	
//	double maxDownloadTime;	
//	
//	NSString *historicalURL;		//the url for which the stats are gathered.
//	NSArray *urlListing;			//a list of the urls that we have data for.
}

@property (nonatomic, retain) NSString *dbFilePath;
@property BOOL isDBAvailable;

@property (nonatomic, retain) Statistic *parserStat;
@property (nonatomic, retain) Statistic *downloadStat;

- (void)saveCurrentStatistics;
@end
