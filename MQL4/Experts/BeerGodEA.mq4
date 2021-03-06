#property copyright "Scam Laboratory 2012" 
#property link      "http://www.forex4you.org/?affid=bdbda7b"
//=============== Меню ===============================================

extern string Name="BeerGodEA (25.06.12)";
extern double Lot = 1.0;
extern int TimeBarOpen = 1;
extern int Period_MA=20;      // Период МА
extern int Slippage = 1;
extern int mn= 100;
input  int SL = 20;           //Стоплос
input  int TP = 50;           //Тейкпрофит

//============== Переменные ==========================================
string GetNameOP="BeerGodEA"; // комент в открытом ордере
double TimeBar_t; // текущее время свечи
double sv_close; // цена закрытия свечи
double PA; // текущая цена
double MA_1_t; // МА текущая
double MA_1_p; // МА предыдущая
double NewBuy; // сигнал открытия покупки
double NewSell; // сигнал открытия продажи

int mtp = 1;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
   if(Digits() == 5 || Digits() == 3)mtp = 10;
   if (!IsTesting())
   {
      if (IsExpertEnabled())
      {
         Comment("Советник будет запущен следующим тиком");
      }
      else 
      {
         Comment("Отжата кнопка \"Разрешить запуск советников\"");
      }
   }
      
   return (0);
}
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {//0

//======== получение данных с индикаторов и текущей цены ======================
{//1

MA_1_t=iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,0); // МА_1 текущая
MA_1_p=iMA(NULL,0,Period_MA,0,MODE_SMA,PRICE_CLOSE,1); // МА_1 текущая
TimeBar_t = (TimeCurrent()-Time[0])/60; // время в минутах с открытия свечи
sv_close = iClose(NULL,0,1); // цена закрытия свечи на предыдущем баре
PA = Bid; // получение текущей цены
RefreshRates ();
}//1  

// ================= Обработка сигналов ===============================
{//2
if ((PA < MA_1_t) && (MA_1_t < MA_1_p) && (PA < sv_close) && (TimeBar_t==TimeBarOpen))   NewBuy = 1; else NewBuy = 0; // условие BUY
if ((PA > MA_1_t) && (MA_1_t > MA_1_p) && (PA > sv_close) && (TimeBar_t==TimeBarOpen))   NewSell = 1; else NewSell = 0; // условие BUY
}//2

// ================= Открытие сделки ===================================
{//3
// открытие BUY 
if ((NewBuy == 1) && (ExistPositions() == false)) OrderSend(Symbol(),OP_BUY,Lot,Ask,Slippage, SL == 0 ? 0.0 : NormalizeDouble(Ask - SL*Point()*mtp, Digits()),SL == 0 ? 0.0 : NormalizeDouble(Ask + TP*Point()*mtp, Digits()),GetNameOP,mn,0,LightSkyBlue);
// открытие Sell
if ((NewSell == 1) && (ExistPositions() == false)) OrderSend(Symbol(),OP_SELL,Lot,Bid,Slippage,SL == 0 ? 0.0 : NormalizeDouble(Bid + SL*Point()*mtp, Digits()),TP == 0 ? 0.0 : NormalizeDouble(Bid - TP*Point()*mtp, Digits()),GetNameOP,mn,0,HotPink);

}//3

// ================= Закрытие сделки ===================================

{//4

if (NewBuy == 1) 
{
ClossAllProfitSell ();
ClossAllLossSell();
}

if (NewSell == 1) 
{
ClossAllProfitBuy ();
ClossAllLossBuy();
}

}//4
// ================= Комментарии ======================================

{//5

Comment("Работаем :)");    // Комментарий в угол окна  

}//5
// =====================================================================
   return(0);
  }//0
// ================= Функции ==========================================
//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 06.03.2008                                                     |
//|  Описание : Возвращает флаг существования позиций                          |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    sy - наименование инструмента   (""   - любой символ,                   |
//|                                     NULL - текущий символ)                 |
//|    op - операция                   (-1   - любая позиция)                  |
//|    mn - MagicNumber                (-1   - любой магик)                    |
//|    ot - время открытия             ( 0   - любое время открытия)           |
//+----------------------------------------------------------------------------+
bool ExistPositions(string sy="", int op=-1, datetime ot=0) {
  int i, k=OrdersTotal();
 
  if (sy=="0") sy=Symbol();
  for (i=0; i<k; i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==sy || sy=="") {
        if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
          if (op<0 || OrderType()==op) {
            if (mn<0 || OrderMagicNumber()==mn) {
              if (ot<=OrderOpenTime()) return(True);
            }
          }
        }
      }
    }
  }
  return(False);
}

//END

//+------------------------------------------------------------------+
//|                 Закрыть прибыльные ордера                        |
//+------------------------------------------------------------------+
// ====================== Закрыть BUY в профите ===============================
double ClossAllProfitBuy ()

{
   int Profit1=Slippage;
   int col1=Gold;
   int ask1, bid1, open1;
   double point1;
   for (int i1=OrdersTotal()-1; i1>=0; i1--)
   {
      if (!OrderSelect(i1,SELECT_BY_POS,MODE_TRADES)) break;
      if (OrderType()==OP_BUY)
      {
         point1=MarketInfo(Symbol(),MODE_POINT);
         if (point1==0) break;
         bid1=MathRound(MarketInfo(OrderSymbol(),MODE_BID)/point1);
         open1=MathRound(OrderOpenPrice()/point1);
         if (bid1-open1<Profit1) continue;
         OrderClose(OrderTicket(),OrderLots(),bid1*point1,Slippage,col1);
      }
//      if (OrderType()==OP_SELL)
//      {
//         point=MarketInfo(Symbol(),MODE_POINT);
//         if (point==0) break;
//         ask=MathRound(MarketInfo(OrderSymbol(),MODE_ASK)/point);
//         open=MathRound(OrderOpenPrice()/point);
//         if (open-ask<Profit) continue;
//         OrderClose (OrderTicket(),OrderLots(),ask*point,slip,col) ;
//      }
   }
}
// End

// ====================== Закрыть SELL в профите ===============================
double ClossAllProfitSell ()

{
   int Profit2=Slippage;
   int col2=Gold;
   int ask2, bid2, open2;
   double point2;
   for (int i2=OrdersTotal()-1; i2>=0; i2--)
   {
      if (!OrderSelect(i2,SELECT_BY_POS,MODE_TRADES)) break;
//      if (OrderType()==OP_BUY)
//      {
//         point=MarketInfo(Symbol(),MODE_POINT);
//         if (point==0) break;
//         bid=MathRound(MarketInfo(OrderSymbol(),MODE_BID)/point);
//         open=MathRound(OrderOpenPrice()/point);
//         if (bid-open<Profit) continue;
//         OrderClose(OrderTicket(),OrderLots(),bid*point,slip,col);
//      }
      if (OrderType()==OP_SELL)
      {
         point2=MarketInfo(Symbol(),MODE_POINT);
         if (point2==0) break;
         ask2=MathRound(MarketInfo(OrderSymbol(),MODE_ASK)/point2);
         open2=MathRound(OrderOpenPrice()/point2);
         if (open2-ask2<Profit2) continue;
         OrderClose (OrderTicket(),OrderLots(),ask2*point2,Slippage,col2) ;
      }
   }
}
// End


//+------------------------------------------------------------------+
//|                 Закрыть убыточные ордера                         |
//+------------------------------------------------------------------+

// ====================== Закрыть BUY в убытке ===============================

double ClossAllLossBuy()
{
   int Stop4=Slippage;
//   int slip=2;
   int ask4, bid4, open4;
   double point4;
   for (int i4=OrdersTotal()-1; i4>=0; i4--)
   {
      if (!OrderSelect(i4,SELECT_BY_POS,MODE_TRADES)) break;
      if (OrderType()==OP_BUY)
      {
         point4=MarketInfo(Symbol(),MODE_POINT);
         if (point4==0) break;
         bid4=MathRound(MarketInfo(Symbol(),MODE_BID)/point4);
         open4=MathRound(OrderOpenPrice()/point4);
         if (open4-bid4<Stop4) continue;
         OrderClose(OrderTicket(),OrderLots(),bid4*point4,Slippage,Red);
      }
//      if (OrderType()==OP_SELL)
//      {
//         point4=MarketInfo(Symbol(),MODE_POINT);
//         if (point4==0) break;
//         ask4=MathRound(MarketInfo(Symbol(),MODE_ASK)/point4);
//         open4=MathRound(OrderOpenPrice()/point4);
//         if (ask4-open4<Stop4) continue;
//         OrderClose (OrderTicket(),OrderLots(),ask4*point4,slip,Red);
//      }
   }
}
// End

// ====================== Закрыть SELL в убытке ===============================

double ClossAllLossSell()
{
   int Stop5=Slippage;
//   int slip=2;
   int ask5, bid5, open5;
   double point5;
   for (int i5=OrdersTotal()-1; i5>=0; i5--)
   {
      if (!OrderSelect(i5,SELECT_BY_POS,MODE_TRADES)) break;
//      if (OrderType()==OP_BUY)
//      {
//         point5=MarketInfo(Symbol(),MODE_POINT);
//         if (point5==0) break;
//         bid5=MathRound(MarketInfo(Symbol(),MODE_BID)/point5);
//         open5=MathRound(OrderOpenPrice()/point5);
//         if (open5-bid5<Stop5) continue;
//         OrderClose(OrderTicket(),OrderLots(),bid5*point5,slip,Red);
//      }
      if (OrderType()==OP_SELL)
      {
         point5=MarketInfo(Symbol(),MODE_POINT);
         if (point5==0) break;
         ask5=MathRound(MarketInfo(Symbol(),MODE_ASK)/point5);
         open5=MathRound(OrderOpenPrice()/point5);
         if (ask5-open5<Stop5) continue;
         OrderClose (OrderTicket(),OrderLots(),ask5*point5,Slippage,Red);
      }
   }
}
// End

