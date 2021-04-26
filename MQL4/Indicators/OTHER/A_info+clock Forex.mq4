//+------------------------------------------------------------------+
//|                                           A_info+clock Forex.mq4 |
//+------------------------------------------------------------------+
#property indicator_chart_window
extern color YesterdayHigh    = clrBlue;
extern color YesterdayLow     = clrBlue;
extern color TodayOpen        = clrBlueViolet;
extern color RoundLevels      = clrWhite;
extern color ADRLevels        = clrMagenta;
extern color TextColor        = clrGray;
extern int   YHLLinesWidth    = 5;
extern int   OpenLineWidth    = 5;
extern int   RoundLevelsWidth = 3;
extern int   ADRLevelsWidth   = 1;
extern int   ADRLevelsStyle   = 1;
extern bool  ShowADRlevels    = true;
extern bool  ShowLabels       = true;
extern bool  ShowRoundLevels  = true;
extern int   LabelsShift      = 400;

int    k,d,per,s,m,time1,time2,TimeFrame,ShiftLabels,day;
double pprice,sprice,hl,pto,Lower,Upper,ystL,ystH,atr,opn;
double Fib100,Fib618,Fib764,Fib500,Fib382;
string shl,spto,sper,ssprd,instr;
string font="Microsoft Sans Serif";
datetime LastAlertTime;
bool first;

//+------------------------------------------------------------------+

int init()
{
   if(TimeDayOfWeek(Time[0])==1) day=2; else day=1;
   TimeFrame =MathMax(TimeFrame,_Period);
   ShiftLabels=LabelsShift*TimeFrame;
   instr=Symbol();
   instr=StringSubstr(instr,0,6);
   per=Period();
   LastAlertTime=TimeCurrent();
   first=true;
   
   if (per<60){sper="M"+per;}
   else if(per>=60&&per<60*24) {sper="H"+per/60+" ";}
   else {sper="D"+per/(60*24);}
   
   ObjectCreate("Price",OBJ_LABEL,0,0,0);
   ObjectSet("Price",OBJPROP_CORNER,1);
   ObjectSet("Price",OBJPROP_XDISTANCE,5);
   ObjectSet("Price",OBJPROP_YDISTANCE,10);
     
   ObjectCreate("L1",OBJ_LABEL,0,0,0);
   ObjectSet("L1",OBJPROP_CORNER,1);
   ObjectSet("L1",OBJPROP_XDISTANCE,40);
   ObjectSet("L1",OBJPROP_YDISTANCE,45);
   ObjectSetText("L1","High-Low  :",10,font,TextColor);
    
   ObjectCreate("L2",OBJ_LABEL,0,0,0);
   ObjectSet("L2",OBJPROP_CORNER,1);
   ObjectSet("L2",OBJPROP_XDISTANCE,40);
   ObjectSet("L2",OBJPROP_YDISTANCE,65);
   ObjectSetText("L2","Pips-Open:",10,font,TextColor);
   
   ObjectCreate("L3",OBJ_LABEL,0,0,0);
   ObjectSet("L3",OBJPROP_CORNER,1);
   ObjectSet("L3",OBJPROP_XDISTANCE,40);
   ObjectSet("L3",OBJPROP_YDISTANCE,85);
   ObjectSetText("L3","Spread:",10,font,TextColor);
   
   ObjectCreate("L4",OBJ_LABEL,0,0,0);
   ObjectSet("L4",OBJPROP_CORNER,1);
   ObjectSet("L4",OBJPROP_XDISTANCE,40);
   ObjectSet("L4",OBJPROP_YDISTANCE,105);
   ObjectSetText("L4",instr,13,font,clrRed);
 
   ObjectCreate("L11",OBJ_LABEL,0,0,0);
   ObjectSet("L11",OBJPROP_CORNER,1);
   ObjectSet("L11",OBJPROP_XDISTANCE,5);
   ObjectSet("L11",OBJPROP_YDISTANCE,42);
   
   ObjectCreate("L22",OBJ_LABEL,0,0,0);
   ObjectSet("L22",OBJPROP_CORNER,1);
   ObjectSet("L22",OBJPROP_XDISTANCE,5);
   ObjectSet("L22",OBJPROP_YDISTANCE,62);
    
   ObjectCreate("L33",OBJ_LABEL,0,0,0);
   ObjectSet("L33",OBJPROP_CORNER,1);
   ObjectSet("L33",OBJPROP_XDISTANCE,5);
   ObjectSet("L33",OBJPROP_YDISTANCE,82);
   
   ObjectCreate("L44",OBJ_LABEL,0,0,0);
   ObjectSet("L44",OBJPROP_CORNER,1);
   ObjectSet("L44",OBJPROP_XDISTANCE,4);
   ObjectSet("L44",OBJPROP_YDISTANCE,105);
   ObjectSetText("L44",sper,13,font,clrRed);
   
   ObjectCreate("Today open",OBJ_TREND,0,0,0);
   ObjectCreate("Yesterday high",OBJ_TREND,0,0,0);
   ObjectCreate("Yesterday low",OBJ_TREND,0,0,0);
   
   if (ShowRoundLevels)
      {
         ObjectCreate("Upper Round level",OBJ_TREND,0,0,0);
         ObjectCreate("Lower Round level",OBJ_TREND,0,0,0);
         ObjectCreate("Upper label",OBJ_ARROW_RIGHT_PRICE,0,0,0);
         ObjectCreate("Lower label",OBJ_ARROW_RIGHT_PRICE,0,0,0);
      }
                    
   if(Digits==5){k=10000;d=5;} 
   else if(Digits==4){k=10000;d=4;}
   else if(Digits==3){k=100;d=3;}
   else if(Digits==2){k=10;d=2;}
   else {k=100;d=2;}

   return(0);
}

//+------------------------------------------------------------------+

int deinit()
{
   ObjectDelete("Price");
   ObjectDelete("L1");
   ObjectDelete("L2");
   ObjectDelete("L3");
   ObjectDelete("L4");
   ObjectDelete("L11");
   ObjectDelete("L22");
   ObjectDelete("L33");
   ObjectDelete("L44");
   ObjectDelete("Time");
   ObjectDelete("Today open");
   ObjectDelete("Open label");
   ObjectDelete("Yesterday high");
   ObjectDelete("Yesterday low");
   ObjectDelete("Upper Round level");
   ObjectDelete("Lower Round level");
   ObjectDelete("Yest High label");
   ObjectDelete("Yest Low label");
   ObjectDelete("Upper label");
   ObjectDelete("Lower label");
   ObjectDelete("ADR Fib100");
   ObjectDelete("ADR Fib764");
   ObjectDelete("ADR Fib618");
   ObjectDelete("ADR Fib500");
   ObjectDelete("ADR Fib382");
   ObjectDelete("100 % ADR");
   ObjectDelete("50 % ADR");
   return(0);
}
 
//+------------------------------------------------------------------+

int start()
{
   //--------- Clock settings ----------------
      
   m=Time[0]+Period()*60-TimeCurrent();
   s=m%60;
   m=(m-m%60)/60;
   ObjectDelete("Time");
   if(ObjectFind("Time") != 0)
      {
         ObjectCreate("Time", OBJ_TEXT, 0, Time[0], Close[0]);
         ObjectSetText("Time", "                <"+m+":"+s,10,"Arial Black",clrBlue);
      }
   else ObjectMove("Time", 0, Time[0], Close[0]);

   //--------- Info settings ------------------ 
   
   sprice=DoubleToStr(Bid,d-1); 
   hl=iHigh(0,PERIOD_D1,0)-iLow(0,PERIOD_D1,0); 
   hl*=k;
   shl=DoubleToStr(hl,0);
   pto=(Bid-iOpen(0,PERIOD_D1,0))*k;
   spto=DoubleToStr(pto,0);
   ssprd=DoubleToStr((Ask-Bid)*k,1);

   ObjectSetText("Price",DoubleToStr(Bid,d-1),24,"Digifacewide",Red);
   ObjectSetText("L11",shl,11,font,clrWhite);
   if (pto<=0){ObjectSetText("L22",spto,11,font,clrRed);}
   if (pto>0){ObjectSetText("L22",spto,11,font,clrLime);}
   ObjectSetText("L33",ssprd,11,font,clrWhite);

   //-----------------------------------------------------------------
   
   if (Time[0]>LastAlertTime || first==true)
      {     
         Lower=MathFloor((Close[0]/Point)/1000)*Point*1000;
         Upper=MathCeil((Close[0]/Point)/1000)*Point*1000;
            
         ObjectSet("Today open",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,0));
         ObjectSet("Today open",OBJPROP_PRICE1,iOpen(Symbol(),PERIOD_D1,0));
         ObjectSet("Today open",OBJPROP_TIME2,iTime(Symbol(),TimeFrame,0));
         ObjectSet("Today open",OBJPROP_PRICE2,iOpen(Symbol(),PERIOD_D1,0));
         ObjectSet("Today open",OBJPROP_COLOR,TodayOpen);
         ObjectSet("Today open",OBJPROP_WIDTH,OpenLineWidth);
         ObjectSet("Today open",OBJPROP_BACK, True);
         ObjectSet("Today open",OBJPROP_RAY,0);
         
         ObjectSet("Yesterday high",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,day));
         ObjectSet("Yesterday high",OBJPROP_PRICE1,iHigh(Symbol(),PERIOD_D1,day));
         ObjectSet("Yesterday high",OBJPROP_TIME2,iTime(Symbol(),TimeFrame,0));
         ObjectSet("Yesterday high",OBJPROP_PRICE2,iHigh(Symbol(),PERIOD_D1,day));
         ObjectSet("Yesterday high",OBJPROP_COLOR,YesterdayHigh);
         ObjectSet("Yesterday high",OBJPROP_WIDTH,YHLLinesWidth);
         ObjectSet("Yesterday high",OBJPROP_BACK, True);
         ObjectSet("Yesterday high",OBJPROP_RAY,0);
      
         ObjectSet("Yesterday low",OBJPROP_TIME1,iTime(Symbol(),PERIOD_D1,day));
         ObjectSet("Yesterday low",OBJPROP_PRICE1,iLow(Symbol(),PERIOD_D1,day));
         ObjectSet("Yesterday low",OBJPROP_TIME2,iTime(Symbol(),TimeFrame,0));
         ObjectSet("Yesterday low",OBJPROP_PRICE2,iLow(Symbol(),PERIOD_D1,day));
         ObjectSet("Yesterday low",OBJPROP_COLOR,YesterdayLow);
         ObjectSet("Yesterday low",OBJPROP_WIDTH,YHLLinesWidth);
         ObjectSet("Yesterday low",OBJPROP_BACK, True);
         ObjectSet("Yesterday low",OBJPROP_RAY,0);
         
         if (ShowRoundLevels)
            {
               ObjectSet("Upper Round level",OBJPROP_TIME1,iTime(Symbol(),TimeFrame,0));
               ObjectSet("Upper Round level",OBJPROP_PRICE1,Upper);
               ObjectSet("Upper Round level",OBJPROP_TIME2,iTime(Symbol(),TimeFrame,15));
               ObjectSet("Upper Round level",OBJPROP_PRICE2,Upper);
               ObjectSet("Upper Round level",OBJPROP_COLOR,RoundLevels);
               ObjectSet("Upper Round level",OBJPROP_WIDTH,RoundLevelsWidth);
               ObjectSet("Upper Round level",OBJPROP_BACK, True);
               ObjectSet("Upper Round level",OBJPROP_RAY,0);
               
               ObjectSet("Lower Round level",OBJPROP_TIME1,iTime(Symbol(),TimeFrame,0));
               ObjectSet("Lower Round level",OBJPROP_PRICE1,Lower);
               ObjectSet("Lower Round level",OBJPROP_TIME2,iTime(Symbol(),TimeFrame,15));
               ObjectSet("Lower Round level",OBJPROP_PRICE2,Lower);
               ObjectSet("Lower Round level",OBJPROP_COLOR,RoundLevels);
               ObjectSet("Lower Round level",OBJPROP_WIDTH,RoundLevelsWidth);
               ObjectSet("Lower Round level",OBJPROP_BACK, True);
               ObjectSet("Lower Round level",OBJPROP_RAY,0);
               
               ObjectSet("Upper label",OBJPROP_TIME1,iTime(Symbol(),TimeFrame,0)+ShiftLabels);
               ObjectSet("Upper label",OBJPROP_PRICE1,Upper);
               ObjectSet("Upper label",OBJPROP_WIDTH,1);
               ObjectSet("Upper label",OBJPROP_COLOR,RoundLevels);
                   
               ObjectSet("Lower label",OBJPROP_TIME1,iTime(Symbol(),TimeFrame,0)+ShiftLabels);
               ObjectSet("Lower label",OBJPROP_PRICE1,Lower);
               ObjectSet("Lower label",OBJPROP_WIDTH,1);
               ObjectSet("Lower label",OBJPROP_COLOR,RoundLevels);
            }

         if (ShowADRlevels)
            {
               atr = iATR(NULL, PERIOD_D1,7,0);
               opn = iOpen(NULL,PERIOD_D1,0);
               
               if (Close[0]>opn)
                  {
                     Fib100= opn + atr; 
                     Fib764= opn + (atr*0.764);
                     Fib618= opn + (atr*0.618);
                     Fib500= opn + (atr*0.500);
                     Fib382= opn + (atr*0.382);
                  }
               else
                  {
                     Fib100= opn - atr; 
                     Fib764= opn - (atr*0.764);
                     Fib618= opn - (atr*0.618);
                     Fib500= opn - (atr*0.500);
                     Fib382= opn - (atr*0.382);
                  }
                                           
               DrawLevel("ADR Fib100", Fib100, ADRLevelsStyle, ADRLevels, ADRLevelsWidth);
               //DrawLevel("ADR Fib764", Fib764, ADRLevelsStyle, ADRLevels, ADRLevelsWidth);
               //DrawLevel("ADR Fib618", Fib618, ADRLevelsStyle, ADRLevels, ADRLevelsWidth);
               DrawLevel("ADR Fib500", Fib500, ADRLevelsStyle, ADRLevels, ADRLevelsWidth);
               //DrawLevel("ADR Fib382", Fib382, ADRLevelsStyle, ADRLevels, ADRLevelsWidth);
            }
                  
         if (ShowLabels)
            {
               opn = iOpen(NULL,PERIOD_D1,0);
               ystH= iHigh(NULL,PERIOD_D1,day);
               ystL= iLow(NULL,PERIOD_D1,day);
               
               if(ObjectFind("Open label") != 0)
                  {
                     ObjectCreate("Open label", OBJ_TEXT, 0, Time[0]+(1.5*ShiftLabels), opn);
                     ObjectSetText("Open label", "Day Open", 10, "Arial", TodayOpen);
                  }
               else {ObjectMove("Open label", 0, Time[0]+(1.5*ShiftLabels), opn);}
               
               if(ObjectFind("Yest High price") != 0)
                  {
                     ObjectCreate("Yest High label", OBJ_TEXT, 0, Time[0]+(1.5*ShiftLabels), ystH);
                     ObjectSetText("Yest High label", "Yest High", 10, "Arial", YesterdayHigh);
                  }
               else {ObjectMove("Yest High label", 0, Time[0]+(1.5*ShiftLabels), ystH);}
               
               if(ObjectFind("Yest Low label") != 0)
                  {
                     ObjectCreate("Yest Low label", OBJ_TEXT, 0, Time[0]+(1.5*ShiftLabels), ystL);
                     ObjectSetText("Yest Low label", "Yest Low", 10, "Arial", YesterdayLow);
                  }
               else {ObjectMove("Yest Low label", 0, Time[0]+(1.5*ShiftLabels), ystL);}
               
               if(ObjectFind("100 % ADR") != 0)
                  {
                     ObjectCreate("100 % ADR", OBJ_TEXT, 0, Time[0]+(1.5*ShiftLabels), Fib100);
                     ObjectSetText("100 % ADR", "100 % ADR", 8, "Arial", ADRLevels);
                  }
               else {ObjectMove("100 % ADR", 0, Time[0]+(1.5*ShiftLabels), Fib100);}
               
               if(ObjectFind("50 % ADR") != 0)
                  {
                     ObjectCreate("50 % ADR", OBJ_TEXT, 0, Time[0]+(1.5*ShiftLabels), Fib500);
                     ObjectSetText("50 % ADR", "50 % ADR", 8, "Arial", ADRLevels);
                  }
               else {ObjectMove("50 % ADR", 0, Time[0]+(1.5*ShiftLabels), Fib500);}
            }
                       
      first=false;
      LastAlertTime = Time[0];
      }
        
return(0);
}

//-------------------------------------------------------------------------------

void DrawLevel(string name, double level, int style, color linescolor, int lineswidth)
{
   time1 = Time[iBarShift(NULL, 0, StrToTime(Year() + "." + Month() + "." + Day() + " " + 0 + ":" + 0))];
   time2 = Time[0];
   if (level > 0.0)
      {
         if (ObjectFind(name) != 0)
            {
               ObjectCreate(name, OBJ_TREND, 0, time1, level, time2, level);
               ObjectSet(name, OBJPROP_RAY, FALSE);
               ObjectSet(name, OBJPROP_COLOR, linescolor);
               ObjectSet(name, OBJPROP_WIDTH, lineswidth);
               ObjectSet(name, OBJPROP_STYLE, style);
               ObjectSet(name, OBJPROP_BACK, true);
               return;
            }
            
         ObjectMove(name, 0, time1, level);
         ObjectMove(name, 1, time2, level);
         ObjectSet(name, OBJPROP_RAY, FALSE);
         ObjectSet(name, OBJPROP_COLOR, linescolor);
         ObjectSet(name, OBJPROP_WIDTH, lineswidth);
         ObjectSet(name, OBJPROP_STYLE, style);
         ObjectSet(name, OBJPROP_BACK, true);
         return;
      }
   if (ObjectFind(name) >= 0) ObjectDelete(name);
}

//------------------------------------------------------------------
/*
               ObjectSet("Open label",OBJPROP_TIME1,iTime(Symbol(),TimeFrame,0)+ShiftLabels);
               ObjectSet("Open label",OBJPROP_PRICE1,iOpen(Symbol(),PERIOD_D1,0));
               ObjectSet("Open label",OBJPROP_WIDTH,1);
               ObjectSet("Open label",OBJPROP_COLOR,TodayOpen);
               
               ObjectSet("Yest High price",OBJPROP_TIME1,iTime(Symbol(),TimeFrame,0)+ShiftLabels);
               ObjectSet("Yest High price",OBJPROP_PRICE1,iHigh(Symbol(),PERIOD_D1,day));
               ObjectSet("Yest High price",OBJPROP_WIDTH,1);
               ObjectSet("Yest High price",OBJPROP_COLOR,YesterdayHigh);
               
               ObjectSet("Yest Low price",OBJPROP_TIME1,iTime(Symbol(),TimeFrame,0)+ShiftLabels);
               ObjectSet("Yest Low price",OBJPROP_PRICE1,iLow(Symbol(),PERIOD_D1,day));
               ObjectSet("Yest Low price",OBJPROP_WIDTH,1);
               ObjectSet("Yest Low price",OBJPROP_COLOR,YesterdayLow);
*/