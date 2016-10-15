//
//  MIStorage.h
//  MinyaDemo
//
//  Created by Konka on 2016/9/28.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Block type

typedef void (^MIStorageCompletionBlock)(id data);

#pragma mark - MIStorage Protocol

/**
 *  MIStorage Protocol
 *
 *  This protocol declares some methods that you can use to operate local data storage,
 *  such as NSUserDefault, plist, sqlite, and so on.
 *
 *  Just like `MIService`, we suggest that you define a storage class for a special data storage.
 *  We declare three type methods: read, write and clear. Some methods take a `parameters` parameter,
 *  which is used to contain some value that helps you to operate local data more accurate.
 *
 *  And you can see that we return data by block but not returning value. 
 *  We think that reading data task may spend to much time and you want to execute it asynchronously,
 *  so we provide an unified approach to return data.
 *
 *  All the methods are optional, you can implement the methods you need in the subclass of 
 *  `MIStorage` class which has conformed the `MIStorage` protocol.
 *
 */
@protocol MIStorage <NSObject>

@optional

#pragma mark - Read Data

- (void)readDataWithCompeltion:(MIStorageCompletionBlock _Nullable)completion;
- (void)readDataWithParameters:(NSDictionary * _Nullable)parameters completion:(MIStorageCompletionBlock _Nullable)completion;

#pragma mark - Write Data

- (void)writeData:(id _Nonnull)data;
- (void)writeData:(id _Nonnull)data completion:(MIStorageCompletionBlock _Nullable)completion;
- (void)writeData:(id _Nonnull)data withParameters:(NSDictionary<NSString *, id> * _Nullable)parameters completion:(MIStorageCompletionBlock _Nullable)completion;

#pragma mark - Clear

- (void)clear;
- (void)clearWithCompletion:(MIStorageCompletionBlock _Nullable)completion;
- (void)clearWithParameters:(NSDictionary<NSString *, id> * _Nullable)parameters completion:(MIStorageCompletionBlock _Nullable)completion;

@end

#pragma mark - MIStorage Class

/**
 *  MIStorage class
 *
 *  The base class for storage class. This class conforms to the `MIStorage` protocol by default.
 *  However, this class does not implement any method of the `MIStorage` protocol. You should
 *  implement the methods you need in the subclass.
 */
@interface MIStorage : NSObject <MIStorage>

/**
 *  Create a `MIStorage` instance with storage class name.
 *
 *  @prama storageName  storage name, the class must conform to `MIStorage` protocol and be the 
 *                      subclass of `MIStorage` class.
 *
 *  @return If there exist a MIStorage's subclass with then storageName, return an instance
 *          of the class; if not, return nil.
 *
 */
+ (id<MIStorage> _Nullable)storageWithName:(NSString * _Nonnull)storageName;

@end

NS_ASSUME_NONNULL_END
