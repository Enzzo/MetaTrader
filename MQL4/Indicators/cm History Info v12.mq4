//+------------------------------------------------------------------+
//|                                                      HistoryInfo |
//|                               Copyright © 2012, Vladimir Hlystov |
//|                                         http://cmillion.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Vladimir Hlystov"
#property link      "cmillion@narod.ru"
#property indicator_separate_window
extern int        MagikInfo     = 0;              //если 0 то все магики
extern int        Shift         = 80;             //ширина между столбцами
extern string     SybmolInfo    = "";             //если "" то все инструменты
extern datetime   DateInfoStart = D'01.12.2012';  //начинать с даты
extern datetime   DateInfoEnd   = D'01.01.2030';  //заканчивая датой
extern color      WhiteColor    = DarkGray;       //цвет вывода информации
extern bool       SendMailInfo  = true;           //отправка информации на почту
extern int        TF_SendMail   = 60;             //отправлять не чаще, чем таймфрейм " 1,5,15,30 мин,   60 час,   240 4 часа";
                                                  //1440 день 10080 1 неделя 43200 1 месяц;
extern bool       ShowMagik     = false;          //показывать строку по магикам
//--------------------------------------------------------------------
string Symbl[100],NameInd;
double HistoryOrders[5][50000],Orders[5][50000],SymbolProfit[100],SymbolHistoryProfit[100],MagikProfit[100],HistoryLot[2][100],TekLot[2][100];
int HistoryType[2][100],TekType[2][100];
int Nsymb,Nmag,Win,Ords=0,hn,Magik[100];
double Today[2][15],TodayR[2][15],TodayM[2][15];
datetime TimeSendMail,TimeSendMail_AFM;
//--------------------------------------------------------------------
int deinit()
{
   ObjectsDeleteAll(Win);
   return(0);
}
//--------------------------------------------------------------------
int init()
{
   NameInd = WindowExpertName();
   return(0);
}   
//--------------------------------------------------------------------
int start()                                  
{
   double AFM = AccountFreeMargin();
   double AB = AccountBalance();
   int AN = AccountNumber();
   if (SendMailInfo && AB/3>AFM && iTime(NULL,TF_SendMail,0)!=TimeSendMail_AFM) 
   {
      SendMail(StringConcatenate(NameInd," ",AccountCompany()," ",AN),
               StringConcatenate("Недостаточно свободных средств, пополните баланс счета ",AN,"\n\nProfit ",TimeToStr(iTime(NULL,1440,0),TIME_DATE)," = ",DoubleToStr(Today[0][0],2),
                                 "\nRebait ",TimeToStr(iTime(NULL,1440,0),TIME_DATE)," = ",DoubleToStr(TodayR[0][0],2),
                                 "\n\nВсего ордеров ",OrdersTotal(),
                                 "\nEquity     ",DoubleToStr(AccountEquity(),2),
                                 "\nFreeMargin ",DoubleToStr(AFM,2),
                                 "\nBalance    ",DoubleToStr(AB,2)));
      TimeSendMail_AFM  = iTime(NULL,TF_SendMail,0);
   }

   //===

   string txtInfo;
   if (Win==0)
   {
      Win = WindowFind(NameInd);
      Text("DateInfo",StringConcatenate("Сканирование счета с ",TimeToStr(DateInfoStart,TIME_DATE)," по ",TimeToStr(DateInfoEnd,TIME_DATE)),500,2,WhiteColor,8);//шапка
      string txt;
      if (MagikInfo==0) txt = "Magik номера - ВСЕ";
      else  txt = StringConcatenate("Magik номер - ",MagikInfo);
      Text("Magik",txt,850,2,WhiteColor,8);//шапка
      ObjectCreate("c", OBJ_LABEL, Win, 0, 0);
      ObjectSet("c", OBJPROP_CORNER, 2);
      ObjectSet("c", OBJPROP_YDISTANCE, 5);
      ObjectSet("c", OBJPROP_XDISTANCE, 5);
      ObjectSetText("c", "Copyright © 2012 cmillion@narod.ru", 8, "Tahoma", WhiteColor);
      Text("0","Счет "+AN+" / "+AccountCompany()+" / 1:"+AccountLeverage(),100,2,WhiteColor,8);//шапка
      Text("Orders h"," ",120,35,WhiteColor,8);
      Text("Orders f"," ",120,108,WhiteColor,8);
      Text("2"," ",5,20,WhiteColor,8);
      Text("3"," ",5,30,WhiteColor,8);
      Text("4"," ",5,40,WhiteColor,8);
      Text("5"," ",5,50,WhiteColor,8);
      Text("History","История",120,20,SteelBlue,10);
      Text("Текушие","Текушие",120,93,SteelBlue,10);
      if (ShowMagik) Text("MagikP","Магик",100,165,SteelBlue,10);
   }
   //---
   int StartShift=200;
   int tn=TekOrders();
   if (Ords>tn || Ords==0)
   {
      hn=HistoryOrders();
      if (hn>50000) {Alert("Переполнение буфера",OrdersHistoryTotal());return(0);}
      ArrayInitialize(HistoryType,0);
      ArrayInitialize(HistoryLot,0);
      for (int i=0; i<=Nsymb; i++)
      {                                               
         SymbolHistoryProfit[i]=0;
         for (int j=0; j<hn; j++)
         {
            if (i == HistoryOrders[0][j])//Symbol
            {
               SymbolHistoryProfit[i]+=HistoryOrders[2][j];//профит 
               if (HistoryOrders[1][j]==OP_BUY) {HistoryType[0][i]++;HistoryLot[0][i]+=HistoryOrders[3][j];}
               if (HistoryOrders[1][j]==OP_SELL) {HistoryType[1][i]++;HistoryLot[1][i]+=HistoryOrders[3][j];}
            }
         }
      }
      double ProfitAll;
      if (SendMailInfo) txtInfo=StringConcatenate("Account statement ",AN," ",AccountCompany()," date ",TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES),"\n\nHistory\n====================\n");
      for (i=0; i<=Nsymb; i++)
      {  
         if (StringLen(Symbl[i])<2) continue;
         Text(Symbl[i],                            Symbl[i],                                                                        StartShift+Shift*i,20,SteelBlue,10);//символ
         Text(StringConcatenate(Symbl[i],"profit"),DoubleToStr(SymbolHistoryProfit[i],2),                                           StartShift+Shift*i,35,Color(SymbolHistoryProfit[i]),9);//профит
         Text(StringConcatenate(Symbl[i],"lot"),  "тип   Lot ",                                                                     StartShift+Shift*i,48,SteelBlue,8);//всего Buy
         Text(StringConcatenate(Symbl[i],"b"),     StringConcatenate("B ",HistoryType[0][i],"    ",DoubleToStr(HistoryLot[0][i],2)),StartShift+Shift*i,60,Color(SymbolHistoryProfit[i]),8);//всего Buy
         Text(StringConcatenate(Symbl[i],"s"),     StringConcatenate("S ",HistoryType[1][i],"    ",DoubleToStr(HistoryLot[1][i],2)),StartShift+Shift*i,70,Color(SymbolHistoryProfit[i]),8);//всего Sell
         ProfitAll+=SymbolHistoryProfit[i];
         if (SendMailInfo) 
            txtInfo=StringConcatenate(txtInfo,Symbl[i],"   Buy ",Ch32(HistoryType[0][i],0),"   lot ",Ch32(HistoryLot[0][i],2),"   Sell ",Ch32(HistoryType[1][i],0),"   lot ",Ch32(HistoryLot[1][i],2),"   ",DoubleToStr(SymbolHistoryProfit[i],2),"\n");
      }
      if (SendMailInfo) txtInfo=StringConcatenate(txtInfo,"====================\nTOTAL"," ",DoubleToStr(ProfitAll,2),"\n\n");
      Text("symbolAll","ИТОГО",                 StartShift+Shift*i,20,SteelBlue,10);//шапка
      Text("profitAll",DoubleToStr(ProfitAll,2),StartShift+Shift*i,35,Color(ProfitAll),10);//общий профит
      i+=2;
      double AccBal=AB;
      Text("Yesterday 0","Прибыль",StartShift+Shift*i+110,20,WhiteColor,10);
      Text("YesterdayR 0","Rebait",StartShift+Shift*i+270,20,WhiteColor,10);
      Text("YesterdayM 0","ввод/вывод",StartShift+Shift*i+390,20,WhiteColor,10);
      for (j=0; j<=15; j++)
      { 
         AccBal-=Today[0][j];
         if (NormalizeDouble(AccBal,2)==0) AccBal=100;
         Text("Yesterday T"+j,TimeToStr(iTime(NULL,1440,j),TIME_DATE),                       StartShift+Shift*i,     35+12*j,Color(Today[0][j]),10);
         Text("Yesterday N"+j,DoubleToStr(Today[1][j],0),                                    StartShift+Shift*i+80,  35+12*j,Color(Today[0][j]),10);
         Text("Yesterday P"+j,DoubleToStr(Today[0][j],2),                                    StartShift+Shift*i+110, 35+12*j,Color(Today[0][j]),10);
         Text("Yesterday %"+j,StringConcatenate(DoubleToStr(100*Today[0][j]/AccBal,1),"%"),  StartShift+Shift*i+180, 35+12*j,Color(Today[0][j]),10);
         if (TodayR[0][j]!=0) Text("YesterdayRebN "+j,DoubleToStr(TodayR[1][j],0),           StartShift+Shift*i+250, 35+12*j,Color(TodayR[0][j]),10); else ObjectDelete("YesterdayRebN "+j);
         if (TodayR[0][j]!=0) Text("YesterdayReb "+j,DoubleToStr(TodayR[0][j],2),            StartShift+Shift*i+280, 35+12*j,Color(TodayR[0][j]),10); else ObjectDelete("YesterdayReb "+j);
         if (TodayM[0][j]!=0) Text("YesterdayManN "+j,DoubleToStr(TodayM[1][j],0),           StartShift+Shift*i+370, 35+12*j,Color(TodayM[0][j]),10); else ObjectDelete("YesterdayManN "+j);
         if (TodayM[0][j]!=0) Text("YesterdayMan "+j,DoubleToStr(TodayM[0][j],2),            StartShift+Shift*i+400, 35+12*j,Color(TodayM[0][j]),10); else ObjectDelete("YesterdayMan "+j);
      }
   }
   //==================
   //--- текущие ордера
   //==================
   if (tn>50000) {Alert("Переполнение буфера",OrdersTotal());return(0);}
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
            if (Orders[1][j]==OP_BUY) {TekType[0][i]++;TekLot[0][i]+=Orders[3][j];}
            if (Orders[1][j]==OP_SELL) {TekType[1][i]++;TekLot[1][i]+=Orders[3][j];}
         }
      }
   }
   ProfitAll=0;
   if (txtInfo!="" && SendMailInfo) txtInfo=StringConcatenate(txtInfo,"\nFloating\n====================\n");
   for (i=0; i<=Nsymb; i++)
   {  
      if (StringLen(Symbl[i])<2) continue;
      Text(StringConcatenate(Symbl[i],"T"),Symbl[i],                                                                      StartShift+Shift*i,93,SteelBlue,10);//символ
      Text(StringConcatenate(Symbl[i],"profitT"),DoubleToStr(SymbolProfit[i],2),                                          StartShift+Shift*i,105,Color(SymbolProfit[i]),10);//профит
      Text(StringConcatenate(Symbl[i],"bT"),     StringConcatenate("B ",TekType[0][i],"    ",DoubleToStr(TekLot[0][i],2)),StartShift+Shift*i,120,Color(SymbolHistoryProfit[i]),8);//всего Buy
      Text(StringConcatenate(Symbl[i],"sT"),     StringConcatenate("S ",TekType[1][i],"    ",DoubleToStr(TekLot[1][i],2)),StartShift+Shift*i,130,Color(SymbolHistoryProfit[i]),8);//всего Sell
      ProfitAll+=SymbolProfit[i];
      if (txtInfo!="" && SendMailInfo && (TekType[0][i]!=0 || TekType[1][i]!=0)) 
         txtInfo=StringConcatenate(txtInfo,Symbl[i],"   Buy ",Ch32(TekType[0][i],0),"   lot ",Ch32(TekLot[0][i],2),"   Sell ",Ch32(TekType[1][i],0),"   lot ",Ch32(TekLot[1][i],2),"   ",DoubleToStr(SymbolProfit[i],2),"\n");
   }
   if (txtInfo!="") txtInfo=StringConcatenate(txtInfo,"====================\nTOTAL ",DoubleToStr(ProfitAll,2),"\n\n");
   Text("profitAllT",DoubleToStr(ProfitAll,2),StartShift+Shift*i,105,Color(ProfitAll),10);//общий профит
   //---
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
   if (ShowMagik)
   {
      ProfitAll=0;
      for (i=0; i<=Nmag; i++)
      {  
         if (Magik[i]==0) continue;
         Text(StringConcatenate(Magik[i],"M"),DoubleToStr(Magik[i],0),                    StartShift+Shift*i,165,SteelBlue,10);//символ
         Text(StringConcatenate(Magik[i],"profitM"),DoubleToStr(MagikProfit[i],2),StartShift+Shift*i,180,Color(MagikProfit[i]),10);//профит
         ProfitAll+=MagikProfit[i];
      }
      Text("magAll","ИТОГО",                     StartShift+Shift*i,165,SteelBlue,10);//шапка
      Text("profitAllM",DoubleToStr(ProfitAll,2),StartShift+Shift*i,180,Color(ProfitAll),10);//общий профит
   }
   //---
   ObjectSetText("Orders h",StringConcatenate("Orders ",hn), 8, "Tahoma", WhiteColor);
   ObjectSetText("Orders f",StringConcatenate("Orders ",tn,"+",OrdersTotal()-tn), 8, "Tahoma", WhiteColor);
   ObjectSetText("2",StringConcatenate("Symbols  ",Nsymb+1), 8, "Tahoma", WhiteColor);
   ObjectSetText("3",StringConcatenate("Equity     ",DoubleToStr(AccountEquity(),2)), 8, "Tahoma", WhiteColor);
   ObjectSetText("4",StringConcatenate("Balance   ",DoubleToStr(AB,2)), 8, "Tahoma", WhiteColor);
   ObjectSetText("5",StringConcatenate("FreeMar. ",DoubleToStr(AFM,2)), 8, "Tahoma", WhiteColor);
   if (SendMailInfo && Ords>tn && iTime(NULL,TF_SendMail,0)!=TimeSendMail) 
   {
      SendMail(StringConcatenate(NameInd," ",AccountCompany()," ",AN),
               StringConcatenate(txtInfo,"\nProfit ",TimeToStr(iTime(NULL,1440,0),TIME_DATE)," = ",DoubleToStr(Today[0][0],2),
                                 "\nRebait ",TimeToStr(iTime(NULL,1440,0),TIME_DATE)," = ",DoubleToStr(TodayR[0][0],2),
                                 "\n\nAll orders ",OrdersTotal()," market ",tn,
                                 "\nEquity     ",DoubleToStr(AccountEquity(),2),
                                 "\nFreeMargin ",DoubleToStr(AFM,2),
                                 "\nBalance    ",DoubleToStr(AB,2)));
      TimeSendMail = iTime(NULL,TF_SendMail,0);
   }
   Ords=tn;
   return(0);
}
//--------------------------------------------------------------------
int SymbolNum(string Symb)
{
   for (int i=0; i<100; i++)
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
   for (int i=0; i<100; i++)
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
   int n,OMN,tipOrders,j;
   string Symb;
   datetime OCT,StartInfo=Time[0],EndInfo=0;
   double Profit;
   ArrayInitialize(Today,0);
   ArrayInitialize(TodayR,0);
   ArrayInitialize(TodayM,0);
   ArrayInitialize(HistoryOrders,0);
   for (int i=OrdersHistoryTotal()-1; i>=0; i--)
   {                                               
      if (OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
      {
         Symb = OrderSymbol();
         if (OrderSymbol()!=SybmolInfo && SybmolInfo!="") continue;
         OMN = OrderMagicNumber();
         if (MagikInfo!=OrderMagicNumber() && MagikInfo!=0) continue;
         Profit = OrderProfit()+OrderSwap()+OrderCommission();
         OCT = OrderCloseTime();
         tipOrders=TipOrders(OrderComment());
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
   int n,OMN;
   string Symb;
   datetime OOT;
   ArrayInitialize(Orders,0);
   for (int i=OrdersHistoryTotal()-1; i>=0; i--)
   {                                               
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
         Symb = OrderSymbol();
         if (OrderSymbol()!=SybmolInfo && SybmolInfo!="") continue;
         OMN = OrderMagicNumber();
         if (MagikInfo!=OMN && MagikInfo!=0) continue;
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
void Text(string name, string txt, int x, int y,color C, int w)
{  
   ObjectCreate(name, OBJ_LABEL, Win, 0, 0);
   ObjectSet(name, OBJPROP_CORNER, 0);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSetText(name,txt,w,"Tahoma", C);
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


