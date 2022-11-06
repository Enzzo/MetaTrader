//+------------------------------------------------------------------+
//|                                   Copyright � 2010, Ivan Kornilov|
//|                                                    TrendValue.mq4|
//+------------------------------------------------------------------+
#property copyright "Copyright � 2010, Ivan Kornilov. All rights reserved."
#property link "excelf@gmail.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color2 Magenta
#property indicator_color1 Lime

extern int period=13;
extern double shiftPercent=0;
extern int atrPeriod=15;
extern double atrSensitivity=1.5;

double upValue[];
double downValue[];

double highMovingAverages[];
double lowMovingAverages[];
double buffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(5);
   
   SetIndexStyle(0,DRAW_LINE,EMPTY,2);
   SetIndexBuffer(0,upValue);
   SetIndexLabel(0,"Up Value");

   SetIndexStyle(1,DRAW_LINE,EMPTY,2);
   SetIndexBuffer(1,downValue);
   SetIndexLabel(1,"Down Value");

   IndicatorDigits(Digits+1);
   SetIndexBuffer(2,buffer);
   SetIndexStyle(2,DRAW_NONE);

   SetIndexBuffer(3,highMovingAverages);
   SetIndexStyle(3,DRAW_NONE);
   
   SetIndexBuffer(4,lowMovingAverages);
   SetIndexStyle(4,DRAW_NONE);
   
   IndicatorShortName("Trand Value ("+period+","+shiftPercent+")");
   return (0);
  }
//+------------------------------------------------------------------+
//| ��������� �������� ����� �������� "������� ���������" � ���      |
//| ������ �������� ������������� �������� �� ���������              |
//+------------------------------------------------------------------+
void ChangeFiboLevelsEmptyPoints(datetime &time1,double &price1,
                                 datetime &time2,double &price2)
  {
//--- ���� ����� ������ ����� �� ������, �� ��� ����� �� ������� ����
   if(!time2)
      time2=TimeCurrent();
//--- ���� ���� ������ ����� �� ������, �� ��� ����� ����� �������� Bid
   if(!price2)
      price2=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- ���� ����� ������ ����� �� ������, �� ��� ����� �� 9 ����� ����� ������
   if(!time1)
     {
      //--- ������ ��� ������ ������� �������� 10 ��������� �����
      datetime temp[10];
      CopyTime(Symbol(),Period(),time2,10,temp);
      //--- ��������� ������ ����� �� 9 ����� ����� ������
      time1=temp[0];
     }
//--- ���� ���� ������ ����� �� ������, �� ������� �� �� 200 ������� ���� ������
   if(!price1)
      price1=price2-200*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
  }
//+------------------------------------------------------------------+
//| C������ "������ ���������" �� �������� �����������               |
//+------------------------------------------------------------------+
bool FiboLevelsCreate(const long            chart_ID=0,        // ID �������
                      const string          name="FiboLevels", // ��� �������
                      const int             sub_window=0,      // ����� ������� 
                      datetime              time1=0,           // ����� ������ �����
                      double                price1=0,          // ���� ������ �����
                      datetime              time2=0,           // ����� ������ �����
                      double                price2=0,          // ���� ������ �����
                      const color           clr=clrRed,        // ���� �������
                      const ENUM_LINE_STYLE style=STYLE_SOLID, // ����� ����� �������
                      const int             width=1,           // ������� ����� �������
                      const bool            back=false,        // �� ������ �����
                      const bool            selection=true,    // �������� ��� �����������
                      const bool            ray_right=false,   // ����������� ������� ������
                      const bool            hidden=true,       // ����� � ������ ��������
                      const long            z_order=0)         // ��������� �� ������� �����
  {
//--- ��������� ���������� ����� ��������, ���� ��� �� ������
   ChangeFiboLevelsEmptyPoints(time1,price1,time2,price2);
//--- ������� �������� ������
   ResetLastError();
//--- �������� "������ ���������" �� �������� �����������
   if(!ObjectCreate(chart_ID,name,OBJ_FIBO,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": �� ������� ������� \"������ ���������\"! ��� ������ = ",GetLastError());
      return(false);
     }
//--- ��������� ����
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- ��������� ����� �����
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- ��������� ������� �����
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- ��������� �� �������� (false) ��� ������ (true) �����
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- ������� (true) ��� �������� (false) ����� ��������� ������� ��� �����������
//--- ��� �������� ������������ ������� �������� ObjectCreate, �� ��������� ������
//--- ������ �������� � ����������. ������ �� ����� ������ �������� selection
//--- �� ��������� ����� true, ��� ��������� �������� � ���������� ���� ������
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- ������� (true) ��� �������� (false) ����� ����������� ����������� ������� ������
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- ������ (true) ��� ��������� (false) ��� ������������ ������� � ������ ��������
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- �������� ��������� �� ��������� ������� ������� ���� �� �������
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- �������� ����������
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<=period)
     {
      return (0);
     }
   int indicatorCounted=IndicatorCounted();
   if(indicatorCounted<0)
     {
      return (-1);
     }
   if(indicatorCounted>0)
     {
      indicatorCounted--;
     }
   int limit=Bars-indicatorCounted;
   for(int i=limit-1; i>=0; i--)
     {
      double atr=iATR(NULL,0,atrPeriod,i)*atrSensitivity;
      highMovingAverages[i]= iMA(NULL,0,period,0,MODE_LWMA,PRICE_HIGH,i) *(1+shiftPercent/100)+atr * atrSensitivity;
      lowMovingAverages[i] = iMA(NULL,0,period,0,MODE_LWMA,PRICE_LOW,i) *(1-shiftPercent/100)-atr * atrSensitivity;

      buffer[i]=buffer[i+1];
      if(Close[i]>highMovingAverages[i+1])
        {
         buffer[i]=1;
        }
      if(Close[i]<lowMovingAverages[i+1])
        {
         buffer[i]=-1;
        }
      if(buffer[i]>0.0)
        {
         if(lowMovingAverages[i]<lowMovingAverages[i+1])
           {
            lowMovingAverages[i]=lowMovingAverages[i+1];
           }

/*
         if (highMovingAverages[i] < highMovingAverages[i + 1]) {
            highMovingAverages[i] = highMovingAverages[i + 1];
         }
         */
         upValue[i]=lowMovingAverages[i];
         downValue[i]=EMPTY_VALUE;

           } else {
         if(highMovingAverages[i]>highMovingAverages[i+1])
           {
            highMovingAverages[i]=highMovingAverages[i+1];
           }

/*  
         if (lowMovingAverages[i] > lowMovingAverages[i + 1]) {
            lowMovingAverages[i] = lowMovingAverages[i + 1];
         }*/

         downValue[i]=highMovingAverages[i];
         upValue[i]=EMPTY_VALUE;
        }
     }

   if(upValue[1]<1000 && downValue[2]<1000)
     {
      ObjectDelete(0,"Fibo");
      FiboLevelsCreate(0,"Fibo",0,Time[0],downValue[2],Time[1],upValue[1],Red,STYLE_SOLID,1,false,true,false,false,0);
      ObjectSet("Fibo",OBJPROP_FIBOLEVELS,9);
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+0,0.0);
      ObjectSetFiboDescription("Fibo",0,"0.0  %$");
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+1,0.236);
      ObjectSetFiboDescription("Fibo",1,"23.6  %$");
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+2,0.382);
      ObjectSetFiboDescription("Fibo",2,"38.2  %$"); 
                       
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+3,0.5);
      ObjectSetFiboDescription("Fibo",3,"50.0  %$");
           
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+4,0.618);
      ObjectSetFiboDescription("Fibo",4,"61.8  %$");
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+5,1.0);
      ObjectSetFiboDescription("Fibo",5,"100.0  %$");
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+6,1.618);
      ObjectSetFiboDescription("Fibo",6,"161.8  %$"); 
                       
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+7,2.618);
      ObjectSetFiboDescription("Fibo",7,"261.8  %$"); 

      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+8,4.236);
      ObjectSetFiboDescription("Fibo",8,"423.6  %$");                        
     }

   if(downValue[1]<1000 && upValue[2]<1000)
     {
      ObjectDelete(0,"Fibo");
      FiboLevelsCreate(0,"Fibo",0,Time[0],upValue[2],Time[1],downValue[1],Red,STYLE_SOLID,1,false,true,false,false,0);
      ObjectSet("Fibo",OBJPROP_FIBOLEVELS,9);
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+0,0.0);
      ObjectSetFiboDescription("Fibo",0,"0.0  %$");
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+1,0.236);
      ObjectSetFiboDescription("Fibo",1,"23.6  %$");
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+2,0.382);
      ObjectSetFiboDescription("Fibo",2,"38.2  %$"); 
                       
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+3,0.5);
      ObjectSetFiboDescription("Fibo",3,"50.0  %$");
           
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+4,0.618);
      ObjectSetFiboDescription("Fibo",4,"61.8  %$");
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+5,1.0);
      ObjectSetFiboDescription("Fibo",5,"100.0  %$");
      
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+6,1.618);
      ObjectSetFiboDescription("Fibo",6,"161.8  %$"); 
                       
      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+7,2.618);
      ObjectSetFiboDescription("Fibo",7,"261.8  %$"); 

      ObjectSet("Fibo",OBJPROP_FIRSTLEVEL+8,4.236);
      ObjectSetFiboDescription("Fibo",8,"423.6  %$");       
     }

   Comment("\n UP: ",upValue[1],
           "\n DN: ",downValue[1]);
   return(0);
  }
//+------------------------------------------------------------------+
