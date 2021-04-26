//+------------------------------------------------------------------+
//|                                                    insideBar.mq4 |
//|                                                             Enzo |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
/*
enum session{
   h0 = 0,        //0:00
   h1 = 1,        //1:00
   h2 = 2,        //2:00
   h3 = 3,        //3:00
   h4 = 4,        //4:00
   h5 = 5,        //5:00
   h6 = 6,        //6:00
   h7 = 7,        //7:00
   h8 = 8,        //8:00
   h9 = 9,        //9:00
   h10 = 10,     //10:00
   h11 = 11,     //11:00
   h12 = 12,     //12:00
   h13 = 13,     //13:00
   h14 = 14,     //14:00
   h15 = 15,     //15:00
   h16 = 16,     //16:00
   h17 = 17,     //17:00
   h18 = 18,     //18:00
   h19 = 19,     //19:00
   h20 = 20,     //20:00
   h21 = 21,     //21:00
   h22 = 22,     //22:00
   h23 = 23,     //23:00
};

input bool     useSession      = true;        //Использовать открытие/закрытие сессии
input session  openSession     = 6;           //Открытие сессии
input session  closeSession    = 15;          //Закрытие сессии
input color    sessionColor    = clrYellow;   //Цвет области открытой сессии

double   sessionPrice;
datetime sTime1;
datetime sTime2;
double   sPrice1;
double   sPrice2;*/
input color bull  = clrRed;
input color bear  = clrBlue;
long     chart_ID;
ushort   type;
datetime ibTime1;
datetime ibTime2;
double   ibPrice1;
double   ibPrice2;
datetime lTime;

/*void DrawSession(){
}*/
void DrawIB(){
   static uint n = 0;
   string name = "IB_"+IntegerToString(n);
   long clr = 0;
   
   switch(type){
      case  1: n++; clr = bull; break; //up
      case  2: n++; clr = bear; break; //down
      default: return;
   }
   //Print(name,": time1 = ",time1," time2 = ",time2," price1 = ",price1, " price2 = ",price2);
   ObjectCreate(chart_ID, name, OBJ_RECTANGLE, 0, ibTime1, ibPrice1, ibTime2, ibPrice2);
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
};

bool isNewIB(int i){  
   ibPrice1 = NormalizeDouble(High[i+1],Digits());
   ibPrice2 = NormalizeDouble(Low[i+1],Digits());
   ibTime1  = Time[i+1];
   ibTime2  = Time[i];
   type = 0;	//none
   
   if(High[i] < High[i+1] && Low[i] > Low[i+1]){
      if(Close[i] < Open[i] && Close[i+1] > Open[i+1] && Close[i] > Open[i+1] && Open[i] < Close[i+1]){
         Print("up");
   	   type = 2; //down
   	   return true;
   	}
   	else if(Close[i] > Open[i] && Close[i+1] < Open[i+1] && Close[i] < Open[i+1] && Open[i] > Close[i+1]){
   	   Print("own");
      	type = 1; //up
      	return true;
      }
   }   
   else
      return false;
      
   return true;
};
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   chart_ID = ChartID();
   /*sessionPrice   = 0.0;
   sTime1         = 0;
   sTime2         = 0;
   sPrice1        = 0.0;
   sPrice2        = 0.0;*/
   ibTime1        = 0;
   ibTime2        = 0;
   ibPrice1       = 0.0;
   ibPrice2       = 0.0;
   lTime          = 0;
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
//---
   if(lTime == 0)
      for(int i = rates_total-2; i > 0; i--)
         if(isNewIB(i))
            DrawIB(); 
            
   if(lTime == time[0])
      return rates_total;
       
   lTime = time[0];
   
   if(isNewIB(1))
      DrawIB();
   
//--- return value of prev_calculated for next call
   return(rates_total);
}

void OnDeinit(const int reason){
   int total = ObjectsTotal();
   string name;
   for(int i = 0; i<total; i++){
      name = "IB_"+IntegerToString(i);
         if(ObjectFind(chart_ID, name)!= -1)
            ObjectDelete(chart_ID, name);

   }
}
//+------------------------------------------------------------------+
