expose( "The Roblox sandbox environment" , function ()
	
	local M	=	require "moses" ;
	
	local roblox_OS_Funcs	=	{ "time" , "difftime" , "date" } ;
	local Sandboxed_OS_Lib	=	M.choose( os , unpack( roblox_OS_Funcs ) );
	os						=	Sandboxed_OS_Lib ;
	
	-- local osk	=	M.keys( os );
	-- local osf	=	M.functions( os , true );

end )
