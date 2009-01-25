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

static sqlite3_stmt *count_statement = NULL;
static sqlite3_stmt *mean_download_time_statement = NULL;
static sqlite3_stmt *mean_parse_time_statement = NULL;
static sqlite3_stmt *mean_download_and_parse_time_statement = NULL;
static sqlite3_stmt *reset_statement = NULL;

//private methods and classes
@interface PerformanceStats()
-(BOOL)prepareDataBase;
@end

@implementation PerformanceStats
@synthesize dbFilePath, isDBAvailable;
@synthesize parserStat, downloadStat;

- (id)init {
	if (![super init]) {
		return nil;
	}
	self.isDBAvailable = [self prepareDataBase];
	
	return self;
}

- (void)dealloc {
	self.dbFilePath = nil;
	self.parserStat = nil;
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
	return YES;
}

- (sqlite3 *)getOpenDB {
	sqlite3 *db;
	int dbrc = sqlite3_open ([self.dbFilePath UTF8String], &db);
	if (dbrc) {
		return nil;
	}
	
	return db;
}

- (void)cleanupDBConnection:(sqlite3 *)db {
	sqlite3_close(db);
}

- (void)resetPerformanceStatsDatabase {
    sqlite3 *db;
	int dbrc = sqlite3_open ([self.dbFilePath UTF8String], &db);
	
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
    }
    // Reset the query for the next use.
    sqlite3_reset(reset_statement);
}

#pragma mark -
#pragma mark Inserting Data
- (void)saveCurrentStatistics {
	
	double download = [self.downloadStat duration];
	double parse = [self.parserStat duration];
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
	
} 

#pragma mark -
#pragma mark Querying Data
- (void)calculateAverageForFullHistory {
	
}

- (double)meanParseTime {
	return [self meanParseTimeForUrl:nil];
}

// returns all entries in table and calculates average times for downloading, parsing, and total
- (double)meanParseTimeForUrl:(NSString *) aUrl {
	
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
	
    // Reset the query for the next use.
    sqlite3_reset(mean_parse_time_statement);
	return meanValue;
}

// returns all entries in table that match the url and calculates average times for downloading, parsing, and total
- (void)calculateAveragForUrl:(NSString *)url {
	
}

//returns an array of distinct URLs.
- (NSArray *)getDistinctListOfUrls {
	NSArray *distinctUrls = nil;
	
	return distinctUrls;
}




@end
