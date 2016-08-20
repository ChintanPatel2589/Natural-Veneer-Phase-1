//
//  api_Database.m
//  APITesting
//
//  Created by Taimur Mushtaq on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "api_Database.h"

@implementation api_Database

@synthesize  databasePath, databaseName, dataArray;

+(NSString *) getDatabasePath:(NSString *)dbName
{
    // Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
   // NSLog(@"path:%@",[documentsDir stringByAppendingPathComponent:dbName]);
    return [documentsDir stringByAppendingPathComponent:dbName];
}

+(void)checkAndCreateDB:(NSString *)dbName dbPath:(NSString *)dbPath
{
    BOOL success;
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:dbPath];
	if(success) return;
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
	[fileManager copyItemAtPath:databasePathFromApp toPath:dbPath error:nil];
}

+(NSMutableArray *) selectDataFromDatabase:(NSString *)dbname query:(NSString *)query
{
    NSMutableArray *mainArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
    //NSLog(@"%@", query);
    //NSMutableArray *subArray = [[NSMutableArray alloc] init];
    
    NSString *dbPath = [api_Database getDatabasePath:dbname];
    [api_Database checkAndCreateDB:dbname dbPath:dbPath];
  //  NSLog(@"dbPath :%@", dbPath);
    sqlite3 *database;
    NSString * myRowData=[[NSString alloc] initWithFormat:@"%@",@""];
    
	const char *sqlStatement;
    int columnCounter=0;
	// Open the database from the users filessytem
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) 
    {
        sqlStatement=[[NSString stringWithFormat:@"%@",query ] UTF8String];
        
		sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
        {
            columnCounter=sqlite3_column_count(compiledStatement);
            
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) 
            {
                for(int i=0;i<columnCounter;i++)
                {
                    //NSString * test = @"Test";
                    
                    NSString * test = ((char *)sqlite3_column_text(compiledStatement, i))  ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)] : @"";
                    NSString * colName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
                    myRowData = [myRowData stringByAppendingString:test];
                    
                    if(i != columnCounter )
                    {
                        [subDic setObject:myRowData forKey:colName];
                        myRowData = [[NSString alloc] initWithFormat:@""];
                    }
                }
                
                [mainArray addObject:subDic];
                subDic = nil;
                subDic = [[NSMutableDictionary alloc] init];
                
			}
            
		}
		
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database);
    return mainArray;
    
}

#pragma ALL DB METHODS FOR PART SECTION - by Tushar Navadiya

+(NSMutableDictionary *) selectSingleDataFromDatabase:(NSString *)dbname query:(NSString *)query
{
    NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
    //NSLog(@"%@", query);
    //NSMutableArray *subArray = [[NSMutableArray alloc] init];
    
    NSString *dbPath = [api_Database getDatabasePath:dbname];
    [api_Database checkAndCreateDB:dbname dbPath:dbPath];
    
    sqlite3 *database;
    NSString * myRowData=[[NSString alloc] initWithFormat:@"%@",@""];
    
	const char *sqlStatement;
    int columnCounter=0;
	// Open the database from the users filessytem
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        sqlStatement=[[NSString stringWithFormat:@"%@",query ] UTF8String];
        
		sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            columnCounter=sqlite3_column_count(compiledStatement);
            
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                for(int i=0;i<columnCounter;i++)
                {
                    //NSString * test = @"Test";
                    
                    NSString * test = ((char *)sqlite3_column_text(compiledStatement, i))  ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)] : @"";
                    NSString * colName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement, i)];
                    myRowData = [myRowData stringByAppendingString:test];
                    
                    if(i != columnCounter )
                    {
                        [subDic setObject:myRowData forKey:colName];
                        myRowData = [[NSString alloc] initWithFormat:@""];
                    }
                }
                
			}
            
		}
		
		sqlite3_finalize(compiledStatement);
	}
    
	sqlite3_close(database);
    return subDic;
    
}

#pragma END by Tushar Navadiya

+(BOOL)genericQueryforDatabase:(NSString *)dbname query:(NSString *)query
{
    //NSLog(@"%@",query);
    NSString *dbPath = [api_Database getDatabasePath:dbname];
    
    [api_Database checkAndCreateDB:dbname dbPath:dbPath];
    
    BOOL resultCheck = false;
    
    sqlite3 *database;
    
	const char *sqlStatement;
    
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
        sqlStatement=[[NSString stringWithFormat:@"%@",query ] UTF8String];
        
		sqlite3_stmt *compiledStatement;
		
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) 
        {
            if(sqlite3_step(compiledStatement) == SQLITE_OK) 
            {
                resultCheck = false;
                
			}else
                
            {
                resultCheck = true;
            }
        }
        
		sqlite3_finalize(compiledStatement);
	}

	sqlite3_close(database);
    return resultCheck;
    
}

+(void) InsertDatabase:(NSString*) queryString {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString* databasePath = [documentsDir stringByAppendingPathComponent:@"db.sqlite"];
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(!success) {
        // If not then proceed to copy the database from the application to the users filesystem
        
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
        
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    
    
    sqlite3 *database ;
    //NSString* queryString = @"UPDATE signupinfo SET status = '1'" ;
    // Open the database from the users filessytem
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    {
        const char *sqlStmt=[queryString UTF8String];
        sqlite3_stmt *cmp_sqlStmt=nil;
        // preparing for execution of statement.
        if(sqlite3_prepare_v2(database, sqlStmt, -1, &cmp_sqlStmt, NULL)==SQLITE_OK)
            sqlite3_step(cmp_sqlStmt);
        //Reset the add statement.
        sqlite3_reset(cmp_sqlStmt);
    }
    sqlite3_close(database);
}


+(NSMutableArray*) GetDataAddressAcessRightInfo:(NSString*) queryString {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString* databasePath = [documentsDir stringByAppendingPathComponent:@"db.sqlite"];
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(!success) {
        // If not then proceed to copy the database from the application to the users filesystem
        
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
        
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    NSMutableArray* userInfo ;
    userInfo = [[NSMutableArray alloc] init] ;
    // Execute the "checkAndCreateDatabase" function
    sqlite3 *database ;
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Setup the SQL Statement and compile it for faster access
        const char *sqlStatement = [queryString UTF8String] ;
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString* statusStr = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 0)];
                [userInfo addObject:statusStr] ;
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LangColumn"] isEqualToString:@"language1"]) {
                    NSString* statusStr1 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 1)];
                    [userInfo addObject:statusStr1] ;
                }else{
                    NSString* statusStr1 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 15)];
                    [userInfo addObject:statusStr1] ;
                }
                
                NSString* statusStr2 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 2)];
                [userInfo addObject:statusStr2] ;
                NSString* statusStr3 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 3)];
                [userInfo addObject:statusStr3] ;
                NSString* statusStr4 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 4)];
                [userInfo addObject:statusStr4] ;
                NSString* statusStr5 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 5)];
                [userInfo addObject:statusStr5] ;
                NSString* statusStr6 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 6)];
                [userInfo addObject:statusStr6] ;
                NSString* statusStr7 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 7)];
                [userInfo addObject:statusStr7] ;
                NSString* statusStr8 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 8)];
                [userInfo addObject:statusStr8] ;
                NSString* statusStr9 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 9)];
                [userInfo addObject:statusStr9] ;
                NSString* statusStr10 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 10)];
                [userInfo addObject:statusStr10] ;
                NSString* statusStr11 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 11)];
                [userInfo addObject:statusStr11] ;
                NSString* statusStr12 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 12)];
                [userInfo addObject:statusStr12] ;
                NSString* statusStr13 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 13)];
                [userInfo addObject:statusStr13] ;
                NSString* statusStr14 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 14)];
                [userInfo addObject:statusStr14] ;
                /*NSString* statusStr15 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 15)];
                [userInfo addObject:statusStr15] ;*/

            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return userInfo ;
    
}

+(NSMutableArray*) GetSalaryBankSalesPretendingInfo:(NSString*) queryString {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString* databasePath = [documentsDir stringByAppendingPathComponent:@"db.sqlite"];
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(!success) {
        // If not then proceed to copy the database from the application to the users filesystem
        
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
        
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    NSMutableArray* userInfo ;
    userInfo = [[NSMutableArray alloc] init] ;
    // Execute the "checkAndCreateDatabase" function
    sqlite3 *database ;
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Setup the SQL Statement and compile it for faster access
        const char *sqlStatement = [queryString UTF8String] ;
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString* statusStr = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 0)];
                [userInfo addObject:statusStr] ;
                NSString* statusStr1 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 1)];
                [userInfo addObject:statusStr1] ;
                NSString* statusStr2 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 2)];
                [userInfo addObject:statusStr2] ;
                NSString* statusStr3 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 3)];
                [userInfo addObject:statusStr3] ;
                NSString* statusStr4 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 4)];
                [userInfo addObject:statusStr4] ;
                NSString* statusStr5 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 5)];
                [userInfo addObject:statusStr5] ;
                NSString* statusStr6 = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 6)];
                [userInfo addObject:statusStr6] ;
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    return userInfo ;
}

+(NSMutableArray*)  GetCredentials:(NSString*) queryString {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString* databasePath = [documentsDir stringByAppendingPathComponent:@"db.sqlite"];
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:databasePath];
    
    // If the database already exists then return without doing anything
    if(!success) {
        // If not then proceed to copy the database from the application to the users filesystem
        
        // Get the path to the database in the application package
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
        
        // Copy the database from the package to the users filesystem
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    NSMutableArray* userInfo ;
    userInfo = [[NSMutableArray alloc] init] ;
    // Execute the "checkAndCreateDatabase" function
    sqlite3 *database ;
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Setup the SQL Statement and compile it for faster access
        const char *sqlStatement = [queryString UTF8String] ;
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                NSString* statusStr = [self  NullSafeValue:(char *)sqlite3_column_text(compiledStatement, 0)];
                [userInfo addObject:statusStr] ;
            }
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
    return userInfo ;
    
}
+(NSString *)getDocumentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
+(NSString *)NullSafeValue:(const char *)val{
    if (val == nil) {
        return @"";
    }else{
        return [NSString stringWithUTF8String:val];
    }
}

@end
