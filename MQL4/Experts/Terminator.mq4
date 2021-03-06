//+------------------------------------------------------------------+
//|                                                 TradeChannel.mq5 |
//|                                          Copyright 2012, Integer |
//|                          https://login.mql5.com/ru/users/Integer |
//+------------------------------------------------------------------+

#property copyright "Integer"
#property link "https://login.mql5.com/ru/users/Integer"
#property description ""
#property version   "1.00"

#property description "Эксперт переписан с MQL4, автор: Alejandro Galindo and Tom Maneval, на mql4.com опубликовал Scriptor (http://www.mql4.com/ru/users/Scriptor), ссылка - http://codebase.mql4.com/ru/1711"

#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
//#include <Trade/DealInfo.mqh>
#include <Trade/PositionInfo.mqh>

CTrade Trade;
//CDealInfo Deal;
CSymbolInfo Sym;
CPositionInfo Pos;

#define BASE_LINE  0
#define UPPER_BAND 1
#define LOWER_BAND 2
//+------------------------------------------------------------------+
//| Базовый класс вариантов торговых сигналов                        |
//+------------------------------------------------------------------+
class CTradeSignals{
   protected:
      bool m_buy;
      bool m_sell;
   public:
      virtual bool Init(){
         return(false);    
      }
      virtual bool Refresh(){
         return(false);      
      }
      virtual void DeInit(){}      
      bool SigBuy(){
         return(m_buy);      
      }
      bool SigSell(){
         return(m_sell);
      }
};   

enum ESigType{
   MACD=0,
   Pivot=1,
   SupRes=2,
   i_TrendRSI=3,
   i_TrendRSISto=4,
   i_TrRSIStoMFI=5
};

enum EBBLine{
   Base = BASE_LINE,
   Upper = UPPER_BAND,
   Lower = LOWER_BAND
};




input bool                             Trade_ON                =  true;                   /*Trade_ON*/               // Разрешается открывать позицию   
input double                           Lots                    =  0.1;                    /*Lots*/                   // Лот, при значении 0 действует MaximumRisk.
input double                           MaximumRisk             =  0.05;                   /*MaximumRisk*/            // Риск (действует при Lots=0).
input int                              StopLoss                =  2500;                   /*StopLoss*/               // Стоплосс в пунктах, 0 - без стоплосс.
input int                              TakeProfit              =  500;                    /*TakeProfit*/             // Тейкпрофит начальной позиции в пунктах
input int                              TakeProfit2             =  100;                    /*TakeProfit2*/            // Тейкпрофит при доливках в пунктах
input int                              MaxCount                =  10;                     /*MaxCount*/               // Максимальное колличество открытий в одну сторону, -1 - не ограничено
input int                              DoubleCount             =  5;                      /*DoubleCount*/            // Количество сделок с коэффициентом умножения лота 2, остальные открываются с коэффициентом умножения 1.5
input int                              Pips                    =  500;                    /*Pips*/                   // Уровень доливки в пунктах
input int                              Trailing                =  0;                      /*Trailing*/               // Уровень трейлинга, при значении 0 трейлинг выключен.
input int                              Shift                   =  1;                      /*Shift*/                  // Бар на котором проверяются индикаторы: 0 - формирующийся бар, 1 - первый сформированный бар
input bool                             ReverseCondition        =  false;                  /*ReverseCondition*/       // Поменять сигналы buy и sell
input ESigType                         OPEN_POS_BASED_ON       =  MACD;                   /*OPEN_POS_BASED_ON*/      // Тип торговых сигналов
input int                              MACD_FastPeriod         =  14;	                  /*MACD_FastPeriod*/        // Период быстрой МА MACD
input int                              MACD_SlowPeriod         =  26;	                  /*MACD_SlowPeriod*/        // Период медленной МА MACD
input ENUM_APPLIED_PRICE               MACD_Price              =  PRICE_CLOSE;	         /*MACD_Price*/             // Цена MACD
input int                              Pivot_DayStartHour      =  0;                      /*Pivot_DayStartHour*/     // Час времени начала дня
input int                              Pivot_DayStartMinute    =  0;                      /*Pivot_DayStartMinute*/   // Минуты времени начала дня
input bool                             Pivot_AttachSundToMond  =  true;                   /*Pivot_AttachSundToMond*/ // Присоединять воскресные бары с понедельнику
input int                              SupRes_iPeriod          =  70;                     /*SupRes_iPeriod*/         // Период индикатора Support_and_Resistance
input ENUM_APPLIED_PRICE               iT_Price                =  PRICE_CLOSE;	         /*iT_Price*/               // Тип цена с которой вычисляется разница цены и полос Боллинджера
input int                              iT_BBPeriod             =  10;	                  /*iT_BBPeriod*/            // Период BB
input int                              iT_BBShift              =  0;	                     /*iT_BBShift*/             // Смещение BB
input double                           iT_BBDeviation          =  2;	                     /*iT_BBDeviation*/         // Ширина BB
input ENUM_APPLIED_PRICE               iT_BBPrice              =  PRICE_CLOSE;	         /*iT_BBPrice*/             // Цена BB
input EBBLine                          iT_BBLine               =  BASE_LINE;              /*iT_BBLine*/              // Используемая линия полос Боллинджера
input int                              iT_BullsBearsPeriod     =  6;	                     /*iT_BullsBearsPeriod*/    // Период Bulls Bears Power
input int                              RSI_Period              =  14;	                  /*RSI_Period*/             // Период RSI
input ENUM_APPLIED_PRICE               RSI_Price               =  PRICE_CLOSE;	         /*RSI_Price*/              // Цена RSI
input int                              St_KPeriod              =  8;	                     /*St_KPeriod*/             // Период К стохастика
input int                              St_DPeriod              =  3; 	                  /*St_DPeriod*/             // Период D стохастика
input int                              St_SPeriod              =  4;	                     /*St_SPeriod*/             // Период S стохастика
input ENUM_MA_METHOD                   St_Method               =  MODE_SMA;	            /*St_Method*/              // Метод стохастика
input ENUM_STO_PRICE                   St_Price                =  STO_LOWHIGH;	         /*St_Price*/               // Цена стохастика
input int                              St_UpperLevel           =  80; 	                  /*St_UpperLevel*/          // Верхний уровень стохастика
input int                              St_LowerLevel           =  20;	                  /*St_LowerLevel*/          // Нижний уровень стохастика
input int                              MFI_Period              =  5; 	                  /*MFI_Period*/             // Период MFI
//input ENUM_APPLIED_VOLUME              MFI_Volume              =  VOLUME_TICK;	         /*MFI_Volume*/             // Объем MFI


int Handle=INVALID_HANDLE;
datetime ctm[1];
datetime LastTime;
double lot,slv,msl,tpv,mtp;

int   MACD_SignalPeriod       =  1;	   
bool  Pivot_PivotsBufers      =  true; 
bool  Pivot_MidpivotsBuffers  =  false;
bool  Pivot_CamarillaBuffers  =  false;
bool  Pivot_PivotsLines       =  false;
bool  Pivot_MidpivotsLines    =  false;
bool  Pivot_CamarillaLines    =  false;
color Pivot_ClrPivot          =  clrOrange;
color Pivot_ClrS              =  clrRed;
color Pivot_ClrR              =  clrDeepSkyBlue;
color Pivot_ClrM              =  clrBlue;
color Pivot_ClrCamarilla      =  clrYellow;
color Pivot_ClrTxt            =  clrWhite;

CTradeSignals * TradeSignals;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){

   switch(OPEN_POS_BASED_ON){
      case MACD:
         TradeSignals=new CSigMACD();
      break;
      case Pivot:
         TradeSignals=new CSigPivot();
      break;
      case SupRes:
         TradeSignals=new CSigSupRes();
      break;
      case i_TrendRSI:
         TradeSignals=new CSigi_TrendRSI();     
      break;
      case i_TrendRSISto:
         TradeSignals=new CSigi_TrendRSISto();
      break;
      case i_TrRSIStoMFI:
         TradeSignals=new CSigi_TrRSIStoMFI();     
      break;
   }
   /*
   if(!TradeSignals.Init()){
      Alert("Ошибка загрузки индикатора, поворите попытку");
      return(-1);
   }   
   
   if(!Sym.Name(Symbol())){
      Alert("Ошибка инициализации CSymbolInfo, поворите попытку");    
      return(-1);
   }
   */
   Print("Инициализация эксперта выполнена");
   
   return(0);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
   TradeSignals.DeInit();
   delete(TradeSignals);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){

      if(CopyTime(_Symbol,PERIOD_CURRENT,0,1,ctm)==-1){
         return;
      }
      
      if(Shift==0 || ctm[0]!=LastTime){
         // Индикаторы
            if(!TradeSignals.Refresh()){
               return;
            }   
   
         bool BuySig;
         bool SellSig;
    
            if(ReverseCondition){
               BuySig=TradeSignals.SigSell();
               SellSig=TradeSignals.SigBuy();      
            }
            else{
               BuySig=TradeSignals.SigBuy();
               SellSig=TradeSignals.SigSell();      
            }
   
         // Открытие
            if(!Pos.Select(_Symbol)){
               if(BuySig && !SellSig && Trade_ON){ 
                  RefreshRates();       
                  if(!SolveLots(lot))return;
                  slv=0;
                     if(MaxCount==1){
                        slv=SolveBuySL(StopLoss);
                     }
                  tpv=SolveBuyTP(TakeProfit);
                     //Print(CheckBuySL(slv)+" "+CheckBuyTP(tpv));
                     if(CheckBuySL(slv) && CheckBuyTP(tpv)){
                        //Print("TRUE");
                        Trade.SetDeviationInPoints(Sym.Spread()*3);
                        //Print("1: "+DoubleToString(slv, Digits())+"  "+DoubleToString(tpv, Digits()));
                        if(!Trade.Buy(lot,_Symbol,0,slv,tpv,"-")){
                           return;
                        }
                     }
                     else{
                        Print("Позиция Buy не открывается, близкий стоплосс или тейкпрофит ");
                     }         
               }
               // Продажа
               if(SellSig && !BuySig && Trade_ON){
                  RefreshRates();         
                  if(!SolveLots(lot))return;
                  slv=0;
                     if(MaxCount==1){               
                        slv=SolveSellSL(StopLoss);
                     }
                  tpv=SolveSellTP(TakeProfit);
                     //Print(CheckSellSL(slv)+" "+CheckSellTP(tpv));
                     if(CheckSellSL(slv) && CheckSellTP(tpv)){
                        //Print("TRUE");
                        Trade.SetDeviationInPoints(Sym.Spread()*3);
                        if(!Trade.Sell(lot,_Symbol,0,slv,tpv,"-")){
                           return;
                        }
                     }
                     else{
                        //Print("Позиция Sell не открывается, близкий стоплосс или тейкпрофит ");
                     }          
               }
            }    
            else{
               RefreshRates();
               double Price,StartLots;
               int Index;
               int k=DoubleCount;
               int t = OrderType();
                  switch(t){
                     case OP_BUY:
                        if(BuySig){
                           if(!FindLastInPrice(DEAL_TYPE_BUY,Price,Index)){
                              return;
                           }
                           if((Index<MaxCount || MaxCount==-1) && Price-Ask>=Point()*Pips){
                              if(!FindStartLots(DEAL_TYPE_BUY,StartLots))return;
                              lot=StartLots*MathPow(2,MathMin(Index,k-1));
                              if(Index>k-1)lot=lot*MathPow(1.5,Index-k+1);
                              lot=fLotsNormalize(lot);
                              
                              slv=0;
                                 if(StopLoss!=0){
                                    if(Index+1==MaxCount){
                                       slv=SolveBuySL(StopLoss);
                                       slv=MathMin(slv,NormalizeDouble(BuyMSL()-Point(), Digits()));     
                                    }
                                 }   
                              tpv=0;
                                 if(TakeProfit2!=0){
                                    tpv=(Pos.PriceOpen()*Pos.Volume()+Ask*lot)/(Pos.Volume()+lot)+Point()*TakeProfit2;
                                    tpv=NormalizeDouble(tpv, Digits());
                                    tpv=MathMax(tpv,NormalizeDouble(BuyMTP()+Point(), Digits()));
                                 }
                              Trade.SetDeviationInPoints(Sym.Spread()*3);                     
                              Trade.Buy(lot,_Symbol,0,slv,tpv,IntegerToString(Index+1)+"=");
                           }
                        }
                     break;
                     case OP_SELL:
                        if(SellSig){                  
                           if(!FindLastInPrice(DEAL_TYPE_SELL,Price,Index)){
                              return;
                           }
                           if((Index<MaxCount || MaxCount==-1) && Bid-Price>=Point()*Pips){
                              if(!FindStartLots(DEAL_TYPE_SELL,StartLots))return;
                              lot=StartLots*MathPow(2,MathMin(Index,k-1));
                              if(Index>k-1)lot=lot*MathPow(1.5,Index-k+1);
                              lot=fLotsNormalize(lot);
                              slv=0;
                                 if(StopLoss!=0){
                                       if(Index+1==MaxCount){
                                          slv=SolveSellSL(StopLoss);
                                          slv=MathMax(slv,NormalizeDouble(SellMSL()+Point(), Digits())); 
                                       }
                                 }
                              tpv=0;
                                 if(TakeProfit2!=0){
                                    tpv=(Pos.PriceOpen()*Pos.Volume()+Ask*lot)/(Pos.Volume()+lot)-Point()*TakeProfit2;
                                    tpv=NormalizeDouble(tpv, Digits()); 
                                    tpv=MathMin(tpv,NormalizeDouble(SellMTP()-Point(), Digits()));
                                 }
                              Trade.SetDeviationInPoints(Sym.Spread()*3);   
                              Trade.Sell(lot,_Symbol,0,slv,tpv,IntegerToString(Index+1)+"=");
                           }
                        }
                     break;
                  }
            }        
         LastTime=ctm[0];
      }
   
   fSimpleTrailing();

}

bool FindStartLots(long aType,double & aLots){
      if(!SolveLots(aLots)){
         return(false);
      }
      if(OrdersHistoryTotal()>0){
         for(int i=OrdersHistoryTotal()-1;i>=0;i--){
            bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
               if(OrderSymbol()==_Symbol){
                  if(OrderType()==aType){
                        int p=StringFind(OrderComment(),"=",0);
                           if(p==-1){
                              aLots=OrderLots();
                              return(true);
                           }
                  }
               }
            }
         }
   return(true); 
}

bool FindLastInPrice(long aType,double & aPrice,int & aIndex){
   aPrice=0;
   aIndex=1;
   
   if(OrdersHistoryTotal()>0){
      for(int i=OrdersHistoryTotal()-1;i>=0;i--){
         bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
            if(OrderSymbol()==_Symbol){
               if(OrderType()==aType){
                     int p=StringFind(OrderComment(),"=",0);
                        if(p==-1){
                           aIndex=1;
                        }
                        else{
                           aIndex=(int)StringToInteger(StringSubstr(OrderComment(),0,p));
                        }
                     aPrice=OrderOpenPrice();
                     return(true);
                  }
            }         
      }
   }
   return(true);   
}


//+------------------------------------------------------------------+
//|   Функция копирования данных индикаторов, цены                   |
//+------------------------------------------------------------------+
bool Indicators(){

   return(true);
}

//+------------------------------------------------------------------+
//|   Функция определения сигналов покупки                           |
//+------------------------------------------------------------------+
bool SignalOpenBuy(){

   return(false);
}

//+------------------------------------------------------------------+
//|   Функция определения сигналов продажи                           |
//+------------------------------------------------------------------+
bool SignalOpenSell(){

   return(false);
}

//+------------------------------------------------------------------+
//|   Функция определения сигналов закрытия покупки                  |
//+------------------------------------------------------------------+
bool SignalCloseBuy(){

   return (false);
}

//+------------------------------------------------------------------+
//|   Функция определения сигналов закрытия продажи                  |
//+------------------------------------------------------------------+
bool SignalCloseSell(){

   return (false);
}

//+------------------------------------------------------------------+
//|   Функция вычисления стоплосса buy                               |
//+------------------------------------------------------------------+
double SolveBuySL(int StopLossPoints){
   if(StopLossPoints==0)return(0);
   return(NormalizeDouble(Ask-Point()*StopLossPoints, Digits()));
}

//+------------------------------------------------------------------+
//|   Функция вычисления тейкпрофита buy                             |
//+------------------------------------------------------------------+
double SolveBuyTP(int TakeProfitPoints){
   if(TakeProfitPoints==0)return(0);
   return(NormalizeDouble(Ask+Point()*TakeProfitPoints, Digits()));   
}

//+------------------------------------------------------------------+
//|   Функция вычисления стоплосса sell                               |
//+------------------------------------------------------------------+
double SolveSellSL(int StopLossPoints){
   if(StopLossPoints==0)return(0);
   return(NormalizeDouble(Bid+Point()*StopLossPoints, Digits()));
}

//+------------------------------------------------------------------+
//|   Функция вычисления тейкпрофита sell                             |
//+------------------------------------------------------------------+
double SolveSellTP(int TakeProfitPoints){
   if(TakeProfitPoints==0)return(0);
   return(NormalizeDouble(Bid-Point()*TakeProfitPoints, Digits()));   
}

//+------------------------------------------------------------------+
//|   Функция вычисления минимального стоплосса buy                  |
//+------------------------------------------------------------------+
double BuyMSL(){
   return(NormalizeDouble(Bid-Point()*Sym.StopsLevel(), Digits()));
}

//+------------------------------------------------------------------+
//|   Функция вычисления минимального тейкпрофита buy                |
//+------------------------------------------------------------------+
double BuyMTP(){
   return(NormalizeDouble(Ask+Point()*Sym.StopsLevel(), Digits()));
}

//+------------------------------------------------------------------+
//|   Функция вычисления минимального стоплосса sell                 |
//+------------------------------------------------------------------+
double SellMSL(){
   return(NormalizeDouble(Ask+Point()*Sym.StopsLevel(), Digits()));
}

//+------------------------------------------------------------------+
//|   Функция вычисления минимального тейкпрофита sell               |
//+------------------------------------------------------------------+
double SellMTP(){
   return(NormalizeDouble(Bid-Point()*Sym.StopsLevel(), Digits()));
}

//+------------------------------------------------------------------+
//|   Функция проверки стоплосса buy                                 |
//+------------------------------------------------------------------+
bool CheckBuySL(double StopLossPrice){
   if(StopLossPrice==0)return(true);
   return(StopLossPrice<BuyMSL());
}

//+------------------------------------------------------------------+
//|   Функция проверки тейкпрофита buy                               |
//+------------------------------------------------------------------+
bool CheckBuyTP(double TakeProfitPrice){
   //Print(__FUNCTION__+"  "+TakeProfitPrice+"  "+BuyMTP());
   if(TakeProfitPrice==0)return(true);
   return(TakeProfitPrice>BuyMTP());
}

//+------------------------------------------------------------------+
//|   Функция проверки стоплосса sell                                 |
//+------------------------------------------------------------------+
bool CheckSellSL(double StopLossPrice){
   if(StopLossPrice==0)return(true);
   return(StopLossPrice>SellMSL());
}

//+------------------------------------------------------------------+
//|   Функция проверки тейкпрофита sell                              |
//+------------------------------------------------------------------+
bool CheckSellTP(double TakeProfitPrice){
   if(TakeProfitPrice==0)return(true);
   return(TakeProfitPrice<SellMTP());
}


//+------------------------------------------------------------------+
//|   Функция определения лота по результатам торговли               |
//+------------------------------------------------------------------+
bool SolveLots(double & aLots){
      if(Lots==0){
         aLots=fLotsNormalize(AccountInfoDouble(ACCOUNT_FREEMARGIN)*MaximumRisk/1000.0);        
      }
      else{
         aLots=Lots;         
      }
   return(true);
}

//+------------------------------------------------------------------+
//|   Функция нормализации лота                                      |
//+------------------------------------------------------------------+
double fLotsNormalize(double aLots){
   aLots-=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   aLots/=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   aLots=MathRound(aLots);
   aLots*=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   aLots+=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   aLots=NormalizeDouble(aLots,2);
   aLots=MathMin(aLots,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX));
   aLots=MathMax(aLots,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));   
   return(aLots);
}

//+------------------------------------------------------------------+
//| Функция простого трейлинга                                       |
//+------------------------------------------------------------------+
void fSimpleTrailing(){
   if(Trailing<=0){
      return;
   }         
   if(!Pos.Select(_Symbol)){
      return;
   }         
   RefreshRates(); 
   Print(Pos.PositionType());
   double nsl,tmsl,psl;  
   switch(Pos.PositionType()){
      case POSITION_TYPE_BUY:
         nsl=NormalizeDouble(Bid-Point()*Trailing, Digits());
            if(nsl>=NormalizeDouble(Pos.PriceOpen(), Digits())){
               if(nsl>NormalizeDouble(Pos.StopLoss(), Digits())){
                  tmsl=NormalizeDouble(Bid-Point()*Sym.StopsLevel(), Digits());
                     if(nsl<tmsl){
                        Trade.PositionModify(_Symbol,nsl,Pos.TakeProfit());
                     }
               }
            }
      break;
      case POSITION_TYPE_SELL:
         nsl=NormalizeDouble(Ask+Point()*Trailing, Digits());
            if(nsl<=NormalizeDouble(Pos.PriceOpen(), Digits())){
               psl=NormalizeDouble(Pos.StopLoss(), Digits());
                  if(nsl<psl || psl==0){
                     tmsl=NormalizeDouble(Ask+ Point()*Sym.StopsLevel(), Digits());
                        if(nsl>tmsl){
                           Trade.PositionModify(_Symbol,nsl,Pos.TakeProfit());
                        }
                  }
            }      
      break;
   }
}

class CSigMACD:public CTradeSignals{
   protected:
      //int m_Handle;
      double m_val[1];
      double m_val1[1];      
   public:
      bool Init(){
         //m_Handle=iMACD(NULL,PERIOD_CURRENT,MACD_FastPeriod,MACD_SlowPeriod,MACD_SignalPeriod,MACD_Price);
         //iMACD(Symbol(), PERIOD_CURRENT, MACD_FastPeriod, MACD_SlowPeriod, MACD_SignalPeriod, MACD_Price, Shift);
         return true;//(m_Handle!=INVALID_HANDLE);
      }
      bool Refresh(){
         /*if(
            CopyBuffer(m_Handle,0,Shift,1,m_val)==-1 ||
            CopyBuffer(m_Handle,0,Shift+1,1,m_val1)==-1         
         )return(false);
         */
         m_val[0]  = iMACD(Symbol(), PERIOD_CURRENT, MACD_FastPeriod, MACD_SlowPeriod, MACD_SignalPeriod, MACD_Price, MODE_SIGNAL, Shift);
         m_val1[0] = iMACD(Symbol(), PERIOD_CURRENT, MACD_FastPeriod, MACD_SlowPeriod, MACD_SignalPeriod, MACD_Price, MODE_SIGNAL, Shift+1);
         m_buy=(m_val[0]>m_val1[0]);
         // MACD растет.
         m_sell=(m_val[0]<m_val1[0]);
         // MACD падает.
         return(true);
      }
      void DeInit(){
         //if(m_Handle!=INVALID_HANDLE)IndicatorRelease(m_Handle);
      }         
};

class CSigPivot:public CTradeSignals{
   protected:
      //int m_Handle;
      double m_val[1];
      double m_cl[1];
   public:
      bool Init(){
         //m_Handle=iCustom(_Symbol,PERIOD_CURRENT,"Pivot Lines TimeZone",Pivot_DayStartHour,Pivot_DayStartMinute,Pivot_PivotsBufers,Pivot_MidpivotsBuffers,Pivot_CamarillaBuffers,Pivot_PivotsLines,Pivot_MidpivotsLines,Pivot_CamarillaLines,Pivot_ClrPivot,Pivot_ClrS,Pivot_ClrR,Pivot_ClrM,Pivot_ClrCamarilla,Pivot_ClrTxt,Pivot_AttachSundToMond);
         return true;//(m_Handle!=INVALID_HANDLE); 
      }
      bool Refresh(){
         /*if(   CopyBuffer(m_Handle,0,Shift,1,m_val)==-1 ||
               CopyClose(_Symbol,PERIOD_CURRENT,Shift,1,m_cl)==-1
         )return(false); */
         m_val[0] = iCustom(Symbol(), PERIOD_CURRENT, "Pivot Lines TimeZone", Pivot_DayStartHour, Pivot_DayStartMinute, Pivot_PivotsBufers,Pivot_MidpivotsBuffers,Pivot_CamarillaBuffers,Pivot_PivotsLines,Pivot_MidpivotsLines,Pivot_CamarillaLines,Pivot_ClrPivot,Pivot_ClrS,Pivot_ClrR,Pivot_ClrM,Pivot_ClrCamarilla,Pivot_ClrTxt,Pivot_AttachSundToMond, Shift);  
         m_cl[0]  = iClose(Symbol(), PERIOD_CURRENT, Shift);
         m_buy=(m_cl[0]>m_val[0]);
         // Цена закрытия бара больше Pivot.
         m_sell=(m_cl[0]<m_val[0]);         
         // Цена закрытия бара меньше Pivot.
         return(true);      
      }
      void DeInit(){
         //if(m_Handle!=INVALID_HANDLE)IndicatorRelease(m_Handle);
      }         
};

class CSigSupRes:public CTradeSignals{
   protected:
      //int m_Handle;
      double m_valS[1];
      double m_valR[1];
      double m_cl[1];
      double m_valS1[1];
      double m_valR1[1];
      double m_cl1[1];      
   public:
      bool Init(){
         //m_Handle=iCustom(_Symbol,PERIOD_CURRENT,"Support_and_Resistance",SupRes_iPeriod);
         return true;//(m_Handle!=INVALID_HANDLE);   
      }
      bool Refresh(){
         if(Shift==0){
            /*if(   CopyBuffer(m_Handle,0,Shift,1,m_valS)==-1 ||
                  CopyBuffer(m_Handle,1,Shift,1,m_valR)==-1 ||
                  CopyClose(_Symbol,PERIOD_CURRENT,Shift,1,m_cl)==-1
            )return(false); */
            m_valS[0] = iCustom(_Symbol,PERIOD_CURRENT,"Support_and_Resistance",SupRes_iPeriod, 0, Shift);
            m_valR[0] = iCustom(_Symbol,PERIOD_CURRENT,"Support_and_Resistance",SupRes_iPeriod, 1, Shift);
            m_cl[0]   = iClose(Symbol(), PERIOD_CURRENT, Shift);
            
            m_buy=(m_cl[0]==m_valR[0]);
            // Цена закрытия бара равна сопротивлению.
            m_sell=(m_cl[0]==m_valS[0]);
            // Цена закрытия бара равна поддержке.
         }
         else{
            m_valS[0] = iCustom(_Symbol,PERIOD_CURRENT,"Support_and_Resistance",SupRes_iPeriod, 0, Shift);
            m_valR[0] = iCustom(_Symbol,PERIOD_CURRENT,"Support_and_Resistance",SupRes_iPeriod, 1, Shift);
            m_cl[0]   = iClose(Symbol(), PERIOD_CURRENT, Shift);
            
            m_valS1[0] = iCustom(_Symbol,PERIOD_CURRENT,"Support_and_Resistance",SupRes_iPeriod, 0, Shift+1);
            m_valR1[0] = iCustom(_Symbol,PERIOD_CURRENT,"Support_and_Resistance",SupRes_iPeriod, 1, Shift+1);
            m_cl1[0]   = iClose(Symbol(), PERIOD_CURRENT, Shift+1);
            /*if(   
                  CopyBuffer(m_Handle,0,Shift,1,m_valS)==-1 ||
                  CopyBuffer(m_Handle,1,Shift,1,m_valR)==-1 ||
                  CopyClose(_Symbol,PERIOD_CURRENT,Shift,1,m_cl)==-1 || 
                  
                  CopyBuffer(m_Handle,0,Shift+1,1,m_valS1)==-1 ||
                  CopyBuffer(m_Handle,1,Shift+1,1,m_valR1)==-1 ||
                  CopyClose(_Symbol,PERIOD_CURRENT,Shift+1,1,m_cl1)==-1
            )return(false); */
            m_buy=(m_cl[0]>m_valR[0] && m_cl1[0]<=m_valR1[0]);
            // Пересечение линии сопротивления вверх.
            m_sell=(m_cl[0]<m_valS[0] && m_cl1[0]>=m_valS1[0]);
            // Пересечение линии поддержуи вниз.
         }
         return(true);      
      }
      void DeInit(){
         //if(m_Handle!=INVALID_HANDLE)IndicatorRelease(m_Handle);
      }        
};

class CSigi_TrendRSI:public CTradeSignals{
   protected:
      //int m_iTrendHandle;
      //int m_RSIHand;      
      double m_it00[1];
      double m_it10[1];
      double m_it01[1];
      double m_rsi_0[1];
      double m_rsi_1[1];
   public:
      bool Init(){
         //m_iTrendHandle=iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod);
         //m_RSIHand=iRSI(_Symbol,PERIOD_CURRENT,RSI_Period,RSI_Price);
         return true;//(m_iTrendHandle!=INVALID_HANDLE && m_RSIHand!=INVALID_HANDLE);    
      }
      bool Refresh(){
         /*if(
            CopyBuffer(m_iTrendHandle,0,Shift,1,m_it00)==-1 || 
            CopyBuffer(m_iTrendHandle,0,Shift+1,1,m_it01)==-1 ||   
            CopyBuffer(m_iTrendHandle,1,Shift,1,m_it10)==-1 ||   
            CopyBuffer(m_RSIHand,0,Shift,1,m_rsi_0)==-1 || 
            CopyBuffer(m_RSIHand,0,Shift+1,1,m_rsi_1)==-1
         )return(false);*/
         m_it00[0] = iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 0, Shift);
         m_it10[0] = iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 0, Shift+1);
         m_it01[0] = iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 1, Shift);
         m_rsi_0[0] = iRSI(_Symbol,PERIOD_CURRENT,RSI_Period,RSI_Price, Shift);
         m_rsi_1[0] = iRSI(_Symbol,PERIOD_CURRENT,RSI_Period,RSI_Price, Shift+1);
         m_buy=   (m_it00[0]>m_it10[0]    && m_it00[0]>m_it01[0] && m_rsi_0[0]>m_rsi_1[0]);
         // Зеленая линия болше красной и растет, RSI растет.
         m_sell=  (m_it00[0]<m_it10[0]    && m_it00[0]<m_it01[0] && m_rsi_0[0]<m_rsi_1[0]);
         // Зеленая линия меньше красной и падает, RSI падает.
         return(true);      
      }
      void DeInit(){
         /*if(m_iTrendHandle!=INVALID_HANDLE)IndicatorRelease(m_iTrendHandle);
         if(m_RSIHand!=INVALID_HANDLE)IndicatorRelease(m_RSIHand);*/
      }         
};

class CSigi_TrendRSISto:public CTradeSignals{
   protected:
      //int m_iTrendHandle;
      //int m_RSIHand;       
      //int m_StHand;
      double m_it00[1];
      double m_it01[1];
      double m_it10[1];
      double m_st00[1];
      double m_st01[1];
      double m_st10[1];   
      double m_rsi0[1];
      double m_rsi1[1];
   public:
      bool Init(){
         //m_iTrendHandle=iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod);
         //m_RSIHand=iRSI(_Symbol,PERIOD_CURRENT,RSI_Period,RSI_Price);      
         //m_StHand=iStochastic(_Symbol,PERIOD_CURRENT,St_KPeriod,St_DPeriod,St_SPeriod,St_Method,St_Price);
         return true;//(m_iTrendHandle!=INVALID_HANDLE && m_RSIHand!=INVALID_HANDLE && m_StHand!=INVALID_HANDLE);
      }
      bool Refresh(){
         /*if(
            CopyBuffer(m_iTrendHandle,0,Shift,1,m_it00)==-1 || 
            CopyBuffer(m_iTrendHandle,0,Shift+1,1,m_it01)==-1 ||   
            CopyBuffer(m_iTrendHandle,1,Shift,1,m_it10)==-1 ||        
            CopyBuffer(m_StHand,0,Shift,1,m_st00)==-1 ||
            CopyBuffer(m_StHand,0,Shift+1,1,m_st01)==-1 ||
            CopyBuffer(m_StHand,1,Shift,1,m_st10)==-1 ||
            CopyBuffer(m_RSIHand,0,Shift,1,m_rsi0)==-1 ||
            CopyBuffer(m_RSIHand,0,Shift+1,1,m_rsi1)==-1
         )return(false);     */       
         m_it00[0] = iCustom(Symbol(),PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 0, Shift);
         m_it01[0] = iCustom(Symbol(),PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 0, Shift+1);
         m_it10[0] = iCustom(Symbol(),PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 1, Shift);
         m_st00[0] = iStochastic(Symbol(),PERIOD_CURRENT,St_KPeriod,St_DPeriod,St_SPeriod,St_Method,St_Price, 0, Shift);
         m_st01[0] = iStochastic(Symbol(),PERIOD_CURRENT,St_KPeriod,St_DPeriod,St_SPeriod,St_Method,St_Price, 0, Shift+1);
         m_st10[0] = iStochastic(Symbol(),PERIOD_CURRENT,St_KPeriod,St_DPeriod,St_SPeriod,St_Method,St_Price, 1, Shift);
         m_rsi0[0] = iRSI(Symbol(),PERIOD_CURRENT,RSI_Period,RSI_Price, Shift);
         m_rsi1[0] = iRSI(Symbol(),PERIOD_CURRENT,RSI_Period,RSI_Price, Shift+1);
         
         double m_Buy5_2 = 80;
         double m_Buy6_2 = 20;
         double m_Sell5_2=80;
         double m_Sell6_2=30;
         m_buy=(m_it00[0]>m_it10[0] && m_it00[0]>m_it01[0] && m_st00[0]>m_st10[0] && m_st00[0]>m_st01[0] && m_st00[0]<St_UpperLevel  && m_st00[0]>St_LowerLevel && m_rsi0[0]>m_rsi1[0]);
         // Зеленая больше красной и растет, главная стохастика выше сигнальной и растет, находится между верхним и нижним уровнями, RSI растет.
         m_buy=(m_it00[0]<m_it10[0] && m_it00[0]<m_it01[0] && m_st00[0]<m_st10[0] && m_st00[0]<m_st01[0] && m_st00[0]<St_UpperLevel  && m_st00[0]>St_LowerLevel && m_rsi0[0]<m_rsi1[0]);
         // Зеленая меньше красной и падает, главная стохастика ниже сигнальной и падает, находится между верхним и нижним уровнями, RSI падает.
         return(true);      
      }
      void DeInit(){
         /*if(m_iTrendHandle!=INVALID_HANDLE)IndicatorRelease(m_iTrendHandle);
         if(m_RSIHand!=INVALID_HANDLE)IndicatorRelease(m_RSIHand);
         if(m_StHand!=INVALID_HANDLE)IndicatorRelease(m_StHand);  */       
      }
};

class CSigi_TrRSIStoMFI:public CTradeSignals{
   protected:
      //int m_iTrendHandle;
      //int m_RSIHand;       
      //int m_StHand;
      //int m_MFIHand;
      double m_it00[1];
      double m_it10[1];
      double m_it01[1];
      double m_st00[1];
      double m_st01[1];
      double m_st10[1];
      double m_rsi0[1];  
      double m_rsi1[1];
      double m_mfi0[1];
      double m_mfi1[1];
   public:
      bool Init(){
         //m_iTrendHandle=iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod);
         //m_RSIHand=iRSI(_Symbol,PERIOD_CURRENT,RSI_Period,RSI_Price);      
         //m_StHand=iStochastic(_Symbol,PERIOD_CURRENT,St_KPeriod,St_DPeriod,St_SPeriod,St_Method,St_Price);
         //m_MFIHand=iMFI(_Symbol,PERIOD_CURRENT,MFI_Period,MFI_Volume);
         return true;//(m_iTrendHandle!=INVALID_HANDLE && m_RSIHand!=INVALID_HANDLE && m_StHand!=INVALID_HANDLE && m_MFIHand!=INVALID_HANDLE);      
      }
      bool Refresh(){
         /*if(
            CopyBuffer(m_iTrendHandle,0,Shift,1,m_it00)==-1 || 
            CopyBuffer(m_iTrendHandle,0,Shift+1,1,m_it01)==-1 ||   
            CopyBuffer(m_iTrendHandle,1,Shift,1,m_it10)==-1 ||        
            CopyBuffer(m_StHand,0,Shift,1,m_st00)==-1 ||
            CopyBuffer(m_StHand,0,Shift+1,1,m_st01)==-1 ||
            CopyBuffer(m_StHand,1,Shift,1,m_st10)==-1 ||
            CopyBuffer(m_RSIHand,0,Shift,1,m_rsi0)==-1 ||
            CopyBuffer(m_RSIHand,0,Shift+1,1,m_rsi1)==-1 ||
            CopyBuffer(m_MFIHand,0,Shift,1,m_mfi0)==-1 || 
            CopyBuffer(m_MFIHand,0,Shift+1,1,m_mfi1)==-1
         )return(false);   */
         m_it00[0] = iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 0, Shift);
         m_it10[0] = iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 0, Shift+1);
         m_it01[0] = iCustom(_Symbol,PERIOD_CURRENT,"i_Trend",iT_Price,iT_BBPeriod,iT_BBShift,iT_BBDeviation,iT_BBPrice,iT_BBLine,iT_BullsBearsPeriod, 1, Shift);
         m_st00[0] = iStochastic(_Symbol,PERIOD_CURRENT,St_KPeriod,St_DPeriod,St_SPeriod,St_Method,St_Price, 0, Shift);
         m_st01[0] = iStochastic(_Symbol,PERIOD_CURRENT,St_KPeriod,St_DPeriod,St_SPeriod,St_Method,St_Price, 0, Shift+1);
         m_st10[0] = iStochastic(_Symbol,PERIOD_CURRENT,St_KPeriod,St_DPeriod,St_SPeriod,St_Method,St_Price, 1, Shift);
         m_rsi0[0] = iRSI(_Symbol,PERIOD_CURRENT,RSI_Period,RSI_Price, Shift);   
         m_rsi1[0] = iRSI(_Symbol,PERIOD_CURRENT,RSI_Period,RSI_Price, Shift+1);   
         m_mfi0[0] = iMFI(_Symbol,PERIOD_CURRENT,MFI_Period, Shift);
         m_mfi1[0] = iMFI(_Symbol,PERIOD_CURRENT,MFI_Period, Shift+1);
         
         m_buy=(m_it00[0]>m_it10[0] && m_it00[0]>m_it01[0] && m_st00[0]>m_st10[0] && m_st00[0]>m_st01[0] && m_st00[0]<St_UpperLevel && m_st00[0]>St_LowerLevel && m_rsi0[0]>m_rsi1[0] && m_mfi0[0]>m_mfi1[0]);
         // Зеленая больше красной и растет, главная стохастика выше сигнальной и растет, находится между верхним и нижним уровнями, RSI растет, MFI растет.
         m_sell=(m_it00[0]<m_it10[0] && m_it00[0]<m_it01[0] && m_st00[0]<m_st10[0] && m_st00[0]<m_st01[0] && m_st00[0]<St_UpperLevel && m_st00[0]>St_LowerLevel && m_rsi0[0]<m_rsi1[0] && m_mfi0[0]<m_mfi1[0]);
         // Зеленая меньше красной и падает, главная стохастика ниже сигнальной и падает, находится между верхним и нижним уровнями, RSI падает, MFI падает.
         
         
         
         return(true);      
      }
      void DeInit(){
         /*if(m_iTrendHandle!=INVALID_HANDLE)IndicatorRelease(m_iTrendHandle);
         if(m_RSIHand!=INVALID_HANDLE)IndicatorRelease(m_RSIHand);
         if(m_StHand!=INVALID_HANDLE)IndicatorRelease(m_StHand);  
         if(m_MFIHand!=INVALID_HANDLE)IndicatorRelease(m_MFIHand); */
      }
};