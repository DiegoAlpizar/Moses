local M		=	require "moses" ;
local Say	=	require "say"


local function  property ( state , arguments )
	
	local tbl		=	arguments[ 1 ] ;
	local property	=	arguments[ 2 ] ;

	if type( tbl ) ~= "table"  or  #arguments ~= 2
	then
		return  false ;
	end

	return  M.has( tbl , property );

end


local function  properties ( state , arguments )
	
	local tbl				=	arguments[ 1 ] ;
	local properties		=	M.rest( arguments , 2 );
	local absentProperties	=	{ } ;

	for _ , currentProperty in ipairs( properties )
	do
		if not M.has( tbl , currentProperty )
		then
			table.insert( absentProperties , currentProperty );
		end
	end

	return  #absentProperties == 0 ;

end


-- Need to be a separate assert ?
local function  hasNo_Properties ( state , arguments )
	
	local tbl				=	arguments[ 1 ] ;
	local properties		=	M.rest( arguments , 2 ) ;
	local presentProperties	=	{ } ;

	for _ , currentProperty in ipairs( properties )
	do
		if M.has( tbl , currentProperty )
		then
			table.insert( presentProperties , currentProperty );
		end
	end

	return  #presentProperties == 0 ;

end


local function  registerAssert ( Assert )
	
	local assertPositive	=	"assertion." .. Assert.name .. ".positive" ;
	local assertNegative	=	"assertion." .. Assert.name .. ".negative" ;

	Say: set( assertPositive , Assert.positiveMsg );
	Say: set( assertNegative , Assert.negativeMsg );

	assert: register( "assertion" , Assert.name , Assert.func , assertPositive , assertNegative );

end


local function  registerAsserts ( asserts )
	
	M.forEachi( asserts , registerAssert );

end


local asserts	=	{
	
	{
		name		=	"property" ,
		positiveMsg	=	"Expected %s \nto have property: %s" ,
		negativeMsg	=	"Expected %s \nto not have property: %s" ,
		func		=	property
	} ,
	{
		name		=	"properties" ,
		positiveMsg	=	"Expected %s \nto have properties: %s" ,
		negativeMsg	=	"Expected $s \nto not have properties: %s" ,
		func		=	properties
	} ,
	{
		name		=	"hasNo_Properties" ,
		positiveMsg	=	"Expected %s \nto not have properties: %s" ,
		negativeMsg	=	"Expected $s \nto have properties: %s" ,
		func		=	hasNo_Properties
	}

};


registerAsserts( asserts );


describe( "Test global environment" , function ()
	
	local roblox_OS_Funcs	=	{ "time" , "difftime" , "date" } ;

	it( "os library has only Roblox sandbox functions" , function ()
		
		assert.has.properties( os , unpack( roblox_OS_Funcs ) );

	end );

	it( "Test has property" , function ()
		
		assert.has.property( os , "time" );
		assert.has.property( os , "difftime" );

	end );

	it( "Test has_no.property" , function ()
		
		assert.has_no.property( os , "clock" );
		assert.has_no.property( os , "exit" );

	end );

	it( "Test hasNo_Properties" , function ()
		
		assert.hasNo_Properties( os , "clock" , "bar" , "exit" , "foo" );
		assert.hasNo_Properties( os , "foo" , "LALLA" , "exit" , "bar" , "time" );

	end );

end );
