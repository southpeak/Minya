//
//  FKFlickrAPIMethod.h
//  FlickrKit
//
//  Created by David Casserly on 10/06/2013.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//

#import "FKDataTypes.h"

@protocol FKFlickrAPIMethod <NSObject>

/**
 *  The name of the method used by flickr
 *
 *  @return The name of the method used by flickr
 */
- (NSString *) name;

/**
 *  All the args that you have injected into the object into a dictionary
 *
 *  @return dictionary of args
 */
- (NSDictionary *) args;

/**
 *  Are the args passed valid?
 *
 *  @param error the error if the args are not valie
 *
 *  @return true if they are valid
 */
- (BOOL) isValid:(NSError **)error;

/**
 *  Get a readable description for the error code passed
 *
 *  @param error the error code you want info of
 *
 *  @return a displayable error
 */
- (NSString *) descriptionForError:(NSInteger)error;

/**
 *  Does this method require you to be logged in . i.e. need a login?
 *
 *  @return true if you need to login first
 */
- (BOOL) needsLogin;

/**
 *  Do you need to sign this request
 *
 *  @return true if you need to sign this request
 */
- (BOOL) needsSigning;

/**
 *  Permissions needed for this request
 *
 *  @return the FkPermission you need to access this request
 */
- (FKPermission) requiredPerms;

@optional

/**
 *  Set the page to be access on this method. This is used when loading pages of data
 *
 *  @param page the page you want to access
 */
- (void) setPage:(NSString *)page;

@end
