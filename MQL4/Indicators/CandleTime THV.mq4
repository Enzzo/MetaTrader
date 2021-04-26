//+------------------------------------------------------------------+
//|                                                      b-clock.mq4 |
//|                                     Core time code by Nick Bilak |
//|        Modified by Cobraforex for THV System, www.cobraforex.com | 
//|                                                                  | 
//|        Timecolor now changeable                                  |
//+------------------------------------------------------------------+

#property copyright "Copyright � 2005, Nick Bilak"
#property link      "http://metatrader.50webs.com/"

#property indicator_chart_window


extern color timeColor = White;
//---- buffers
double s1[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int init()

  {
   
  }
   return(0);
  
  
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

	double i;
   int m,s,k;
   m=Time[0]+Period()*60-CurTime();
   i=m/60.0;
   s=m%60;
   m=(m-m%60)/60;
//   Comment( m + " minutes " + s + " seconds left to bar end");
	
	
   ObjectDelete("time");
   
   if(ObjectFind("time") != 0)
   {
   ObjectCreate("time", OBJ_TEXT, 0, Time[0], Close[0]+ 0.0005);
   ObjectSetText("time", "                       "+m+":"+s, 10, "Arial Black", timeColor);
   }
   else
   {
   ObjectMove("time", 0, Time[0], Close[0]+0.0005);
   }


   return(0);
  }
//+------------------------------------------------------------------+


