//+------------------------------------------------------------------+
//|                                                      HistoryInfo |
//|                          Copyright © 2012-2018, Vladimir Hlystov |
//|                                               http://cmillion.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2018, Vladimir Hlystov"
#property link      "cmillion@narod.ru"
#property indicator_chart_window
#property strict

extern datetime   DateInfoStart = D'01.01.2017';  //начинать с даты
extern datetime   DateInfoEnd   = D'01.01.2030';  //заканчивая датой
extern color      WhiteColor    = clrDarkGray;    //цвет вывода информации
extern color      fon           = clrGray;        //цвет фона
extern ENUM_TIMEFRAMES TF_SendMail = 60;          //частота отправки почты

extern double     WidthWind     = 1.0;            // размер окна
extern int        WidthFont     = 10;             // размер шрифта 
extern int        dx            = 70;             //ширина между столбцами
extern int        dy            = 18;             //ширина между строк
int        st            = 9;              // число столбцов
//--------------------------------------------------------------------
string Symbl[100];
double HistoryOrders[5][50000],Orders[5][50000],SymbolProfit[100],SymbolHistoryProfit[100],MagikProfit[100],HistoryLot[2][100],TekLot[2][100];
int HistoryType[2][100],TekType[2][100];
int str=0,AN,Nsymb,Nmag,Ords=0,hn,Magik[100];
double Today[2][15],TodayR[2][15],TodayM[2][15];
datetime TimeSendMail,TimeSendMail_AFM;
int stold=0;
//--------------------------------------------------------------------
void  OnDeinit(const int reason)
{
   ObjectsDeleteAll(0);
}
//--------------------------------------------------------------------
int OnInit()
{
   EventSetTimer(1);
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,fon);//Цвет осей, шкалы и строки OHLC
   
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,fon);
   ChartSetInteger(0,CHART_FOREGROUND,false);//Ценовой график на переднем плане
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_BRING_TO_TOP,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
   ChartSetInteger(0,CHART_SHOW_BID_LINE,false);
   
   ChartSetInteger(0,CHART_SHOW_OHLC,false);
   ChartSetInteger(0,CHART_SHOW_LAST_LINE,false);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
   
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,fon);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,fon);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,fon);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,fon);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,fon);
   ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,fon);
   ChartSetInteger(0,CHART_COLOR_LAST,fon);
   ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,fon);
   ChartSetInteger(0,CHART_DRAG_TRADE_LEVELS,false);
   ChartSetInteger(0,CHART_SHOW_DATE_SCALE,false);
   ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,false);
   ChartSetInteger(0,CHART_COLOR_VOLUME,fon);

   Ords=0;
   ObjectsDeleteAll(0);
   dx=(int)(dx*WidthWind);
   dy=(int)(dy*WidthWind);

   AN = AccountNumber();
   int x=dx*4;
   EditCreate(0,"Date",0,0,0,x,dy,StringConcatenate(TimeToString(DateInfoStart)," - ",TimeToString(DateInfoEnd)),WidthFont);
   EditCreate(0,"st" ,0,500,dy,500,dy,"© 2018, http://cmillion.ru",WidthFont,clrBlack,fon,CORNER_RIGHT_LOWER,ALIGN_RIGHT,"Arial",false,fon);
   EditCreate(0,"History" ,0,0,dy,dx,dy,"История",WidthFont);
   EditCreate(0,"Orders h",0,0,dy*2,dx,dy*4,"0",WidthFont);

   ButtonCreate(0,"kn SendMailInfo",0,x,0,dx,dy,"SendMail","Arial",WidthFont-1,clrBlack,clrLightGray,clrNONE,false);x+=dx;
   ButtonCreate(0,"kn SendNot",0,x,0,dx,dy,"SendPUSH","Arial",WidthFont-1,clrBlack,clrLightGray,clrNONE,false);x+=dx;
   ButtonCreate(0,"kn ShowMagik",0,x,0,dx,dy,"ShowMagik","Arial",WidthFont-1,clrBlack,clrLightGray,clrNONE,true);x+=dx;
   ButtonCreate(0,"kn ShowDay",0,x,0,dx,dy,"ShowDay","Arial",WidthFont-1,clrBlack,clrLightGray,clrNONE,true);x+=dx;
   ButtonCreate(0,"kn ShowReb",0,x,0,dx,dy,"ShowReb","Arial",WidthFont-1,clrBlack,clrLightGray,clrNONE,false);

   return(INIT_SUCCEEDED);
}   
//--------------------------------------------------------------------
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
     return(rates_total);
  }
//+------------------------------------------------------------------+
void OnTimer()
{
   double AFM = AccountFreeMargin();
   double AB = AccountBalance();
   double AE = AccountEquity();
   int i,j;
   double ProfitAll=0;
   //===
   string txtInfo;
   //---
   int tn=TekOrders();
   int n=0;

   bool SendMailInfo=ObjectGetInteger(0,"kn SendMailInfo",OBJPROP_STATE); 
   bool SendNot=ObjectGetInteger(0,"kn SendNot",OBJPROP_STATE); 
   bool ShowDay=ObjectGetInteger(0,"kn ShowDay",OBJPROP_STATE); 
   bool ShowReb=ObjectGetInteger(0,"kn ShowReb",OBJPROP_STATE); 
   if (!ShowDay) ObjectsDeleteAll(0,"ShowDay");
   if (!ShowReb) ObjectsDeleteAll(0,"ShowReb");
   int winpixel=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
   st = (int)MathFloor(winpixel/(dx*WidthWind))-(7-((ShowDay?0:4)+(ShowReb?0:2)));
   if (st!=stold)
   {
      stold=st;
      Ords=0;
   }
   //ObjectSetString(0,"st",OBJPROP_TEXT,StringConcatenate(winpixel," || ",MathFloor(winpixel/dx)," || ",dx," || ",st));
   
   //EditCreate(0,"0",0,0,0,500,dy,StringConcatenate(TimeCurrent(),"  ",Ords,"  ",ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0)),WidthFont);
   if (Ords>tn || Ords==0)// || MaxX!=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS ,0)-12*dx)
   {
      //MaxX=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS ,0)-12*dx;
      str=0;
      hn=HistoryOrders();
      if (hn>50000) {Alert("Переполнение буфера",OrdersHistoryTotal());return;}
      ArrayInitialize(HistoryType,0);
      ArrayInitialize(HistoryLot,0);
      for (i=0; i<=Nsymb; i++)
      {                                               
         SymbolHistoryProfit[i]=0;
         for (j=0; j<hn; j++)
         {
            if (i == HistoryOrders[0][j])//Symbol
            {
               SymbolHistoryProfit[i]+=HistoryOrders[2][j];//профит 
               if (HistoryOrders[1][j]==OP_BUY) {HistoryType[0][i]++;HistoryLot[0][i]+=HistoryOrders[3][j];}
               if (HistoryOrders[1][j]==OP_SELL) {HistoryType[1][i]++;HistoryLot[1][i]+=HistoryOrders[3][j];}
            }
         }
      }
      ProfitAll=0;
      if (SendMailInfo || SendNot) txtInfo=StringConcatenate("Account statement ",AN," ",AccountCompany()," date ",TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES),"\n\nHistory\n====================\n");
      
      for (i=0; i<=Nsymb; i++)
      {  
         if (StringLen(Symbl[i])<2) continue;
         if (SymbolHistoryProfit[i]==0) continue;
         EditCreate(0,Symbl[i],0,                            dx+dx*n, dy*(1+str*5), dx,dy,Symbl[i],WidthFont,clrBlack,clrAquamarine);//символ
         EditCreate(0,StringConcatenate(Symbl[i],"profit"),0,dx+dx*n, dy*(2+str*5), dx,dy,DoubleToStr(SymbolHistoryProfit[i],2),WidthFont,Color(SymbolHistoryProfit[i]));//профит
         EditCreate(0,StringConcatenate(Symbl[i],"lot"),0,   dx+dx*n, dy*(3+str*5), dx,dy,"тип   Lot ",WidthFont-2,SteelBlue);//всего Buy
         EditCreate(0,StringConcatenate(Symbl[i],"b"),0,     dx+dx*n, dy*(4+str*5), dx,dy,StringConcatenate("B ",HistoryType[0][i]," / ",DoubleToStr(HistoryLot[0][i],2)),WidthFont-2,WhiteColor);//всего Buy
         EditCreate(0,StringConcatenate(Symbl[i],"s"),0,     dx+dx*n, dy*(5+str*5), dx,dy,StringConcatenate("S ",HistoryType[1][i]," / ",DoubleToStr(HistoryLot[1][i],2)),WidthFont-2,WhiteColor);//всего Sell
         ProfitAll+=SymbolHistoryProfit[i];
         n++;
         if (n>=st) 
         {
            n=0;str++;
         }
         if (SendMailInfo || SendNot) 
            txtInfo=StringConcatenate(txtInfo,Symbl[i],"   Buy ",Ch32(HistoryType[0][i],0),"   lot ",Ch32(HistoryLot[0][i],2),"   Sell ",Ch32(HistoryType[1][i],0),"   lot ",Ch32(HistoryLot[1][i],2),"   ",DoubleToStr(SymbolHistoryProfit[i],2),"\n");
      }
      if (SendMailInfo || SendNot) txtInfo=StringConcatenate(txtInfo,"====================\nTOTAL"," ",DoubleToStr(ProfitAll,2),"\n\n");
      EditCreate(0,"symbolAll",0,dx+dx*n, dy*(1+str*5), dx,dy,"ИТОГО",WidthFont,clrSteelBlue);//шапка
      EditCreate(0,"profitAll",0,dx+dx*n, dy*(2+str*5), dx,dy,DoubleToStr(ProfitAll,2),WidthFont,Color(ProfitAll));//общий профит
      //i+=(int)(2*WidthWind);
      if (ShowDay)
      {
         double AccBal=AB;
         EditCreate(0,"ShowDay Yesterday 0",0,(ShowReb?dx*2:0)+dx*2,0,dx*2,dy,"Прибыль",WidthFont,clrBlack,clrAquamarine,1);
         if (ShowReb) EditCreate(0,"ShowReb M 0",0,dx*2,0,dx,dy,"ввод/вывод",WidthFont,clrBlack,clrAquamarine,1);
         if (ShowReb) EditCreate(0,"ShowReb R 0",0,dx,0,dx,dy,"Rebait",WidthFont,clrBlack,clrAquamarine,1);
         for (j=0; j<15; j++)
         { 
            AccBal-=Today[0][j];
            if (NormalizeDouble(AccBal,2)==0) AccBal=100;
            EditCreate(0,StringConcatenate("ShowDay Yesterday T",j),0,(ShowReb?dx*2:0)+dx*3.5,dy+dy*j,dx,dy,TimeToStr(iTime(NULL,1440,j),TIME_DATE),                     WidthFont-1,Color(Today[0][j]),clrWhite,1);
            EditCreate(0,StringConcatenate("ShowDay Yesterday N",j),0,(ShowReb?dx*2:0)+dx*2.5,dy+dy*j,dx/2,dy,DoubleToStr(Today[1][j],0),                                WidthFont,Color(Today[0][j]),clrWhite,1);
            EditCreate(0,StringConcatenate("ShowDay Yesterday P",j),0,(ShowReb?dx*2:0)+dx*2,  dy+dy*j,dx*1.3,dy,DoubleToStr(Today[0][j],2),                              WidthFont,Color(Today[0][j]),clrWhite,1);
            EditCreate(0,StringConcatenate("ShowDay Yesterday %",j),0,(ShowReb?dx*2:0)+dx*0.7,dy+dy*j,dx*0.7,dy,StringConcatenate(DoubleToStr(100*Today[0][j]/AccBal,2),"%"),WidthFont-1,Color(Today[0][j]),clrWhite,1);
            //if (TodayR[0][j]!=0) EditCreate(0,StringConcatenate("YesterdayRebN ",j),0, dx/2, dy+dy*j,dx,dy,DoubleToStr(TodayR[1][j],0),       WidthFont,Color(TodayR[0][j]),clrWhite,1); else ObjectDelete(StringConcatenate("YesterdayRebN ",j));
            if (ShowReb && TodayR[0][j]!=0) EditCreate(0,StringConcatenate("ShowReb Reb ",j),0, dx, dy+dy*j,dx,dy,DoubleToStr(TodayR[0][j],2),            WidthFont,Color(TodayR[0][j]),clrWhite,1); else ObjectDelete(StringConcatenate("YesterdayReb ",j));
            //if (TodayM[0][j]!=0) EditCreate(0,StringConcatenate("YesterdayManN ",j),0, dx*2, dy+dy*j,dx/2,dy,DoubleToStr(TodayM[1][j],0),     WidthFont,Color(TodayM[0][j]),clrWhite,1); else ObjectDelete(StringConcatenate("YesterdayManN ",j));
            if (ShowReb && TodayM[0][j]!=0) EditCreate(0,StringConcatenate("ShowReb Man ",j),0, dx*2, dy+dy*j,dx,dy,DoubleToStr(TodayM[0][j],2),          WidthFont,Color(TodayM[0][j]),clrWhite,1); else ObjectDelete(StringConcatenate("YesterdayMan ",j));
         }
      }
   }
   //==================
   //--- текущие ордера
   //==================
   EditCreate(0,"Текушие" ,0,0,dy*7+dy*str*5,dx,dy,"Текушие",WidthFont);
   EditCreate(0,"Orders f",0,0,dy*8+dy*str*5,dx,dy*3,"0",WidthFont);
   if (tn>50000) {Alert("Переполнение буфера",OrdersTotal());return;}
   ArrayInitialize(TekType,0);
   ArrayInitialize(TekLot,0);
   for (i=0; i<Nsymb+1; i++)
   {                                               
      SymbolProfit[i]=0;
      for (j=0; j<tn; j++)
      {
         if (i == Orders[0][j])//Symbol
         {
            SymbolProfit[i]+=Orders[2][j];//профит 
            if (Orders[1][j]==OP_BUY)  {TekType[0][i]++;TekLot[0][i]+=Orders[3][j];}
            if (Orders[1][j]==OP_SELL) {TekType[1][i]++;TekLot[1][i]+=Orders[3][j];}
         }
      }
   }
   ProfitAll=0;
   if (txtInfo!="" && (SendMailInfo || SendNot)) txtInfo=StringConcatenate(txtInfo,"\nFloating\n====================\n");
   n=0;
   int str1=0;
   for (i=0; i<=Nsymb; i++)
   {  
      //RectLabelCreate(0,StringConcatenate("cm t w",i),Win,69+79*i,89,80,60,clrIvory);
      if (StringLen(Symbl[i])<2) continue;
      if (SymbolProfit[i]==0) continue;
      EditCreate(0,StringConcatenate(Symbl[i],"T"),      0,dx+dx*n,dy*7 +dy*str*5+dy*str1*4,dx,dy,Symbl[i],WidthFont,clrBlack,clrAquamarine);//символ
      EditCreate(0,StringConcatenate(Symbl[i],"profitT"),0,dx+dx*n,dy*8 +dy*str*5+dy*str1*4,dx,dy,DoubleToStr(SymbolProfit[i],2),WidthFont,                                          Color(SymbolProfit[i]));//профит
      EditCreate(0,StringConcatenate(Symbl[i],"bT"),     0,dx+dx*n,dy*9 +dy*str*5+dy*str1*4,dx,dy,StringConcatenate("B ",TekType[0][i]," / ",DoubleToStr(TekLot[0][i],2)),WidthFont-2,WhiteColor);//всего Buy
      EditCreate(0,StringConcatenate(Symbl[i],"sT"),     0,dx+dx*n,dy*10+dy*str*5+dy*str1*4,dx,dy,StringConcatenate("S ",TekType[1][i]," / ",DoubleToStr(TekLot[1][i],2)),WidthFont-2,WhiteColor);//всего Sell
      ProfitAll+=SymbolProfit[i];
      n++;if (n>=st) {n=0;str1++;}
      if (txtInfo!="" && (SendMailInfo || SendNot) && (TekType[0][i]!=0 || TekType[1][i]!=0)) 
         txtInfo=StringConcatenate(txtInfo,Symbl[i],"   Buy ",Ch32(TekType[0][i],0),"   lot ",Ch32(TekLot[0][i],2),"   Sell ",Ch32(TekType[1][i],0),"   lot ",Ch32(TekLot[1][i],2),"   ",DoubleToStr(SymbolProfit[i],2),"\n");
   }
   //RectLabelCreate(0,"cm t wi",Win,69+79*i,89,80,60,clrIvory);
   if (txtInfo!="") txtInfo=StringConcatenate(txtInfo,"====================\nTOTAL ",DoubleToStr(ProfitAll,2),"\n\n");
   EditCreate(0,"symbolAllT",0,dx+dx*n,dy*7+dy*str*5+dy*str1*4,dx,dy,"ИТОГО",WidthFont,clrSteelBlue);//шапка
   EditCreate(0,"profitAllT",0,dx+dx*n,dy*8+dy*str*5+dy*str1*4,dx,dy,DoubleToStr(ProfitAll,2),WidthFont,Color(ProfitAll));//общий профит
   //---
   if (ObjectGetInteger(0,"kn ShowMagik",OBJPROP_STATE)) 
   {
      EditCreate(0,"Magik P",0,0,dy*(12+str*5+str1*4), dx,dy,"Магик",WidthFont);
      for (i=0; i<=Nmag; i++)
      {                                               
         MagikProfit[i]=0;
         for (j=0; j<hn; j++)
         {
            if (i == HistoryOrders[4][j])//Magik
            {
               MagikProfit[i]+=HistoryOrders[2][j];//профит 
            }
         }
      }
      n=0;
      int str2=0;
      ProfitAll=0;
      for (i=0; i<=Nmag; i++)
      {  
         //if (Magik[i]==0) continue;
         if (MagikProfit[i]==0) continue;
         EditCreate(0,StringConcatenate("Magik ",Magik[i],"M"),0      ,dx+dx*n, dy*(12+str*5+str1*4+str2*2), dx,dy,DoubleToStr(Magik[i],0),           WidthFont,clrBlack,clrAquamarine);//символ
         EditCreate(0,StringConcatenate("Magik ",Magik[i],"profitM"),0,dx+dx*n, dy*(13+str*5+str1*4+str2*2), dx,dy,DoubleToStr(MagikProfit[i],2),WidthFont,Color(MagikProfit[i]));//профит
         ProfitAll+=MagikProfit[i];
         n++;if (n>=st) {n=0;str2++;}
      }
      EditCreate(0,"Magik magAll"    ,0,dx+dx*n, dy*(12+str*5+str1*4+str2*2) ,dx,dy,"ИТОГО",                     WidthFont,SteelBlue);//шапка
      EditCreate(0,"Magik profitAllM",0,dx+dx*n, dy*(13+str*5+str1*4+str2*2) ,dx,dy,DoubleToStr(ProfitAll,2),WidthFont,Color(ProfitAll));//общий профит
   }
   else ObjectsDeleteAll(0,"Magik");
   //---
   ObjectSetText("Orders h",IntegerToString(hn), WidthFont, "Tahoma", WhiteColor);
   ObjectSetText("Orders f",IntegerToString(tn), WidthFont, "Tahoma", WhiteColor);
   //ObjectSetText("2",StringConcatenate("Symbols  ",Nsymb+1), 8, "Tahoma", WhiteColor);
   //ObjectSetText("3",StringConcatenate("Equity     ",DoubleToStr(AE,2)), 8, "Tahoma", WhiteColor);
   //ObjectSetText("4",StringConcatenate("Balance   ",DoubleToStr(AB,2)), 8, "Tahoma", WhiteColor);
   //ObjectSetText("5",StringConcatenate("FreeMar. ",DoubleToStr(AFM,2)), 8, "Tahoma", WhiteColor);
   if (SendMailInfo && Ords>tn && iTime(NULL,TF_SendMail,0)!=TimeSendMail) 
   {
      SendMail(StringConcatenate("cm History Info ",AccountCompany()," ",AN),
               StringConcatenate(txtInfo,"\nProfit ",TimeToStr(iTime(NULL,1440,0),TIME_DATE)," = ",DoubleToStr(Today[0][0],2),
                                 "\nRebait ",TimeToStr(iTime(NULL,1440,0),TIME_DATE)," = ",DoubleToStr(TodayR[0][0],2),
                                 "\n\nAll orders ",OrdersTotal()," market ",tn,
                                 "\nEquity     ",DoubleToStr(AccountEquity(),2),
                                 "\nFreeMargin ",DoubleToStr(AFM,2),
                                 "\nBalance    ",DoubleToStr(AB,2)));
      TimeSendMail = iTime(NULL,TF_SendMail,0);
   }
   if (SendNot && Ords>tn) 
   {
      SendNotification(StringConcatenate("cm History Info ",AccountCompany()," ",AN,txtInfo,"\nProfit ",TimeToStr(iTime(NULL,1440,0),TIME_DATE)," = ",DoubleToStr(Today[0][0],2),
                                 "\nRebait ",TimeToStr(iTime(NULL,1440,0),TIME_DATE)," = ",DoubleToStr(TodayR[0][0],2),
                                 "\n\nAll orders ",OrdersTotal()," market ",tn,
                                 "\nEquity     ",DoubleToStr(AccountEquity(),2),
                                 "\nFreeMargin ",DoubleToStr(AFM,2),
                                 "\nBalance    ",DoubleToStr(AB,2)));
   }
   Ords=tn;
}
//--------------------------------------------------------------------
int SymbolNum(string Symb)
{
   int i;
   for (i=0; i<100; i++)
   {                                               
      if (Symb==Symbl[i]) return(i);
      if (StringLen(Symbl[i])<2) break;
   }
   Symbl[i]=Symb;
   Nsymb=i;
   return(i);
}
//--------------------------------------------------------------------
int MagikNum(int Magic)
{
   int i;
   for (i=0; i<100; i++)
   {                                               
      if (Magic==Magik[i]) return(i);
      if (Magik[i]==0) break;
   }
   Magik[i]=Magic;
   Nmag=i;
   return(i);
}
//--------------------------------------------------------------------
int HistoryOrders()                                  
{
   int n=0,OMN,tipOrders,j;
   string Symb;
   datetime OCT,StartInfo=Time[0],EndInfo=0;
   double Profit;
   ArrayInitialize(Today,0);
   ArrayInitialize(TodayR,0);
   ArrayInitialize(TodayM,0);
   ArrayInitialize(HistoryOrders,0);
   for (int i=OrdersHistoryTotal()-1; i>=0; i--)
   {             
      Symb=NULL;                                  
      if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
      {
         Symb = OrderSymbol();
         OMN = OrderMagicNumber();
         Profit = OrderProfit()+OrderSwap()+OrderCommission();
         OCT = OrderCloseTime();
         if (Symb=="") tipOrders=2;
         else tipOrders=TipOrders(OrderComment());
         switch(tipOrders)
         {
            case 0://обычные ордера
               if (OCT>=iTime(NULL,1440,0)) {Today[0][0]+=Profit;Today[1][0]++;}
               for (j=0; j<15; j++) {if (OCT>=iTime(NULL,1440,j) && OCT<iTime(NULL,1440,j-1)) {Today[0][j]+=Profit;Today[1][j]++;}}
               break;
            case 1://ребайт
               if (OCT>=iTime(NULL,1440,0)) {TodayR[0][0]+=Profit;TodayR[1][0]++;}
               for (j=0; j<15; j++) {if (OCT>=iTime(NULL,1440,j) && OCT<iTime(NULL,1440,j-1)) {TodayR[0][j]+=Profit;TodayR[1][j]++;}}
               break;
            case 2://доливки и снятие
               if (OCT>=iTime(NULL,1440,0)) {TodayM[0][0]+=Profit;TodayM[1][0]++;}
               for (j=0; j<15; j++) {if (OCT>=iTime(NULL,1440,j) && OCT<iTime(NULL,1440,j-1)) {TodayM[0][j]+=Profit;TodayM[1][j]++;}}
               break;
            default:
               continue;
         }
         if (OCT>=DateInfoStart && OCT<DateInfoEnd)
         {
            if (OrderType()==OP_BUY)
            {
               if (StartInfo>OCT) StartInfo=OCT;
               if (EndInfo<OCT) EndInfo=OCT;
               HistoryOrders[0][n]=SymbolNum(Symb);
               HistoryOrders[1][n]=OP_BUY;
               HistoryOrders[2][n]=Profit;
               HistoryOrders[3][n]=OrderLots();
               HistoryOrders[4][n]=MagikNum(OMN);
               n++;
            }
            if (OrderType()==OP_SELL)
            {
               if (StartInfo>OCT) StartInfo=OCT;
               if (EndInfo<OCT) EndInfo=OCT;
               HistoryOrders[0][n]=SymbolNum(Symb);
               HistoryOrders[1][n]=OP_SELL;
               HistoryOrders[2][n]=Profit;
               HistoryOrders[3][n]=OrderLots();
               HistoryOrders[4][n]=MagikNum(OMN);
               n++;
            }
         }
      }   
      if (n>50000) {Comment("Переполнение буфера",OrdersHistoryTotal());return(n);}
   }
   //---
   string TimeSkan;
   double TS = MathCeil((EndInfo-StartInfo)/86400);   //время сканирования в часах
   if (TS>=0)
   {
      if (TS>0) TimeSkan = StringConcatenate(TS," дн.");
      if (TS==0) TimeSkan = "1 день";
   }
   
   if (EndInfo!=0) ObjectSetText("DateInfo", StringConcatenate("Сканирование счета с ",TimeToStr(StartInfo,TIME_DATE)," по ",TimeToStr(EndInfo,TIME_DATE)," всего ",TimeSkan), 8, "Tahoma", WhiteColor);
   else ObjectSetText("DateInfo",StringConcatenate("За данный период с ",TimeToStr(DateInfoStart,TIME_DATE)," по ",TimeToStr(DateInfoEnd,TIME_DATE)," не было сделок"), 8, "Tahoma", Red);
   return(n);
}
//--------------------------------------------------------------------
int TekOrders()                                  
{
   int n=0,OMN;
   string Symb;
   datetime OOT;
   ArrayInitialize(Orders,0);
   for (int i=OrdersHistoryTotal()-1; i>=0; i--)
   {                                               
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         Symb = OrderSymbol();
         OMN = OrderMagicNumber();
         OOT = OrderOpenTime();
         if (DateInfoStart>=OOT || DateInfoEnd<OOT) continue;
         if (OrderType()==OP_BUY)
         {
            Orders[0][n]=SymbolNum(Symb);
            Orders[1][n]=OP_BUY;
            Orders[2][n]=OrderProfit()+OrderSwap()+OrderCommission();
            Orders[3][n]=OrderLots();
            Orders[4][n]=MagikNum(OMN);
            n++;
         }
         if (OrderType()==OP_SELL)
         {
            Orders[0][n]=SymbolNum(Symb);
            Orders[1][n]=OP_SELL;
            Orders[2][n]=OrderProfit()+OrderSwap()+OrderCommission();
            Orders[3][n]=OrderLots();
            Orders[4][n]=MagikNum(OMN);
            n++;
         }
      }   
      if (n>50000) {Comment("Переполнение буфера",OrdersHistoryTotal());return(n);}
   }
   return(n);
}
//--------------------------------------------------------------------
color Color(double x)
{
   if (x<0) return(Red);
   if (x>0) return(Green);
   else return(WhiteColor);
}
//--------------------------------------------------------------------
bool EditCreate(const long             chart_ID=0,               // ID графика 
                const string           name="Edit",              // имя объекта 
                const int              sub_window=0,             // номер подокна 
                const double              x=0,                      // координата по оси X 
                const double              y=0,                      // координата по оси Y 
                const double              w=50,                 // ширина 
                const double              h=18,                // высота 
                const string           text="Text",              // текст 
                const int              font_size=10,             // размер шрифта 
                const color            clr=clrBlack,             // цвет текста 
                const color            back_clr=clrWhite,        // цвет фона 
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // угол графика для привязки 
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // способ выравнивания 
                const string           font="Arial",             // шрифт 
                const bool             read_only=true,          // возможность редактировать 
                const color            border_clr=clrNONE,       // цвет границы 
                const bool             back=false,               // на заднем плане 
                const bool             selection=false,          // выделить для перемещений 
                const bool             hidden=true,              // скрыт в списке объектов 
                const long             z_order=0)                // приоритет на нажатие мышью 
  { 
   int x1=(int)(x*WidthWind);
   int y1=(int)(y*WidthWind);
   int width=(int)(w*WidthWind);
   int height=(int)(h*WidthWind);
   if(ObjectFind(chart_ID,name)==-1) 
   { 
      if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0)) 
        { 
         Print(__FUNCTION__, 
               ": не удалось создать объект \"Поле ввода\"! Код ошибки = ",GetLastError()); 
         return(false); 
        } 
      ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align); 
      ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only); 
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr); 
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x1); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y1); 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
   return(true); 
  } 
//--------------------------------------------------------------------
string Ch32(double n,int k)
{
   string text=DoubleToStr(n,k);
   if (n>1000) return(text);
   if (n>100) return(text+" ");
   if (n>10) return(text+"  ");
   return(text+"   ");
}
//--------------------------------------------------------------------
int TipOrders(string comm)
{
   if (StringLen(comm)==0) return(0);
   if (StringFind(comm, "cancelled", 0) !=- 1) return(3);//отмененный ордер
   if (StringFind(comm, "INSTAREBATE AFFILIATE", 0) !=- 1) return(1);
   if (StringFind(comm, "Rebate", 0) !=- 1) return(1);
   if (StringFind(comm, "BONUS", 0) !=- 1) return(2);
   if (StringFind(comm, "IR", 0) !=- 1) return(2);
   if (StringFind(comm, "trade result for", 0) !=- 1) return(3);
   if (StringFind(comm, "INSTAFOREX VPS SERVICE", 0) !=- 1) return(2);
   if (StringFind(comm, "Deposit", 0) !=- 1) return(2);
   if (StringFind(comm, "LRU", 0) !=- 1) return(2);
   if (StringFind(comm, "Yandex", 0) !=- 1) return(2);
   if (StringFind(comm, "POU", 0) !=- 1) return(2);
   if (StringFind(comm, "YM", 0) !=- 1) return(2);
   if (StringFind(comm, "Z", 0) !=- 1) return(2);
   if (StringFind(comm, "RBK", 0) !=- 1) return(2);
   if (StringFind(comm, "QIWI", 0) !=- 1) return(2);
   if (StringFind(comm, "R", 0) !=- 1) return(2);
   if (StringFind(comm, "CANCEL", 0) !=- 1) return(2);
   if (StringFind(comm, "LBR", 0) !=- 1) return(2);
   if (StringFind(comm, "Decline exchange", 0) !=- 1) return(2);
   if (StringFind(comm, "FORUM AFFILIATE", 0) !=- 1) return(2);
   
   
   return(0);
}
//--------------------------------------------------------------------
bool ButtonCreate(const long              chart_ID=0,               // ID графика
                  const string            name="Button",            // имя кнопки
                  const int               sub_window=0,             // номер подокна
                  const long              x1=0,                      // координата по оси X
                  const long              y1=0,                      // координата по оси Y
                  const int               width1=50,                 // ширина кнопки
                  const int               height1=18,                // высота кнопки
                  const string            text="Button",            // текст
                  const string            font="Arial",             // шрифт
                  const int               font_size=10,             // размер шрифта
                  const color             clr=clrRed,               // цвет текста
                  const color             clrfon=clrBlack,          // цвет фона
                  const color             border_clr=clrNONE,       // цвет границы
                  const bool              state=false,       // цвет границы
                  const ENUM_BASE_CORNER  CORNER=CORNER_LEFT_UPPER)
  {
   int x=(int)(x1*WidthWind);
   int y=(int)(y1*WidthWind);
   int width=(int)(width1*WidthWind);
   int height=(int)(height1*WidthWind);
   if (ObjectFind(chart_ID,name)==-1)
   {
      ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,CORNER);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,0);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,1);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,1);
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
   }
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,clrfon);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
   return(true);
}
//--------------------------------------------------------------------
