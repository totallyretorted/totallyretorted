//
//  PerformanceStats.m
//  Retorted
//
//  Created by B.J. Ray on 1/24/09.
//  Copyright 2009 Forward Echo, LLC. All rights reserved.
//



#import "PerformanceStats.h"
#import "Statistic.h"


NSString * const DATABASE_FILE_NAME = @"statistics.db";
NSString * const DATABASE_RESOURCE_NAME = @"statistics";
NSString * const DATABASE_RESOURCE_TYPE = @"db";
NSString * const TABLE_NAME = @"stats";

static sqlite3_stmt *reset_statement = NULL;
static sqlite3_stmt *mean_parse_time_statement = NULL;
static sqlite3_stmt *mean_download_time_statement = NULL;
static sqlite3_stmt *mean_total_time_statement = NULL;
static sqlite3_stmt *count_statement = NULL;
static sqlite3_stmt *mean_byte_count_statement = NULL;


//private methods and classes
@interface PerformanceStats()
- (BOOL)prepareDataBase;
- (void)cleanupDBConnection:(sqlite3 *)db;
- (sqlite3 *)getOpenDB;
@end

@implementation PerformanceStats
@synthesize dbFilePath, isDBAvailable;
@synthesize parseStat, downloadStat;

- (id)init {
	if (![super init]) {
		return nil;
	}
	self.isDBAvailable = [self prepareDataBase];
	
	NSLog(@"PerformanceStats: init");
	return self;
}

- (void)dealloc {
	[self cleanupDBConnection:[self getOpenDB]];
	self.dbFilePath = nil;
	self.parseStat = nil;
	self.downloadStat = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Configuration of Database
- (BOOL)prepareDataBase {
	NSLog (@"PerformanceStats: initializeDB");
	// look to see if DB is in known location (~/Documents/$DATABASE_FILE_NAME)
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
	self.dbFilePath = [documentFolderPath stringByAppendingPathComponent:DATABASE_FILE_NAME];



	if (! [[NSFileManager defaultManager] fileExistsAtPath: self.dbFilePath]) {
		
		// didn't find db, need to copy
		NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:DATABASE_RESOURCE_NAME ofType:DATABASE_RESOURCE_TYPE];
		if (backupDbPath == nil) {
			// couldn't find backup db to copy, bail
			return NO;
		} else {
			BOOL copiedBackupDb = [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:self.dbFilePath error:nil];
			if (! copiedBackupDb) {
				// copying backup db failed, bail
				return NO;
			}
		}
	}
	NSLog (@"PerformanceStats: initializeDB completed");
	return YES;
}

- (sqlite3 *)getOpenDB {
	sqlite3 *db;
	int dbrc = sqlite3_open ([self.dbFilePath UTF8String], &db);
	if (dbrc) {
		return NULL;
	}
	NSLog (@"PerformanceStats: getOpenDB");
	return db;
}

- (void)cleanupDBConnection {
	[self cleanupDBConnection:[self getOpenDB]];
}

//using NULL due to C code (i.e. not obj-c objects)
- (void)cleanupDBConnection:(sqlite3 *)db {
	NSLog (@"PerformanceStats: cleanupDBConnection");
	if (reset_statement != NULL) {
		sqlite3_finalize(reset_statement);
		reset_statement = NULL;
	}
	
	if (mean_parse_time_statement != NULL) {
		sqlite3_finalize(mean_parse_time_statement);
		mean_parse_time_statement = NULL;
	}
	
	if (mean_download_time_statement != NULL) {
		sqlite3_finalize(mean_download_time_statement);
		mean_download_time_statement = NULL;
	}
	
	if (mean_total_time_statement != NULL) {
		sqlite3_finalize(mean_total_time_statement);
		mean_total_time_statement = NULL;
	}
	
	if (count_statement != NULL) {
		sqlite3_finalize(count_statement);
		count_statement = NULL;
	}
	if (mean_byte_count_statement != NULL) {
		sqlite3_finalize(mean_byte_count_statement);
		mean_byte_count_statement = NULL;
	}
	
	if (db == NULL) {
		return;
	}
	sqlite3_close(db);
	db = NULL;
	NSLog (@"PerformanceStats: cleanupDBConnection complete");
}

- (BOOL)resetPerformanceStatsDatabase {
	NSLog (@"PerformanceStats: resetPerformanceStatsDatabase");
    sqlite3 *db;
	BOOL result = NO;
	int dbrc = sqlite3_open ([self.dbFilePath UTF8String], &db);
	if (dbrc) {
		NSLog(@"Failed to reset stats database");
		return NO;
	}
	//prepare reset statement...
	if (reset_statement == NULL) {
		const char *sql = "DELETE FROM stats";
		if (sqlite3_prepare_v2(db, sql, -1, &reset_statement, NULL) != SQLITE_OK) {
			NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
		}		
	}
		
    int success = sqlite3_step(reset_statement);
    if (success == SQLITE_ERROR) {
        NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
    } else {
		result = YES;
	}
    // Reset the query for the next use.

	NSLog (@"PerformanceStats: resetPerformanceStatsDatabase complete");
	sqlite3_reset(reset_statement);
	return result;
}

#pragma mark -
#pragma mark Inserting Data
- (void)saveCurrentStatistics {
	NSLog (@"PerformanceStats: saveCurrentStatistics");
	double download = [self.downloadStat duration];
	double parse = [self.parseStat duration];
	double totalDuration = download + parse;
	
	
	sqlite3 *db;
	int dbrc; // database return code
	dbrc = sqlite3_open ([self.dbFilePath UTF8String], &db);
	if (dbrc) {
		NSLog (@"PerformanceStats: couldn't open db:");
		return;
	}
	NSLog (@"PerformanceStats: opened db");
	
	// add stuff
	sqlite3_stmt *dbps; // database prepared statement
	NSString *insertStatementNS = [[NSString alloc] initWithFormat:
								   @"insert into \"%@\" (download_duration, parse_duration, total_duration, data_size, url) values (%f, %f, %f, %d, \"%@\")",
								   TABLE_NAME, download, parse, totalDuration, self.downloadStat.byteCount, self.downloadStat.url];

	NSLog(@"PerformanceStats: %@", insertStatementNS);
	
	const char *insertStatement = [insertStatementNS UTF8String];
	dbrc = sqlite3_prepare_v2 (db, insertStatement, -1, &dbps, NULL);
	dbrc = sqlite3_step (dbps);		//should return SQLITE_DONE
	
	if (dbrc == SQLITE_DONE) {
		NSLog(@"PerformanceStats: save went as planned.");
	}
	
	sqlite3_finalize (dbps);
	sqlite3_close(db);
	NSLog (@"PerformanceStats: saveCurrentStatistics complete");
} 

#pragma mark -
#pragma mark Querying Data

- (double)meanParseTime {
	return [self meanParseTimeForUrl:nil];
}

// returns all entries in table and calculates average times for downloading, parsing, and total
- (double)meanParseTimeForUrl:(NSString *) aUrl {
	NSLog (@"PerformanceStats: meanParseTimeForUrl");
	sqlite3 *db = [self getOpenDB];
	
	//parse times...
    if (mean_parse_time_statement == NULL) {
        static const char *sql = "SELECT AVG(parse_duration) FROM stats WHERE url = ifnull(?,url)";
        if (sqlite3_prepare_v2(db, sql, -1, &mean_parse_time_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
    }
	
	sqlite3_bind_text(mean_parse_time_statement, 1, aUrl, -1, SQLITE_TRANSIENT);
	int success = sqlite3_step(mean_parse_time_statement);
	double meanValue = 0.0;
	
	 if (success == SQLITE_ROW) {
		   meanValue = sqlite3_column_double(mean_parse_time_statement, 0);
	 } else {
		 NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
	 }
	
	NSLog (@"PerformanceStats: meanParseTimeForUrl complete");
	
    // Reset the query for the next use.
    sqlite3_reset(mean_parse_time_statement);
	return meanValue;
}

- (double)meanDownloadTime {
	return [self meanDownloadTimeForUrl:nil];
}

- (double)meanDownloadTimeForUrl:(NSString *)aUrl {
	NSLog (@"PerformanceStats: meanDownloadTimeForUrl");
	
	double downloadTime = 0.0;
	sqlite3 *db = [self getOpenDB];
	if (mean_download_time_statement == NULL) {
		static const char *sql = "SELECT AVG(download_duration) FROM stats WHERE url = ifnull(?,url)";
        if (sqlite3_prepare_v2(db, sql, -1, &mean_download_time_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
	}

	sqlite3_bind_text(mean_download_time_statement, 1, aUrl, -1, SQLITE_TRANSIENT);
	int success = sqlite3_step(mean_download_time_statement);
	
	if (success == SQLITE_ROW) {
		downloadTime = sqlite3_column_double(mean_download_time_statement, 0);
	} else {
		NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
	}
	
	NSLog (@"PerformanceStats: meanDownloadTimeForUrl complete");
	
    // Reset the query for the next use.
    sqlite3_reset(mean_download_time_statement);
	return downloadTime;
}

- (double)meanTotalTime {
	return [self meanTotalTimeForUrl:nil];
}

- (double)meanTotalTimeForUrl:(NSString *)aUrl {
	NSLog (@"PerformanceStats: meanTotalTimeForUrl");
	
	double totalTime = 0.0;
	sqlite3 *db = [self getOpenDB];
	if (mean_total_time_statement == NULL) {
		static const char *sql = "SELECT AVG(total_duration) FROM stats WHERE url = ifnull(?,url)";
        if (sqlite3_prepare_v2(db, sql, -1, &mean_total_time_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
	}
	
	sqlite3_bind_text(mean_total_time_statement, 1, aUrl, -1, SQLITE_TRANSIENT);
	int success = sqlite3_step(mean_total_time_statement);
	
	if (success == SQLITE_ROW) {
		totalTime = sqlite3_column_double(mean_total_time_statement, 0);
	} else {
		NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
	}
	
	NSLog (@"PerformanceStats: meanTotalTimeForUrl");
	
    // Reset the query for the next use.
    sqlite3_reset(mean_total_time_statement);
	return totalTime;
}

- (NSUInteger)totalRecordCount {
	return [self totalRecordCountForUrl:nil];
}

- (NSUInteger)totalRecordCountForUrl:(NSString *)aUrl {
	NSLog (@"PerformanceStats: totalRecordCountForUrl");
	
	NSUInteger rowCount = 0;
	sqlite3 *db = [self getOpenDB];
	if (count_statement == NULL) {
		static const char *sql = "SELECT COUNT(*) FROM stats WHERE url = ifnull(?,url)";
        if (sqlite3_prepare_v2(db, sql, -1, &count_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
	}
	
	sqlite3_bind_text(count_statement, 1, aUrl, -1, SQLITE_TRANSIENT);
	int success = sqlite3_step(count_statement);
	
	if (success == SQLITE_ROW) {
		rowCount = sqlite3_column_int(count_statement, 0);
	} else {
		NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
	}
	
	NSLog (@"PerformanceStats: totalRecordCountForUrl completed");
	
    // Reset the query for the next use.
    sqlite3_reset(count_statement);
	return rowCount;
}

- (NSUInteger)meanByteCount {
	return [self meanByteCountByUrl:nil];
}

- (NSUInteger)meanByteCountByUrl:(NSString *)aUrl {
	NSLog (@"PerformanceStats: meanByteCountByUrl");
	
	NSUInteger avgBytes = 0;
	sqlite3 *db = [self getOpenDB];
	if (mean_byte_count_statement == NULL) {
		static const char *sql = "SELECT AVG(data_size) FROM stats WHERE url = ifnull(?,url)";
        if (sqlite3_prepare_v2(db, sql, -1, &mean_byte_count_statement, NULL) != SQLITE_OK) {
            NSCAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(db));
        }
	}
	
	sqlite3_bind_text(mean_byte_count_statement, 1, aUrl, -1, SQLITE_TRANSIENT);
	int success = sqlite3_step(mean_byte_count_statement);
	
	if (success == SQLITE_ROW) {
		avgBytes = sqlite3_column_int(mean_byte_count_statement, 0);
	} else {
		NSCAssert1(0, @"Error: failed to execute query with message '%s'.", sqlite3_errmsg(db));
	}
	
	NSLog (@"PerformanceStats: meanTotalTimeForUrl");
	
    // Reset the query for the next use.
    sqlite3_reset(mean_byte_count_statement);
	return avgBytes;
}

//returns an array of distinct URLs.
- (NSArray *)getDistinctListOfUrls {
	NSArray *distinctUrls = nil;
	
	return distinctUrls;
}




@end
