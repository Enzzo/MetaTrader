/*
Copyright 2021 FXcoder

This file is part of VP.

VP is free software: you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

VP is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along with VP. If not, see
http://www.gnu.org/licenses/.
*/

// Errors (2021-05-10). © FXcoder

#property strict

#include "../type/uncopyable.mqh"
#include "math.mqh"

// not defined constants (bug):
#ifndef __MQL4__
	#ifndef ERR_FTP_CLOSED
		#define ERR_FTP_CLOSED 4524

		#define ERR_DATABASE_INTERNAL_5120 5120
		#define ERR_DATABASE_INTERRUPT 5609
		#define ERR_DATABASE_NOTFOUND 5612
		#define ERR_DATABASE_EMPTY 5616
		#define ERR_DATABASE_NOLFS 5622
		#define ERR_DATABASE_FORMAT 5624
		#define ERR_DATABASE_INTERNAL_5602 5602
	#endif
#endif


class CBErrorUtil: public CBUncopyable
{
public:

	static int last(bool reset = true)
	{
		return(reset ? ::GetLastError() : _LastError);
	}

	static bool success(bool reset = true)
	{
#ifdef __MQL4__
		return(last(reset) == ERR_NO_ERROR);
#else
		return(last(reset) == ERR_SUCCESS);
#endif
	}

	static void reset()
	{
		::ResetLastError();
	}

	static string last_message(bool reset = true)
	{
		return(message(last(reset)));
	}

	static string message(int error_code)
	{
		switch(error_code)
		{
#ifdef __MQL4__

			case ERR_NO_ERROR:                          return("0: OK"); // No error returned
			case ERR_NO_RESULT:                         return("1: No error returned, but the result is unknown");
			case ERR_COMMON_ERROR:                      return("2: Common error");
			case ERR_INVALID_TRADE_PARAMETERS:          return("3: Invalid trade parameters");
			case ERR_SERVER_BUSY:                       return("4: Trade server is busy");
			case ERR_OLD_VERSION:                       return("5: Old version of the client terminal");
			case ERR_NO_CONNECTION:                     return("6: No connection with trade server");
			case ERR_NOT_ENOUGH_RIGHTS:                 return("7: Not enough rights");
			case ERR_TOO_FREQUENT_REQUESTS:             return("8: Too frequent requests");
			case ERR_MALFUNCTIONAL_TRADE:               return("9: Malfunctional trade operation");
			case ERR_ACCOUNT_DISABLED:                  return("64: Account disabled");
			case ERR_INVALID_ACCOUNT:                   return("65: Invalid account");
			case ERR_TRADE_TIMEOUT:                     return("128: Trade timeout");
			case ERR_INVALID_PRICE:                     return("129: Invalid price");
			case ERR_INVALID_STOPS:                     return("130: Invalid stops");
			case ERR_INVALID_TRADE_VOLUME:              return("131: Invalid trade volume");
			case ERR_MARKET_CLOSED:                     return("132: Market is closed");
			case ERR_TRADE_DISABLED:                    return("133: Trade is disabled");
			case ERR_NOT_ENOUGH_MONEY:                  return("134: Not enough money");
			case ERR_PRICE_CHANGED:                     return("135: Price changed");
			case ERR_OFF_QUOTES:                        return("136: Off quotes");
			case ERR_BROKER_BUSY:                       return("137: Broker is busy");
			case ERR_REQUOTE:                           return("138: Requote");
			case ERR_ORDER_LOCKED:                      return("139: Order is locked");
			case ERR_LONG_POSITIONS_ONLY_ALLOWED:       return("140: Buy orders only allowed");
			case ERR_TOO_MANY_REQUESTS:                 return("141: Too many requests");
			case ERR_TRADE_MODIFY_DENIED:               return("145: Modification denied because order is too close to market");
			case ERR_TRADE_CONTEXT_BUSY:                return("146: Trade context is busy");
			case ERR_TRADE_EXPIRATION_DENIED:           return("147: Expirations are denied by broker");
			case ERR_TRADE_TOO_MANY_ORDERS:             return("148: The amount of open and pending orders has reached the limit set by the broker");
			case ERR_TRADE_HEDGE_PROHIBITED:            return("149: An attempt to open an order opposite to the existing one when hedging is disabled");
			case ERR_TRADE_PROHIBITED_BY_FIFO:          return("150: An attempt to close an order contravening the FIFO rule");
			case ERR_NO_MQLERROR:                       return("4000: No error returned");
			case ERR_WRONG_FUNCTION_POINTER:            return("4001: Wrong function pointer");
			case ERR_ARRAY_INDEX_OUT_OF_RANGE:          return("4002: Array index is out of range");
			case ERR_NO_MEMORY_FOR_CALL_STACK:          return("4003: No memory for function call stack");
			case ERR_RECURSIVE_STACK_OVERFLOW:          return("4004: Recursive stack overflow");
			case ERR_NOT_ENOUGH_STACK_FOR_PARAM:        return("4005: Not enough stack for parameter");
			case ERR_NO_MEMORY_FOR_PARAM_STRING:        return("4006: No memory for parameter string");
			case ERR_NO_MEMORY_FOR_TEMP_STRING:         return("4007: No memory for temp string");
			case ERR_NOT_INITIALIZED_STRING:            return("4008: Not initialized string");
			case ERR_NOT_INITIALIZED_ARRAYSTRING:       return("4009: Not initialized string in array");
			case ERR_NO_MEMORY_FOR_ARRAYSTRING:         return("4010: No memory for array string");
			case ERR_TOO_LONG_STRING:                   return("4011: Too long string");
			case ERR_REMAINDER_FROM_ZERO_DIVIDE:        return("4012: Remainder from zero divide");
			case ERR_ZERO_DIVIDE:                       return("4013: Zero divide");
			case ERR_UNKNOWN_COMMAND:                   return("4014: Unknown command");
			case ERR_WRONG_JUMP:                        return("4015: Wrong jump (never generated error)");
			case ERR_NOT_INITIALIZED_ARRAY:             return("4016: Not initialized array");
			case ERR_DLL_CALLS_NOT_ALLOWED:             return("4017: DLL calls are not allowed");
			case ERR_CANNOT_LOAD_LIBRARY:               return("4018: Cannot load library");
			case ERR_CANNOT_CALL_FUNCTION:              return("4019: Cannot call function");
			case ERR_EXTERNAL_CALLS_NOT_ALLOWED:        return("4020: Expert function calls are not allowed");
			case ERR_NO_MEMORY_FOR_RETURNED_STR:        return("4021: Not enough memory for temp string returned from function");
			case ERR_SYSTEM_BUSY:                       return("4022: System is busy (never generated error)");
			case ERR_DLLFUNC_CRITICALERROR:             return("4023: DLL-function call critical error");
			case ERR_INTERNAL_ERROR:                    return("4024: Internal error");
			case ERR_OUT_OF_MEMORY:                     return("4025: Out of memory");
			case ERR_INVALID_POINTER:                   return("4026: Invalid pointer");
			case ERR_FORMAT_TOO_MANY_FORMATTERS:        return("4027: Too many formatters in the format function");
			case ERR_FORMAT_TOO_MANY_PARAMETERS:        return("4028: Parameters count exceeds formatters count");
			case ERR_ARRAY_INVALID:                     return("4029: Invalid array");
			case ERR_CHART_NOREPLY:                     return("4030: No reply from chart");
			case ERR_INVALID_FUNCTION_PARAMSCNT:        return("4050: Invalid function parameters count");
			case ERR_INVALID_FUNCTION_PARAMVALUE:       return("4051: Invalid function parameter value");
			case ERR_STRING_FUNCTION_INTERNAL:          return("4052: String function internal error");
			case ERR_SOME_ARRAY_ERROR:                  return("4053: Some array error");
			case ERR_INCORRECT_SERIESARRAY_USING:       return("4054: Incorrect series array using");
			case ERR_CUSTOM_INDICATOR_ERROR:            return("4055: Custom indicator error");
			case ERR_INCOMPATIBLE_ARRAYS:               return("4056: Arrays are incompatible");
			case ERR_GLOBAL_VARIABLES_PROCESSING:       return("4057: Global variables processing error");
			case ERR_GLOBAL_VARIABLE_NOT_FOUND:         return("4058: Global variable not found");
			case ERR_FUNC_NOT_ALLOWED_IN_TESTING:       return("4059: Function is not allowed in testing mode");
			case ERR_FUNCTION_NOT_CONFIRMED:            return("4060: Function is not allowed for call");
			case ERR_SEND_MAIL_ERROR:                   return("4061: Send mail error");
			case ERR_STRING_PARAMETER_EXPECTED:         return("4062: String parameter expected");
			case ERR_INTEGER_PARAMETER_EXPECTED:        return("4063: Integer parameter expected");
			case ERR_DOUBLE_PARAMETER_EXPECTED:         return("4064: Double parameter expected");
			case ERR_ARRAY_AS_PARAMETER_EXPECTED:       return("4065: Array as parameter expected");
			case ERR_HISTORY_WILL_UPDATED:              return("4066: Requested history data is in updating state");
			case ERR_TRADE_ERROR:                       return("4067: Internal trade error");
			case ERR_RESOURCE_NOT_FOUND:                return("4068: Resource not found");
			case ERR_RESOURCE_NOT_SUPPORTED:            return("4069: Resource not supported");
			case ERR_RESOURCE_DUPLICATED:               return("4070: Duplicate resource");
			case ERR_INDICATOR_CANNOT_INIT:             return("4071: Custom indicator cannot initialize");
			case ERR_INDICATOR_CANNOT_LOAD:             return("4072: Cannot load custom indicator");
			case ERR_NO_HISTORY_DATA:                   return("4073: No history data");
			case ERR_NO_MEMORY_FOR_HISTORY:             return("4074: No memory for history data");
			case ERR_NO_MEMORY_FOR_INDICATOR:           return("4075: Not enough memory for indicator calculation");
			case ERR_END_OF_FILE:                       return("4099: End of file");
			case ERR_SOME_FILE_ERROR:                   return("4100: Some file error");
			case ERR_WRONG_FILE_NAME:                   return("4101: Wrong file name");
			case ERR_TOO_MANY_OPENED_FILES:             return("4102: Too many opened files");
			case ERR_CANNOT_OPEN_FILE:                  return("4103: Cannot open file");
			case ERR_INCOMPATIBLE_FILEACCESS:           return("4104: Incompatible access to a file");
			case ERR_NO_ORDER_SELECTED:                 return("4105: No order selected");
			case ERR_UNKNOWN_SYMBOL:                    return("4106: Unknown symbol");
			case ERR_INVALID_PRICE_PARAM:               return("4107: Invalid price");
			case ERR_INVALID_TICKET:                    return("4108: Invalid ticket");
			case ERR_TRADE_NOT_ALLOWED:                 return("4109: Trade is not allowed. Enable checkbox \"Allow live trading\" in the Expert Advisor properties");
			case ERR_LONGS_NOT_ALLOWED:                 return("4110: Longs are not allowed. Check the Expert Advisor properties");
			case ERR_SHORTS_NOT_ALLOWED:                return("4111: Shorts are not allowed. Check the Expert Advisor properties");
			case ERR_TRADE_EXPERT_DISABLED_BY_SERVER :  return("4112: Automated trading by Expert Advisors/Scripts disabled by trade server");
			case ERR_OBJECT_ALREADY_EXISTS:             return("4200: Object already exists");
			case ERR_UNKNOWN_OBJECT_PROPERTY:           return("4201: Unknown object property");
			case ERR_OBJECT_DOES_NOT_EXIST:             return("4202: Object does not exist");
			case ERR_UNKNOWN_OBJECT_TYPE:               return("4203: Unknown object type");
			case ERR_NO_OBJECT_NAME:                    return("4204: No object name");
			case ERR_OBJECT_COORDINATES_ERROR:          return("4205: Object coordinates error");
			case ERR_NO_SPECIFIED_SUBWINDOW:            return("4206: No specified subwindow");
			case ERR_SOME_OBJECT_ERROR:                 return("4207: Graphical object error");
			case ERR_CHART_PROP_INVALID:                return("4210: Unknown chart property");
			case ERR_CHART_NOT_FOUND:                   return("4211: Chart not found");
			case ERR_CHARTWINDOW_NOT_FOUND:             return("4212: Chart subwindow not found");
			case ERR_CHARTINDICATOR_NOT_FOUND:          return("4213: Chart indicator not found");
			case ERR_SYMBOL_SELECT:                     return("4220: Symbol select error");
			case ERR_NOTIFICATION_ERROR:                return("4250: Notification error");
			case ERR_NOTIFICATION_PARAMETER:            return("4251: Notification parameter error");
			case ERR_NOTIFICATION_SETTINGS:             return("4252: Notifications disabled");
			case ERR_NOTIFICATION_TOO_FREQUENT:         return("4253: Notification send too frequent");
			case ERR_FTP_NOSERVER:                      return("4260: FTP server is not specified");
			case ERR_FTP_NOLOGIN :                      return("4261: FTP login is not specified");
			case ERR_FTP_CONNECT_FAILED :               return("4262: FTP connection failed");
			case ERR_FTP_CLOSED:                        return("4263: FTP connection closed");
			case ERR_FTP_CHANGEDIR:                     return("4264: FTP path not found on server");
			case ERR_FTP_FILE_ERROR:                    return("4265: File not found in the MQL4\\Files directory to send on FTP server");
			case ERR_FTP_ERROR:                         return("4266: Common error during FTP data transmission");
			case ERR_FILE_TOO_MANY_OPENED:              return("5001: Too many opened files");
			case ERR_FILE_WRONG_FILENAME:               return("5002: Wrong file name");
			case ERR_FILE_TOO_LONG_FILENAME:            return("5003: Too long file name");
			case ERR_FILE_CANNOT_OPEN:                  return("5004: Cannot open file");
			case ERR_FILE_BUFFER_ALLOCATION_ERROR:      return("5005: Text file buffer allocation error");
			case ERR_FILE_CANNOT_DELETE:                return("5006: Cannot delete file");
			case ERR_FILE_INVALID_HANDLE:               return("5007: Invalid file handle (file closed or was not opened)");
			case ERR_FILE_WRONG_HANDLE:                 return("5008: Wrong file handle (handle index is out of handle table)");
			case ERR_FILE_NOT_TOWRITE:                  return("5009: File must be opened with FILE_WRITE flag");
			case ERR_FILE_NOT_TOREAD:                   return("5010: File must be opened with FILE_READ flag");
			case ERR_FILE_NOT_BIN:                      return("5011: File must be opened with FILE_BIN flag");
			case ERR_FILE_NOT_TXT:                      return("5012: File must be opened with FILE_TXT flag");
			case ERR_FILE_NOT_TXTORCSV:                 return("5013: File must be opened with FILE_TXT or FILE_CSV flag");
			case ERR_FILE_NOT_CSV:                      return("5014: File must be opened with FILE_CSV flag");
			case ERR_FILE_READ_ERROR:                   return("5015: File read error");
			case ERR_FILE_WRITE_ERROR:                  return("5016: File write error");
			case ERR_FILE_BIN_STRINGSIZE:               return("5017: String size must be specified for binary file");
			case ERR_FILE_INCOMPATIBLE:                 return("5018: Incompatible file (for string arrays-TXT, for others-BIN)");
			case ERR_FILE_IS_DIRECTORY:                 return("5019: File is directory not file");
			case ERR_FILE_NOT_EXIST:                    return("5020: File does not exist");
			case ERR_FILE_CANNOT_REWRITE:               return("5021: File cannot be rewritten");
			case ERR_FILE_WRONG_DIRECTORYNAME:          return("5022: Wrong directory name");
			case ERR_FILE_DIRECTORY_NOT_EXIST:          return("5023: Directory does not exist");
			case ERR_FILE_NOT_DIRECTORY:                return("5024: Specified file is not directory");
			case ERR_FILE_CANNOT_DELETE_DIRECTORY:      return("5025: Cannot delete directory");
			case ERR_FILE_CANNOT_CLEAN_DIRECTORY:       return("5026: Cannot clean directory");
			case ERR_FILE_ARRAYRESIZE_ERROR:            return("5027: Array resize error");
			case ERR_FILE_STRINGRESIZE_ERROR:           return("5028: String resize error");
			case ERR_FILE_STRUCT_WITH_OBJECTS:          return("5029: Structure contains strings or dynamic arrays");
			case ERR_WEBREQUEST_INVALID_ADDRESS:        return("5200: Invalid URL");
			case ERR_WEBREQUEST_CONNECT_FAILED:         return("5201: Failed to connect to specified URL");
			case ERR_WEBREQUEST_TIMEOUT:                return("5202: Timeout exceeded");
			case ERR_WEBREQUEST_REQUEST_FAILED:         return("5203: HTTP request failed");

#else

			case ERR_SUCCESS:                        return("0: OK"); // The operation completed successfully
			case ERR_INTERNAL_ERROR:                 return("4001: Unexpected internal error");
			case ERR_WRONG_INTERNAL_PARAMETER:       return("4002: Wrong parameter in the inner call of the client terminal function");
			case ERR_INVALID_PARAMETER:              return("4003: Wrong parameter when calling the system function");
			case ERR_NOT_ENOUGH_MEMORY:              return("4004: Not enough memory to perform the system function");
			case ERR_STRUCT_WITHOBJECTS_ORCLASS:     return("4005: The structure contains objects of strings and/or dynamic arrays and/or structure of such objects and/or classes");
			case ERR_INVALID_ARRAY:                  return("4006: Array of a wrong type, wrong size, or a damaged object of a dynamic array");
			case ERR_ARRAY_RESIZE_ERROR:             return("4007: Not enough memory for the relocation of an array, or an attempt to change the size of a static array");
			case ERR_STRING_RESIZE_ERROR:            return("4008: Not enough memory for the relocation of string");
			case ERR_NOTINITIALIZED_STRING:          return("4009: Not initialized string");
			case ERR_INVALID_DATETIME:               return("4010: Invalid date and/or time");
			case ERR_ARRAY_BAD_SIZE:                 return("4011: Total amount of elements in the array cannot exceed 2147483647");
			case ERR_INVALID_POINTER:                return("4012: Wrong pointer");
			case ERR_INVALID_POINTER_TYPE:           return("4013: Wrong type of pointer");
			case ERR_FUNCTION_NOT_ALLOWED:           return("4014: Function is not allowed for call");
			case ERR_RESOURCE_NAME_DUPLICATED:       return("4015: The names of the dynamic and the static resource match");
			case ERR_RESOURCE_NOT_FOUND:             return("4016: Resource with this name has not been found in EX5");
			// case ERR_RESOURCE_UNSUPPOTED_TYPE:       return("4017: Unsupported resource type or its size exceeds 16 Mb");
			case ERR_RESOURCE_NAME_IS_TOO_LONG:      return("4018: The resource name exceeds 63 characters");
			case ERR_MATH_OVERFLOW:                  return("4019: Overflow occurred when calculating math function ");
			case ERR_SLEEP_ERROR:                    return("4020: Out of test end date after calling Sleep()");
			case ERR_PROGRAM_STOPPED:                return("4022: Test forcibly stopped from the outside. For example, optimization interrupted, visual testing window closed or testing agent stopped");
			// Charts
			case ERR_CHART_WRONG_ID:                 return("4101: Wrong chart ID");
			case ERR_CHART_NO_REPLY:                 return("4102: Chart does not respond");
			case ERR_CHART_NOT_FOUND:                return("4103: Chart not found");
			case ERR_CHART_NO_EXPERT:                return("4104: No Expert Advisor in the chart that could handle the event");
			case ERR_CHART_CANNOT_OPEN:              return("4105: Chart opening error");
			case ERR_CHART_CANNOT_CHANGE:            return("4106: Failed to change chart symbol and period");
			case ERR_CHART_WRONG_PARAMETER:          return("4107: Error value of the parameter for the function of working with charts");
			case ERR_CHART_CANNOT_CREATE_TIMER:      return("4108: Failed to create timer");
			case ERR_CHART_WRONG_PROPERTY:           return("4109: Wrong chart property ID");
			case ERR_CHART_SCREENSHOT_FAILED:        return("4110: Error creating screenshots");
			case ERR_CHART_NAVIGATE_FAILED:          return("4111: Error navigating through chart");
			case ERR_CHART_TEMPLATE_FAILED:          return("4112: Error applying template");
			case ERR_CHART_WINDOW_NOT_FOUND:         return("4113: Subwindow containing the indicator was not found");
			case ERR_CHART_INDICATOR_CANNOT_ADD:     return("4114: Error adding an indicator to chart");
			case ERR_CHART_INDICATOR_CANNOT_DEL:     return("4115: Error deleting an indicator from the chart");
			case ERR_CHART_INDICATOR_NOT_FOUND:      return("4116: Indicator not found on the specified chart");
			// Graphical Objects
			case ERR_OBJECT_ERROR:                   return("4201: Error working with a graphical object");
			case ERR_OBJECT_NOT_FOUND:               return("4202: Graphical object was not found");
			case ERR_OBJECT_WRONG_PROPERTY:          return("4203: Wrong ID of a graphical object property");
			case ERR_OBJECT_GETDATE_FAILED:          return("4204: Unable to get date corresponding to the value");
			case ERR_OBJECT_GETVALUE_FAILED:         return("4205: Unable to get value corresponding to the date");
			// MarketInfo
			case ERR_MARKET_UNKNOWN_SYMBOL:          return("4301: Unknown symbol");
			case ERR_MARKET_NOT_SELECTED:            return("4302: Symbol is not selected in MarketWatch");
			case ERR_MARKET_WRONG_PROPERTY:          return("4303: Wrong identifier of a symbol property");
			case ERR_MARKET_LASTTIME_UNKNOWN:        return("4304: Time of the last tick is not known (no ticks)");
			case ERR_MARKET_SELECT_ERROR:            return("4305: Error adding or deleting a symbol in MarketWatch");
			// History Access
			case ERR_HISTORY_NOT_FOUND:              return("4401: Requested history not found");
			case ERR_HISTORY_WRONG_PROPERTY:         return("4402: Wrong ID of the history property");
			case ERR_HISTORY_TIMEOUT:                return("4403: Exceeded history request timeout");
			case ERR_HISTORY_BARS_LIMIT:             return("4404: Number of requested bars limited by terminal settings");
			case ERR_HISTORY_LOAD_ERRORS:            return("4405: Multiple errors when loading history");
			case ERR_HISTORY_SMALL_BUFFER:           return("4407: Receiving array is too small to store all requested data");
			// Global_Variables
			case ERR_GLOBALVARIABLE_NOT_FOUND:       return("4501: Global variable of the client terminal is not found");
			case ERR_GLOBALVARIABLE_EXISTS:          return("4502: Global variable of the client terminal with the same name already exists");
			case ERR_GLOBALVARIABLE_NOT_MODIFIED:    return("4503: Global variables were not modified");
			case ERR_GLOBALVARIABLE_CANNOTREAD:      return("4504: Cannot read file with global variable values");
			case ERR_GLOBALVARIABLE_CANNOTWRITE:     return("4505: Cannot write file with global variable values");
			case ERR_MAIL_SEND_FAILED:               return("4510: Email sending failed");
			case ERR_PLAY_SOUND_FAILED :             return("4511: Sound playing failed");
			case ERR_MQL5_WRONG_PROPERTY :           return("4512: Wrong identifier of the program property");
			case ERR_TERMINAL_WRONG_PROPERTY:        return("4513: Wrong identifier of the terminal property");
			case ERR_FTP_SEND_FAILED:                return("4514: File sending via ftp failed");
			case ERR_NOTIFICATION_SEND_FAILED:       return("4515: Failed to send a notification");
			case ERR_NOTIFICATION_WRONG_PARAMETER:   return("4516: Invalid parameter for sending a notification – an empty string or NULL has been passed to the SendNotification() function");
			case ERR_NOTIFICATION_WRONG_SETTINGS:    return("4517: Wrong settings of notifications in the terminal (ID is not specified or permission is not set)");
			case ERR_NOTIFICATION_TOO_FREQUENT:      return("4518: Too frequent sending of notifications");
			case ERR_FTP_NOSERVER:                   return("4519: FTP server is not specified");
			case ERR_FTP_NOLOGIN:                    return("4520: FTP login is not specified");
			case ERR_FTP_FILE_ERROR:                 return("4521: File not found in the MQL5\\Files directory to send on FTP server");
			case ERR_FTP_CONNECT_FAILED:             return("4522: FTP connection failed");
			case ERR_FTP_CHANGEDIR:                  return("4523: FTP path not found on server");
			case ERR_FTP_CLOSED:                     return("4524: FTP connection closed");
			// Custom Indicator Buffers
			case ERR_BUFFERS_NO_MEMORY:              return("4601: Not enough memory for the distribution of indicator buffers");
			case ERR_BUFFERS_WRONG_INDEX:            return("4602: Wrong indicator buffer index");
			// Custom Indicator Properties
			case ERR_CUSTOM_WRONG_PROPERTY:          return("4603: Wrong ID of the custom indicator property");
			// Account
			case ERR_ACCOUNT_WRONG_PROPERTY:         return("4701: Wrong account property ID");
			case ERR_TRADE_WRONG_PROPERTY:           return("4751: Wrong trade property ID");
			case ERR_TRADE_DISABLED:                 return("4752: Trading by Expert Advisors prohibited");
			case ERR_TRADE_POSITION_NOT_FOUND:       return("4753: Position not found");
			case ERR_TRADE_ORDER_NOT_FOUND:          return("4754: Order not found");
			case ERR_TRADE_DEAL_NOT_FOUND:           return("4755: Deal not found");
			case ERR_TRADE_SEND_FAILED:              return("4756: Trade request sending failed");
			case ERR_TRADE_CALC_FAILED:              return("4758: Failed to calculate profit or margin");
			// Indicators
			case ERR_INDICATOR_UNKNOWN_SYMBOL:       return("4801: Unknown symbol");
			case ERR_INDICATOR_CANNOT_CREATE:        return("4802: Indicator cannot be created");
			case ERR_INDICATOR_NO_MEMORY:            return("4803: Not enough memory to add the indicator");
			case ERR_INDICATOR_CANNOT_APPLY:         return("4804: The indicator cannot be applied to another indicator");
			case ERR_INDICATOR_CANNOT_ADD:           return("4805: Error applying an indicator to chart");
			case ERR_INDICATOR_DATA_NOT_FOUND:       return("4806: Requested data not found");
			case ERR_INDICATOR_WRONG_HANDLE:         return("4807: Wrong indicator handle");
			case ERR_INDICATOR_WRONG_PARAMETERS:     return("4808: Wrong number of parameters when creating an indicator");
			case ERR_INDICATOR_PARAMETERS_MISSING:   return("4809: No parameters when creating an indicator");
			case ERR_INDICATOR_CUSTOM_NAME:          return("4810: The first parameter in the array must be the name of the custom indicator");
			case ERR_INDICATOR_PARAMETER_TYPE:       return("4811: Invalid parameter type in the array when creating an indicator");
			case ERR_INDICATOR_WRONG_INDEX:          return("4812: Wrong index of the requested indicator buffer");
			// Depth of Market
			case ERR_BOOKS_CANNOT_ADD:               return("4901: Depth Of Market can not be added");
			case ERR_BOOKS_CANNOT_DELETE:            return("4902: Depth Of Market can not be removed");
			case ERR_BOOKS_CANNOT_GET:               return("4903: The data from Depth Of Market can not be obtained");
			case ERR_BOOKS_CANNOT_SUBSCRIBE:         return("4904: Error in subscribing to receive new data from Depth Of Market");
			// File Operations
			case ERR_TOO_MANY_FILES:                 return("5001: More than 64 files cannot be opened at the same time");
			case ERR_WRONG_FILENAME:                 return("5002: Invalid file name");
			case ERR_TOO_LONG_FILENAME:              return("5003: Too long file name");
			case ERR_CANNOT_OPEN_FILE:               return("5004: File opening error");
			case ERR_FILE_CACHEBUFFER_ERROR:         return("5005: Not enough memory for cache to read");
			case ERR_CANNOT_DELETE_FILE:             return("5006: File deleting error");
			case ERR_INVALID_FILEHANDLE:             return("5007: A file with this handle was closed, or was not opening at all");
			case ERR_WRONG_FILEHANDLE:               return("5008: Wrong file handle");
			case ERR_FILE_NOTTOWRITE:                return("5009: The file must be opened for writing");
			case ERR_FILE_NOTTOREAD:                 return("5010: The file must be opened for reading");
			case ERR_FILE_NOTBIN:                    return("5011: The file must be opened as a binary one");
			case ERR_FILE_NOTTXT:                    return("5012: The file must be opened as a text");
			case ERR_FILE_NOTTXTORCSV:               return("5013: The file must be opened as a text or CSV");
			case ERR_FILE_NOTCSV:                    return("5014: The file must be opened as CSV");
			case ERR_FILE_READERROR:                 return("5015: File reading error");
			case ERR_FILE_BINSTRINGSIZE:             return("5016: String size must be specified, because the file is opened as binary");
			case ERR_INCOMPATIBLE_FILE:              return("5017: A text file must be for string arrays, for other arrays - binary");
			case ERR_FILE_IS_DIRECTORY:              return("5018: This is not a file, this is a directory");
			case ERR_FILE_NOT_EXIST:                 return("5019: File does not exist");
			case ERR_FILE_CANNOT_REWRITE:            return("5020: File can not be rewritten");
			case ERR_WRONG_DIRECTORYNAME:            return("5021: Wrong directory name");
			case ERR_DIRECTORY_NOT_EXIST:            return("5022: Directory does not exist");
			case ERR_FILE_ISNOT_DIRECTORY:           return("5023: This is a file, not a directory");
			case ERR_CANNOT_DELETE_DIRECTORY:        return("5024: The directory cannot be removed");
			case ERR_CANNOT_CLEAN_DIRECTORY:         return("5025: Failed to clear the directory (probably one or more files are blocked and removal operation failed)");
			case ERR_FILE_WRITEERROR:                return("5026: Failed to write a resource to a file");
			case ERR_FILE_ENDOFFILE:                 return("5027: Unable to read the next piece of data from a CSV file (FileReadString, FileReadNumber, FileReadDatetime, FileReadBool), since the end of file is reached");
			// String Casting
			case ERR_NO_STRING_DATE:                 return("5030: No date in the string");
			case ERR_WRONG_STRING_DATE:              return("5031: Wrong date in the string");
			case ERR_WRONG_STRING_TIME:              return("5032: Wrong time in the string");
			case ERR_STRING_TIME_ERROR:              return("5033: Error converting string to date");
			case ERR_STRING_OUT_OF_MEMORY:           return("5034: Not enough memory for the string");
			case ERR_STRING_SMALL_LEN:               return("5035: The string length is less than expected");
			case ERR_STRING_TOO_BIGNUMBER:           return("5036: Too large number, more than ULONG_MAX");
			case ERR_WRONG_FORMATSTRING:             return("5037: Invalid format string");
			case ERR_TOO_MANY_FORMATTERS:            return("5038: Amount of format specifiers more than the parameters");
			case ERR_TOO_MANY_PARAMETERS:            return("5039: Amount of parameters more than the format specifiers");
			case ERR_WRONG_STRING_PARAMETER:         return("5040: Damaged parameter of string type");
			case ERR_STRINGPOS_OUTOFRANGE:           return("5041: Position outside the string");
			case ERR_STRING_ZEROADDED:               return("5042: 0 added to the string end, a useless operation");
			case ERR_STRING_UNKNOWNTYPE:             return("5043: Unknown data type when converting to a string");
			case ERR_WRONG_STRING_OBJECT:            return("5044: Damaged string object");
			// Operations with Arrays
			case ERR_INCOMPATIBLE_ARRAYS:            return("5050: Copying incompatible arrays. String array can be copied only to a string array, and a numeric array - in numeric array only");
			case ERR_SMALL_ASSERIES_ARRAY:           return("5051: The receiving array is declared as AS_SERIES, and it is of insufficient size");
			case ERR_SMALL_ARRAY:                    return("5052: Too small array, the starting position is outside the array");
			case ERR_ZEROSIZE_ARRAY:                 return("5053: An array of zero length");
			case ERR_NUMBER_ARRAYS_ONLY:             return("5054: Must be a numeric array");
			case ERR_ONEDIM_ARRAYS_ONLY:             return("5055: Must be a one-dimensional array");
			case ERR_SERIES_ARRAY:                   return("5056: Timeseries cannot be used");
			case ERR_DOUBLE_ARRAY_ONLY:              return("5057: Must be an array of type double");
			case ERR_FLOAT_ARRAY_ONLY:               return("5058: Must be an array of type float");
			case ERR_LONG_ARRAY_ONLY:                return("5059: Must be an array of type long");
			case ERR_INT_ARRAY_ONLY:                 return("5060: Must be an array of type int");
			case ERR_SHORT_ARRAY_ONLY:               return("5061: Must be an array of type short");
			case ERR_CHAR_ARRAY_ONLY:                return("5062: Must be an array of type char");
			case ERR_STRING_ARRAY_ONLY:              return("5063: String array only");
			// Operations with OpenCL
			case ERR_OPENCL_NOT_SUPPORTED:           return("5100: OpenCL functions are not supported on this computer");
			case ERR_OPENCL_INTERNAL:                return("5101: Internal error occurred when running OpenCL");
			case ERR_OPENCL_INVALID_HANDLE:          return("5102: Invalid OpenCL handle");
			case ERR_OPENCL_CONTEXT_CREATE:          return("5103: Error creating the OpenCL context");
			case ERR_OPENCL_QUEUE_CREATE:            return("5104: Failed to create a run queue in OpenCL");
			case ERR_OPENCL_PROGRAM_CREATE :         return("5105: Error occurred when compiling an OpenCL program");
			case ERR_OPENCL_TOO_LONG_KERNEL_NAME:    return("5106: Too long kernel name (OpenCL kernel)");
			case ERR_OPENCL_KERNEL_CREATE :          return("5107: Error creating an OpenCL kernel");
			case ERR_OPENCL_SET_KERNEL_PARAMETER:    return("5108: Error occurred when setting parameters for the OpenCL kernel");
			case ERR_OPENCL_EXECUTE:                 return("5109: OpenCL program runtime error");
			case ERR_OPENCL_WRONG_BUFFER_SIZE:       return("5110: Invalid size of the OpenCL buffer");
			case ERR_OPENCL_WRONG_BUFFER_OFFSET:     return("5111: Invalid offset in the OpenCL buffer");
			case ERR_OPENCL_BUFFER_CREATE:           return("5112: Failed to create an OpenCL buffer");
			case ERR_OPENCL_TOO_MANY_OBJECTS:        return("5113: Too many OpenCL objects");
			case ERR_OPENCL_SELECTDEVICE:            return("5114: OpenCL device selection error");
			// Working with databases
			case ERR_DATABASE_INTERNAL_5120:         return("5120: Internal database error");
			case ERR_DATABASE_INVALID_HANDLE:        return("5121: Invalid database handle");
			case ERR_DATABASE_TOO_MANY_OBJECTS:      return("5122: Exceeded the maximum acceptable number of Database objects");
			case ERR_DATABASE_CONNECT:               return("5123: Database connection error");
			case ERR_DATABASE_EXECUTE:               return("5124: Request execution error");
			case ERR_DATABASE_PREPARE:               return("5125: Request generation error");
			case ERR_DATABASE_NO_MORE_DATA:          return("5126: No more data to read");
			case ERR_DATABASE_STEP:                  return("5127: Failed to move to the next request entry");
			case ERR_DATABASE_NOT_READY:             return("5128: Data for reading request results are not ready yet");
			case ERR_DATABASE_BIND_PARAMETERS:       return("5129: Failed to auto substitute parameters to an SQL request");
			// Operations with WebRequest
			case ERR_WEBREQUEST_INVALID_ADDRESS:     return("5200: Invalid URL");
			case ERR_WEBREQUEST_CONNECT_FAILED:      return("5201: Failed to connect to specified URL");
			case ERR_WEBREQUEST_TIMEOUT:             return("5202: Timeout exceeded");
			case ERR_WEBREQUEST_REQUEST_FAILED:      return("5203: HTTP request failed");
			// Operations with network (sockets)
			case ERR_NETSOCKET_INVALIDHANDLE:        return("5270: Invalid socket handle passed to function");
			case ERR_NETSOCKET_TOO_MANY_OPENED:      return("5271: Too many open sockets (max 128)");
			case ERR_NETSOCKET_CANNOT_CONNECT:       return("5272: Failed to connect to remote host");
			case ERR_NETSOCKET_IO_ERROR:             return("5273: Failed to send/receive data from socket");
			case ERR_NETSOCKET_HANDSHAKE_FAILED:     return("5274: Failed to establish secure connection (TLS Handshake)");
			case ERR_NETSOCKET_NO_CERTIFICATE:       return("5275: No data on certificate protecting the connection");
			// Custom Symbols
			case ERR_NOT_CUSTOM_SYMBOL:              return("5300: A custom symbol must be specified");
			case ERR_CUSTOM_SYMBOL_WRONG_NAME:       return("5301: The name of the custom symbol is invalid. The symbol name can only contain Latin letters without punctuation, spaces or special characters (may only contain \".\", \"_\", \"&\" and \"#\"). It is not recommended to use characters <, >, :, \", /,\\, |, ?, *.");
			case ERR_CUSTOM_SYMBOL_NAME_LONG:        return("5302: The name of the custom symbol is too long. The length of the symbol name must not exceed 32 characters including the ending 0 character");
			case ERR_CUSTOM_SYMBOL_PATH_LONG:        return("5303: The path of the custom symbol is too long. The path length should not exceed 128 characters including \"Custom\\\\\", the symbol name, group separators and the ending 0");
			case ERR_CUSTOM_SYMBOL_EXIST:            return("5304: A custom symbol with the same name already exists");
			case ERR_CUSTOM_SYMBOL_ERROR:            return("5305: Error occurred while creating, deleting or changing the custom symbol");
			case ERR_CUSTOM_SYMBOL_SELECTED:         return("5306: You are trying to delete a custom symbol selected in Market Watch");
			case ERR_CUSTOM_SYMBOL_PROPERTY_WRONG:   return("5307: An invalid custom symbol property");
			case ERR_CUSTOM_SYMBOL_PARAMETER_ERROR:  return("5308: A wrong parameter while setting the property of a custom symbol");
			case ERR_CUSTOM_SYMBOL_PARAMETER_LONG:   return("5309: A too long string parameter while setting the property of a custom symbol");
			case ERR_CUSTOM_TICKS_WRONG_ORDER:       return("5310: Ticks in the array are not arranged in the order of time");
			// Economic Calendar
			case ERR_CALENDAR_MORE_DATA:             return("5400: Array size is insufficient for receiving descriptions of all values");
			case ERR_CALENDAR_TIMEOUT:               return("5401: Request time limit exceeded");
			case ERR_CALENDAR_NO_DATA:               return("5402: Country is not found");
			// Working with databases
			case ERR_DATABASE_ERROR:                 return("5601: Generic error");
			case ERR_DATABASE_INTERNAL_5602:         return("5602: SQLite internal logic error");
			case ERR_DATABASE_PERM:                  return("5603: Access denied");
			case ERR_DATABASE_ABORT:                 return("5604: Callback routine requested abort");
			case ERR_DATABASE_BUSY:                  return("5605: Database file locked");
			case ERR_DATABASE_LOCKED:                return("5606: Database table locked");
			case ERR_DATABASE_NOMEM:                 return("5607: Insufficient memory for completing operation");
			case ERR_DATABASE_READONLY:              return("5608: Attempt to write to readonly database");
			case ERR_DATABASE_INTERRUPT:             return("5609: Operation terminated by sqlite3_interrupt()");
			case ERR_DATABASE_IOERR:                 return("5610: Disk I/O error");
			case ERR_DATABASE_CORRUPT:               return("5611: Database disk image corrupted");
			case ERR_DATABASE_NOTFOUND:              return("5612: Unknown operation code in sqlite3_file_control()");
			case ERR_DATABASE_FULL:                  return("5613: Insertion failed because database is full");
			case ERR_DATABASE_CANTOPEN:              return("5614: Unable to open the database file");
			case ERR_DATABASE_PROTOCOL:              return("5615: Database lock protocol error");
			case ERR_DATABASE_EMPTY:                 return("5616: Internal use only");
			case ERR_DATABASE_SCHEMA:                return("5617: Database schema changed");
			case ERR_DATABASE_TOOBIG:                return("5618: String or BLOB exceeds size limit");
			case ERR_DATABASE_CONSTRAINT:            return("5619: Abort due to constraint violation");
			case ERR_DATABASE_MISMATCH:              return("5620: Data type mismatch");
			case ERR_DATABASE_MISUSE:                return("5621: Library used incorrectly");
			case ERR_DATABASE_NOLFS:                 return("5622: Uses OS features not supported on host");
			case ERR_DATABASE_AUTH:                  return("5623: Authorization denied");
			case ERR_DATABASE_FORMAT:                return("5624: Not used ");
			case ERR_DATABASE_RANGE:                 return("5625: Bind parameter error, incorrect index");
			case ERR_DATABASE_NOTADB:                return("5626: File opened that is not database file");


#endif
		}

		if (_math.is_in_range(error_code, ERR_USER_ERROR_FIRST, ERR_USER_ERROR_FIRST + USHORT_MAX - 1))
			return("User defined error #" + string(error_code));

		return("Unknown error #" + string(error_code));
	}

} _err;
