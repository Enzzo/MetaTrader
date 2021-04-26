//+------------------------------------------------------------------+
//|   TRO_InsideBar_Plot2                                            |
//|                                                                  | 
//|   Copyright © 2009, Avery T. Horton, Jr. aka TheRumpledOne       |
//|                                                                  |
//|   PO BOX 43575, TUCSON, AZ 85733                                 |
//|                                                                  |
//|   GIFTS AND DONATIONS ACCEPTED                                   | 
//|   All my indicators should be considered donationware. That is   |
//|   you are free to use them for your personal use, and are        |
//|   under no obligation to pay for them. However, if you do find   |
//|   this or any of my other indicators help you with your trading  |
//|   then any Gift or Donation as a show of appreciation is         |
//|   gratefully accepted.                                           |
//|                                                                  |
//|   Gifts or Donations also keep me motivated in producing more    |
//|   great free indicators. :-)                                     |
//|                                                                  |
//|   PayPal - THERUMPLEDONE@GMAIL.COM                               |  
//+------------------------------------------------------------------+ 
//| Use http://therumpledone.mbtrading.com/fx/ as your forex broker  |  
//| ...tell them therumpledone sent you!                             |  
//+------------------------------------------------------------------+ 


#property  copyright "Copyright © 2009, Avery T. Horton, Jr. aka TRO" 
#property  link      "http://www.therumpledone.com/" 

#property indicator_chart_window 
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Blue

extern int  myThreshold = 50 ;
extern bool Show.Commemt = true ;

extern color colorIBHigh = Aqua ;
extern color colorIBLow  = Magenta ;


//---- buffers
double val1[];
double val2[];

 

   double Range, AvgRange;
   int counter, setalert;
 
   int shift;
   int shift1;
   int shift2;
   int shift3;
 
   double O, O1, C, C1, L, L1, H, H1;
   


//---- buffers
 

string tHIGH0 = "HIGH_0" ;
string tLOW0 = "LOW_0" ;
 

string symbol, tChartPeriod,  tShortName, oldmsg = "" ;  
int    digits, period  ; 

double X01, X02, min=99999, max=-1, Open0, Open1, Open2, Close0, Close1, Close2, High0, High1, High2, Low0,  Low1, Low2  ;

double xPct ;

bool IB = false ; 
 
int xIB ; 
 
//+------------------------------------------------------------------+
int init()
  {
   period       = Period() ;  
   symbol       = Symbol() ;
   

   string short_name="IBPL";
   IndicatorShortName(short_name);

   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(0,val1);
   SetIndexBuffer(1,val2);

   return(0);
  }
  
//+------------------------------------------------------------------+
int deinit()
  {
   
   ObjectDelete(tHIGH0);
   ObjectDelete(tLOW0);
   Comment("");
      
   return(0);
  }
  
//+------------------------------------------------------------------+
int start()
  {

  
   int i, dayi, counted_bars = IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0) 
       return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0) 
       counted_bars--;  
   int limit = Bars - counted_bars;
//----   
   for(i = 0; i < limit; i++)
   {
 
   IB  = false ; 
	xIB = 0 ;
			
	Close0 = iClose(symbol,period,i) ; 
   Close1 = iClose(symbol,period,i+1) ;    
   Close2 = iClose(symbol,period,i+2) ;  
     
   Open0 = iOpen(symbol,period,i) ; 
   Open1 = iOpen(symbol,period,i+1) ;    
   Open2 = iOpen(symbol,period,i+2) ;  

   High0 = iHigh(symbol,period,i) ; 
   High1 = iHigh(symbol,period,i+1) ;    
   High2 = iHigh(symbol,period,i+2) ; 

   Low0 = iLow(symbol,period,i) ; 
   Low1 = iLow(symbol,period,i+1) ;    
   Low2 = iLow(symbol,period,i+2) ;  		
   
   max = MathMax(max,High0) ;   			
   min = MathMin(min,Low0) ;   				
			
   if( High1 < High2 &&  Low1 > Low2 )  // && Low0 > min && High0 > max
   { 
      IB  = true ; 
      X01 = High1 ;  
      X02 = Low1 ;
      xIB = i+1 ;
      xPct = (( High1 - Low1 )  / ( High2 - Low2 )) * 100 ; 
      
         if( xPct < myThreshold ) 
         {       
		       val1[xIB]=High[xIB]; val2[xIB]=Low[xIB];
		   }
		   else
		   {
		       val2[xIB]=High[xIB]; val1[xIB]=Low[xIB];		
		   }
		   
      break ; 
   }

   }

  if(!IB) { deinit() ; } 

  if (ObjectFind(tHIGH0) != 0)
      {
      
          ObjectCreate(tHIGH0,OBJ_HLINE,0,Time[0],X01);         
//          ObjectCreate(tHIGH0,OBJ_ARROW,0,Time[0],X01);
//          ObjectSet(tHIGH0,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
          ObjectSet(tHIGH0,OBJPROP_COLOR,colorIBHigh);  
      } 
      else
      {
         ObjectMove(tHIGH0,0,Time[0],X01);
      }
 

    
    if (ObjectFind(tLOW0) != 0)
      {
          ObjectCreate(tLOW0,OBJ_HLINE,0,Time[0],X02);   
//          ObjectCreate(tLOW0,OBJ_ARROW,0,Time[0],X02);
//         ObjectSet(tLOW0,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
          ObjectSet(tLOW0,OBJPROP_COLOR,colorIBLow);
      } 
      else
      {
         ObjectMove(tLOW0,0,Time[0],X02);
      }

if( Show.Commemt )
{
   Comment( "Most recent inside bar was " + xIB + " ago" + "\n",
            "and was " + DoubleToStr(xPct,0)+ "% of preceding bar" 
   );
}
else
{
   Comment("") ;
}

return(0);
}


