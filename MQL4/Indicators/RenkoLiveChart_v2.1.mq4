//+------------------------------------------------------------------+
//|                                          RenkoLiveChart_v2.0.mq4 |
//|          Inspired from Renco script by "e4" (renko_live_scr.mq4) |
//|                                         Copyleft 2009 LastViking |
//+------------------------------------------------------------------+
#property copyright "" 
#property indicator_chart_window
#property indicator_buffers 1
//+------------------------------------------------------------------+
#include <WinUser32.mqh>
//+------------------------------------------------------------------+
extern int BoxSize = 5;
extern int BoxOffset = 0;
extern int RenkoTimeFrame = 2;      // What time frame to use for the offline renko chart
extern bool StrangeSymbolName = false; 
//+------------------------------------------------------------------+
int HstHandle = -1;
string SymbolName;
//+------------------------------------------------------------------+
void UpdateChartWindow() {
	static int hwnd = 0;
 
	if(hwnd == 0) {
		hwnd = WindowHandle(SymbolName, RenkoTimeFrame);
		if(hwnd != 0) Print("Chart window detected");
	}
	if(hwnd != 0) if(PostMessageA(hwnd, WM_COMMAND, 0x822c, 0) == 0) hwnd = 0;
	//if(hwnd != 0) UpdateWindow(hwnd);
}
//+------------------------------------------------------------------+
int start() {

	static int LastFPos = 0;
	static double BoxPoints, PrevLow, PrevHigh, PrevOpen, PrevClose, CurVolume, CurHigh, CurLow;
	static datetime PrevTime;
	
	if(HstHandle < 0) {
		// Init
		
		// Error checking	
		if(!IsConnected()) {
			Print("Waiting for connection...");
			return(0);
		}							
		if(!IsDllsAllowed()) {
			Print("Error: Dll calls must be allowed!");
			return(-1);
		}		
		if(MathAbs(BoxOffset) >= BoxSize) {
			Print("Error: |BoxOffset| should be less then BoxSize!");
			return(-1);
		}
		switch(RenkoTimeFrame) {
		case 1: case 5: case 15: case 30: case 60: case 240:
		case 1440: case 10080: case 43200: case 0:
			Print("Error: Invald time frame used for offline renko chart (RenkoTimeFrame)!");
			return(-1);
		}
		//
		
		if(StrangeSymbolName) SymbolName = StringSubstr(Symbol(), 0, 6);
		else SymbolName = Symbol();
   		BoxPoints = NormalizeDouble(BoxSize*Point, Digits);
   		PrevLow = NormalizeDouble(BoxOffset*Point + MathFloor(Close[Bars-1]/BoxPoints)*BoxPoints, Digits);
   		PrevHigh = PrevLow + BoxPoints;
   		PrevOpen = PrevLow;
   		PrevClose = PrevHigh;
		CurVolume = 1;
		PrevTime = Time[Bars-1];
	
		// create / open hst file		
   		HstHandle = FileOpenHistory(SymbolName + RenkoTimeFrame + ".hst", FILE_BIN|FILE_WRITE);
   		if(HstHandle < 0) return(-1);
   		//
   	
		// write hst file header
		int HstUnused[13];
   		FileWriteInteger(HstHandle, 400, LONG_VALUE); 			// Version
   		FileWriteString(HstHandle, "", 64);					// Copyright
   		FileWriteString(HstHandle, SymbolName, 12);			// Symbol
   		FileWriteInteger(HstHandle, RenkoTimeFrame, LONG_VALUE);	// Period
   		FileWriteInteger(HstHandle, Digits, LONG_VALUE);		// Digits
   		FileWriteInteger(HstHandle, 0, LONG_VALUE);			// Time Sign
   		FileWriteInteger(HstHandle, 0, LONG_VALUE);			// Last Sync
   		FileWriteArray(HstHandle, HstUnused, 0, 13);			// Unused
   		//
   	
 		// process historical data
  		int i = Bars-2;
  		while(i >= 0) {
  		
			CurVolume = CurVolume + Volume[i];
		
			if(LastFPos != 0) {
				FileSeek(HstHandle, LastFPos, SEEK_SET);
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);	
			}
		
			bool UpTrend = High[i]+Low[i] > PrevHigh+PrevLow;
			// update low before high or the revers depending on is closest to prev. renko bar
		
			while(UpTrend && Low[i] <= PrevLow-BoxPoints) {
  				PrevHigh = PrevHigh - BoxPoints;
  				PrevLow = PrevLow - BoxPoints;
  				PrevOpen = PrevHigh;
  				PrevClose = PrevLow;
  				CurVolume = 1;
  				  			
				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  				LastFPos = FileTell(HstHandle);   // Remeber Last pos in file			
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
				
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}
		
			while(High[i] >= PrevHigh+BoxPoints) {
  				PrevHigh = PrevHigh + BoxPoints;
  				PrevLow = PrevLow + BoxPoints;
  				PrevOpen = PrevLow;
  				PrevClose = PrevHigh;
  				CurVolume = 1;
  			
				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  				LastFPos = FileTell(HstHandle);   // Remeber Last pos in file			
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
				
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}
		
  			while(!UpTrend && Low[i] <= PrevLow-BoxPoints) {
  				PrevHigh = PrevHigh - BoxPoints;
  				PrevLow = PrevLow - BoxPoints;
  				PrevOpen = PrevHigh;
  				PrevClose = PrevLow;
  				CurVolume = 1;
  			
				FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
				FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
				FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  				LastFPos = FileTell(HstHandle);   // Remeber Last pos in file			
				FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
				
				if(PrevTime < Time[i]) PrevTime = Time[i];
				else PrevTime++;
			}		
			i--;
		} 
		FileFlush(HstHandle);
		//
			
		Comment("RenkoLiveChart(" + BoxSize + "): Open Offline ", SymbolName, ",M", RenkoTimeFrame, " to view chart");
		
		if(PrevClose == PrevHigh) {
			CurHigh = PrevHigh; 
			CurLow = PrevHigh;
		} else { // PrevClose == PrevLow
			CurHigh = PrevLow; 
			CurLow = PrevLow;
		}
		CurVolume = 0;
		
		UpdateChartWindow();
		
		return(0);
 		// End historical data / Init		
	} 		
 	
 	// Begin live data feed	   				
   	if(Bid >= PrevHigh+BoxPoints) {
   			
		CurVolume++;   			
		FileSeek(HstHandle, LastFPos, SEEK_SET);
		FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);   			
   			
     		PrevHigh = PrevHigh + BoxPoints;
		PrevLow = PrevLow + BoxPoints;
  		PrevOpen = PrevLow;
  		PrevClose = PrevHigh;
  				  			
		FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
		FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
		FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
		FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
		FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  	  	LastFPos = FileTell(HstHandle);   // Remeber Last pos in file				  							
		FileWriteDouble(HstHandle, 1, DOUBLE_VALUE);
      	FileFlush(HstHandle);
      	
		if(PrevTime < TimeCurrent()) PrevTime = TimeCurrent();
		else PrevTime++;
            		
  		CurVolume = 0;
		CurHigh = PrevHigh;
		CurLow = PrevHigh;  
		
		UpdateChartWindow();				            		
  	}
	else if(Bid <= PrevLow-BoxPoints) {
			
		CurVolume++;			
		FileSeek(HstHandle, LastFPos, SEEK_SET);
		FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);			
		
  		PrevHigh = PrevHigh - BoxPoints;
  		PrevLow = PrevLow - BoxPoints;
  		PrevOpen = PrevHigh;
  		PrevClose = PrevLow;
  				  			
		FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);
		FileWriteDouble(HstHandle, PrevOpen, DOUBLE_VALUE);
		FileWriteDouble(HstHandle, PrevLow, DOUBLE_VALUE);
		FileWriteDouble(HstHandle, PrevHigh, DOUBLE_VALUE);
		FileWriteDouble(HstHandle, PrevClose, DOUBLE_VALUE);
  	  	LastFPos = FileTell(HstHandle);   // Remeber Last pos in file				  							
		FileWriteDouble(HstHandle, 1, DOUBLE_VALUE);
      	FileFlush(HstHandle);
      	
		if(PrevTime < TimeCurrent()) PrevTime = TimeCurrent();
		else PrevTime++;      	
            		
  		CurVolume = 0;
		CurHigh = PrevLow;
		CurLow = PrevLow;  
		
		UpdateChartWindow();						
     	} 
	else {
				
		CurVolume++;
		FileSeek(HstHandle, LastFPos, SEEK_SET); 
		FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);
		
		if(CurHigh < Bid) CurHigh = Bid;
		if(CurLow > Bid) CurLow = Bid;
		
		double CurOpen;		
		if(PrevHigh <= Bid) CurOpen = PrevHigh;
		else if(PrevLow >= Bid) CurOpen = PrevLow;
		else CurOpen = Bid;
		
		double CurClose = Bid;
		
		FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);		// Time
		FileWriteDouble(HstHandle, CurOpen, DOUBLE_VALUE);         	// Open
		FileWriteDouble(HstHandle, CurLow, DOUBLE_VALUE);		// Low
		FileWriteDouble(HstHandle, CurHigh, DOUBLE_VALUE);		// High
		FileWriteDouble(HstHandle, CurClose, DOUBLE_VALUE);		// Close
		FileWriteDouble(HstHandle, 1, DOUBLE_VALUE);			// Volume				
            FileFlush(HstHandle);
            
		UpdateChartWindow();            
     	}
     	return(0);
}
//+------------------------------------------------------------------+
int deinit() {
	if(HstHandle >= 0) {
		FileClose(HstHandle);
		HstHandle = -1;
	}
   	Comment("");
	return(0);
}
//+------------------------------------------------------------------+
   