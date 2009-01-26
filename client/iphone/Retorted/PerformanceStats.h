//
//  PerformanceStats.h
//  Retorted
//
//  Created by B.J. Ray on 1/24/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sqlite3.h>

@class Statistic;

@interface PerformanceStats : NSObject {
	NSString *dbFilePath;
	BOOL isDBAvailable;
	
	//current instance...
	Statistic *parseStat;
	Statistic *downloadStat;
}

@property (nonatomic, retain) NSString *dbFilePath;
@property BOOL isDBAvailable;

@property (nonatomic, retain) Statistic *parseStat;
@property (nonatomic, retain) Statistic *downloadStat;

- (void)saveCurrentStatistics;
- (double)meanParseTime;
- (double)meanParseTimeForUrl:(NSString *) aUrl;
- (double)meanDownloadTime;
- (double)meanDownloadTimeForUrl:(NSString *)aUrl;
- (double)meanTotalTime;
- (double)meanTotalTimeForUrl:(NSString *)aUrl;
- (NSUInteger)totalRecordCount;
- (NSUInteger)totalRecordCountForUrl:(NSString *)aUrl;
- (NSUInteger)meanByteCount;
- (NSUInteger)meanByteCountByUrl:(NSString *)aUrl;

- (void)cleanupDBConnection;	//optional clean up method. This is called automatically when the class's dealloc method is invoked.
- (BOOL)resetPerformanceStatsDatabase;

@end
